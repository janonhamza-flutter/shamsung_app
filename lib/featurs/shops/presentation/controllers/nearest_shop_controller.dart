import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/app_snackbar.dart';
import '../../data/models/shop_model.dart';
import '../../data/repositories/shop_repository.dart';

class NearestShopController extends GetxController {
  final ShopRepository _repository = ShopRepository();

  final RxList<ShopModel> shops = <ShopModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasSearched = false.obs;

  /// موقع المستخدم الحالي — يُستخدم لحساب المسافة لكل صالة
  Position? _userPosition;

  // ── Location cache ─────────────────────────────────────────────────────
  /// آخر موقع تم جلبه
  Position? _cachedPosition;

  /// وقت آخر جلب للموقع
  DateTime? _cacheTime;

  /// مدة صلاحية الـ cache (8 دقائق)
  static const _cacheDuration = Duration(minutes: 8);

  bool get _isCacheValid =>
      _cachedPosition != null &&
      _cacheTime != null &&
      DateTime.now().difference(_cacheTime!) < _cacheDuration;

  @override
  void onInit() {
    super.onInit();
    fetchNearest();
  }

  Future<void> fetchNearest() async {
    try {
      isLoading.value = true;
      hasSearched.value = false;

      final position = await _determinePosition();
      _userPosition = position;

      shops.value = await _repository.findNearest(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      hasSearched.value = true;
    } on _LocationException catch (e) {
      AppSnackbar.error(e.message);
    } catch (e) {
      debugPrint('NearestShopController error: $e');
      AppSnackbar.error('Failed to fetch nearest shops. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // ── Distance helpers ───────────────────────────────────────────────────

  /// يحسب المسافة بالكيلومتر بين موقع المستخدم والصالة
  /// يعيد null إذا لم يكن موقع المستخدم متاحاً
  double? distanceTo(ShopModel shop) {
    if (_userPosition == null) return null;
    return _haversineKm(
      _userPosition!.latitude,
      _userPosition!.longitude,
      shop.latitude,
      shop.longitude,
    );
  }

  /// صيغة Haversine — تعيد المسافة بالكيلومتر
  double _haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0; // نصف قطر الأرض بالكيلومتر
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);
    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRad(lat1)) *
            math.cos(_toRad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return r * c;
  }

  double _toRad(double deg) => deg * math.pi / 180;

  /// نص المسافة جاهز للعرض: "850 م" أو "3.2 كم"
  String? distanceLabel(ShopModel shop) {
    final km = distanceTo(shop);
    if (km == null) return null;
    if (km < 1) return '${(km * 1000).round()} ${'distance_away_m'.tr}';
    return '${km.toStringAsFixed(1)} ${'distance_away_km'.tr}';
  }

  // ── Location ───────────────────────────────────────────────────────────

  Future<Position> _determinePosition() async {
    // ── استخدم الـ cache إذا كان صالحاً ──────────────────────────────────
    if (_isCacheValid) {
      debugPrint(
        'NearestShop: using cached location (${DateTime.now().difference(_cacheTime!).inSeconds}s old)',
      );
      return _cachedPosition!;
    }

    // 1. تحقق من تفعيل خدمات الموقع
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw _LocationException(
        'Location services are disabled. Please enable them in your device settings.',
      );
    }

    // 2. تحقق من الصلاحية / اطلبها
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw _LocationException(
          'Location permission denied. Please allow access to find nearby shops.',
        );
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw _LocationException(
        'Location permission permanently denied. Enable it from app settings.',
      );
    }

    // 3. احصل على الموقع وخزّنه في الـ cache
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );

    _cachedPosition = position;
    _cacheTime = DateTime.now();
    debugPrint('NearestShop: fresh location fetched and cached');

    return position;
  }
}

/// Internal exception for clean error messaging
class _LocationException implements Exception {
  final String message;
  const _LocationException(this.message);
}
