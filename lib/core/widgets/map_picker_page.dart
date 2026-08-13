import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../theme/app_palette.dart';

/// صفحة اختيار الموقع من الخريطة
/// ترجع [MapPickerResult] عند الضغط على "تأكيد الموقع"
class MapPickerPage extends StatefulWidget {
  const MapPickerPage({super.key});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  final MapController _mapController = MapController();

  LatLng _selectedLocation = const LatLng(33.5138, 36.2765); // دمشق افتراضياً
  String _locationName = '';
  bool _isLoadingName = false;
  bool _isLocating = false;

  /// يُصبح true بمجرد أن يضغط المستخدم على الخريطة لاختيار موقع يدوياً.
  /// يمنع _goToCurrentLocation من الكتابة فوق اختيار المستخدم.
  bool _userPickedManually = false;

  @override
  void initState() {
    super.initState();
    _goToCurrentLocation();
  }

  Future<void> _goToCurrentLocation() async {
    if (!mounted) return;
    setState(() => _isLocating = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!mounted) return;
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (!mounted) return;
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (!mounted) return;
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      if (!mounted) return;

      final current = LatLng(pos.latitude, pos.longitude);

      // إذا اختار المستخدم موقعاً يدوياً أثناء جلب الـ GPS، لا نكتب فوقه.
      // فقط نحرك الكاميرا إن لم يكن قد حدد بعد، أو إن طلب ذلك صراحةً.
      if (!_userPickedManually) {
        setState(() => _selectedLocation = current);
        await _fetchLocationName(current);
      }
      if (!mounted) return;
      _mapController.move(current, 15);
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  Future<void> _fetchLocationName(LatLng point) async {
    if (!mounted) return;
    setState(() {
      _isLoadingName = true;
      _locationName = '';
    });
    try {
      final placemarks = await placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );
      if (!mounted) return;
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final parts = [
          p.street,
          p.subLocality,
          p.locality,
          p.administrativeArea,
        ].where((s) => s != null && s.isNotEmpty).toList();
        setState(() => _locationName = parts.join('، '));
      }
    } catch (_) {
      if (mounted) setState(() => _locationName = '');
    } finally {
      if (mounted) setState(() => _isLoadingName = false);
    }
  }

  void _onMapTap(TapPosition _, LatLng point) {
    setState(() {
      _selectedLocation = point;
      _userPickedManually = true; // المستخدم حدد موقعاً يدوياً
    });
    _fetchLocationName(point);
  }

  void _confirm() {
    Get.back(
      result: MapPickerResult(
        latitude: _selectedLocation.latitude,
        longitude: _selectedLocation.longitude,
        locationName: _locationName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: const Text(
          'تحديد موقع التسليم',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (_isLocating)
            Padding(
              padding: const EdgeInsets.all(14),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: context.colors.textPrimary,
                  strokeWidth: 2,
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.my_location_rounded),
              onPressed: () {
                // المستخدم طلب صراحةً العودة لموقعه الحالي → نسمح بالكتابة
                setState(() => _userPickedManually = false);
                _goToCurrentLocation();
              },
              tooltip: 'موقعي الحالي',
            ),
        ],
      ),
      body: Stack(
        children: [
          // ── Map ──────────────────────────────────────────────────────
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedLocation,
              initialZoom: 13,
              onTap: _onMapTap,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.shamsoung',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _selectedLocation,
                    width: 50,
                    height: 50,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 48,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // ── Bottom info + confirm ─────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.colors.shadow,
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: context.colors.accent,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _isLoadingName
                            ? Text(
                                'جارٍ تحديد اسم الموقع...',
                                style: TextStyle(
                                  color: context.colors.textSecondary,
                                  fontSize: 13,
                                ),
                              )
                            : Text(
                                _locationName.isNotEmpty
                                    ? _locationName
                                    : 'اضغط على الخريطة لاختيار الموقع',
                                style: TextStyle(
                                  color: context.colors.textPrimary,
                                  fontSize: 13,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _confirm,
                      icon: const Icon(Icons.check_rounded),
                      label: const Text(
                        'تأكيد الموقع',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Hint overlay ──────────────────────────────────────────────
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: context.colors.overlay,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'اضغط على الخريطة لتحديد موقع التسليم',
                  style: TextStyle(
                    color: context.colors.textOnPrimary.withValues(alpha: 0.9),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MapPickerResult {
  final double latitude;
  final double longitude;
  final String locationName;

  const MapPickerResult({
    required this.latitude,
    required this.longitude,
    required this.locationName,
  });
}
