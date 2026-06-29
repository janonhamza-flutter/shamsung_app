import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../featurs/notifications/presentation/controller/notification_controller.dart';
import 'storage_service.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Must be a top-level function — runs in a separate isolate
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Background message received: ${message.messageId}');
}

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final StorageService _storage = StorageService();

  static Future<void> initialize() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
    } catch (e) {
      debugPrint('Firebase init failed: $e');
      return;
    }

    // Register background handler first (required before any other setup)
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _initLocalNotifications();
    await _requestPermission();

    // FIX #3: Cache token locally only — do NOT call API here.
    // User may not be logged in yet. Call syncTokenAfterLogin() post-auth.
    await _cacheToken();

    // FIX #2: Foreground — show local banner + add to list
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // FIX #2: Background tap — add to list (no banner needed, system already showed it)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // FIX #2: Terminated tap — handle when app cold-starts from a notification
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  // ─── Token Management ────────────────────────────────────────────────────

  /// Caches FCM token locally. Does NOT call the API.
  static Future<void> _cacheToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null &&
          token.isNotEmpty &&
          _storage.getFcmToken() != token) {
        _storage.saveFcmToken(token);
        debugPrint('FCM token cached locally');
      }
    } catch (e) {
      debugPrint('FCM token cache failed: $e');
    }
  }

  /// Call this after the user successfully logs in or signs up
  /// to register the cached FCM token with the backend.
  static Future<void> syncTokenAfterLogin() async {
    try {
      String token = _storage.getFcmToken();

      // If no cached token yet, fetch a fresh one
      if (token.isEmpty) {
        final fresh = await _messaging.getToken();
        if (fresh == null || fresh.isEmpty) return;
        _storage.saveFcmToken(fresh);
        token = fresh;
      }

      await _registerToken(token);
    } catch (e) {
      debugPrint('FCM token sync failed: $e');
    }
  }

  // ─── Local Notifications Setup ───────────────────────────────────────────

  static Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('Local notification tapped: ${response.payload}');
      },
    );
  }

  static Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('Notification permission: ${settings.authorizationStatus}');
  }

  // ─── Message Handlers ────────────────────────────────────────────────────

  /// Foreground: show a local notification banner + add to in-app list
  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    _ensureNotificationController().addRemoteNotification(message);

    // Only show a banner if the message carries a notification payload
    final notification = message.notification;
    if (notification == null) return;

    await flutterLocalNotificationsPlugin.show(
      id: message.hashCode,
      title: notification.title ?? 'New notification',
      body: notification.body ?? '',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'default_channel',
          'General Notifications',
          channelDescription: 'App general notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: message.data.toString(),
    );
  }

  /// Background / terminated: app opened by tapping the notification
  static void _handleNotificationTap(RemoteMessage message) {
    debugPrint('Notification tap opened app: ${message.messageId}');
    _ensureNotificationController().addRemoteNotification(message);
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  static Future<void> _registerToken(String token) async {
    await _ensureNotificationController().updateFcmToken(token);
  }

  // FIX #1: Always use permanent: true so there is exactly one instance
  // whether the controller is accessed here before any page opens,
  // or later via NotificationBinding.
  static NotificationController _ensureNotificationController() {
    if (Get.isRegistered<NotificationController>()) {
      return Get.find<NotificationController>();
    }
    return Get.put<NotificationController>(
      NotificationController(),
      permanent: true,
    );
  }
}
