import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shamsoung/core/services/notification_service.dart';
import 'package:shamsoung/core/services/storage_service.dart';
import 'package:shamsoung/core/translations/app_translations.dart';

import 'core/route/app_pages.dart';
import 'core/route/app_routes.dart';

void main() async {
  // Preserve the native splash until we explicitly remove it
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await GetStorage.init();
  await Firebase.initializeApp();
  await NotificationService.initialize();

  final storage = StorageService();
  final savedLanguage = storage.getLanguage();

  final locale = savedLanguage == 'ar'
      ? const Locale('ar', 'SA')
      : const Locale('en', 'US');

  // Native splash stays briefly, then loading screen takes over
  Future.delayed(const Duration(milliseconds: 800), () {
    FlutterNativeSplash.remove();
  });

  runApp(
    MyApp(
      // Always start at the loading screen — it handles navigation logic
      initialRoute: AppRoutes.loading,
      locale: locale,
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final Locale locale;

  const MyApp({super.key, required this.initialRoute, required this.locale});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: AppPages.pages,

      // ── Translations ──────────────────────────────────────────
      translations: AppTranslations(),
      locale: locale,
      fallbackLocale: const Locale('en', 'US'),

      // ── RTL / LTR support ─────────────────────────────────────
      builder: (context, child) {
        return Directionality(
          textDirection: Get.locale?.languageCode == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: child!,
        );
      },
    );
  }
}
