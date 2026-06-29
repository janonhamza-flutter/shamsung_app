import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shamsoung/core/services/notification_service.dart';
import 'package:shamsoung/core/services/storage_service.dart';

import 'core/route/app_pages.dart';
import 'core/route/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  await Firebase.initializeApp();
  await NotificationService.initialize();

  final storage = StorageService();
  final isLoggedIn = storage.isLoggedIn();

  runApp(MyApp(initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.splash));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
     
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,

      getPages: AppPages.pages,
    );
  }
}
