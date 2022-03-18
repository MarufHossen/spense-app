import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spense_app/constants.dart';
import 'package:spense_app/data/local/local_service.dart';
import 'package:spense_app/data/service/global_service.dart';
import 'package:spense_app/essential/translations.dart';
import 'package:spense_app/ui/auth/splash/splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

Future<void> initializeAppEssentials() async {
  Get.log('Starting services ...');

  await Firebase.initializeApp();
  await GetStorage.init();
  Get.lazyPut(() => LocalService());
  Get.lazyPut(() => GlobalService());

  Get.log('All services started...');
}

Future<void> main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await initializeAppEssentials();

      if (defaultTargetPlatform == TargetPlatform.android) {
        InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
      }

      // FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

      // Pass all uncaught errors from the framework to Crashlytics.
      // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      runApp(MyApp());
    },
    (error, stackTrace) {
      // FirebaseCrashlytics.instance.recordError(error, stackTrace);
    },
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    return GetMaterialApp(
      enableLog: kDebugMode,
      translations: Messages(),
      locale: Locale('en'),
      fallbackLocale: Locale('en'),
      theme: ThemeData(
        backgroundColor: Colors.white,
        primaryColor: colorPrimary,
        fontFamily: 'Product Sans',
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: colorAccent),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
