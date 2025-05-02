import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:moviesapp/views/my_app.dart';

import 'backend/common/app_controller.dart';
import 'configs/firebase_option.dart';
import 'main.dart';
import 'utils/my_http_overrides.dart';
import 'utils/my_print.dart';

/// Runs the app in [runZonedGuarded] to handle all types of errors, including [FlutterError]s.
/// Any error that is caught will be send to Sentry backend
Future<void>? runErrorSafeApp() {
  return runZonedGuarded<Future<void>>(
        () async {
      await initApp();
      runApp(
        const MyApp(),
      );
    },
        (e, s) {
      MyPrint.printOnConsole("Error in runZonedGuarded:$e");
      MyPrint.printOnConsole(s);
      // AnalyticsController().recordError(e, stackTrace);
    },
  );
}

/// It provides initial initialisation the app and its global services
Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppController.isDev = true;

  List<Future> futures = [];

  usePathUrlStrategy();



  if (kIsWeb) {
    FirebaseOptions options = DefaultFirebaseOptions.android;
    MyPrint.printOnConsole(options);

    futures.addAll([
      Firebase.initializeApp(
        options: options,
      ),
      SystemChrome.setPreferredOrientations(<DeviceOrientation>[
        DeviceOrientation.landscapeLeft,
      ]),
    ]);
  }
  else {
    if(Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      HttpOverrides.global = MyHttpOverrides();
      HttpClient httpClient = HttpClient();
      httpClient.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

      futures.addAll([
        Firebase.initializeApp(),
        SystemChrome.setPreferredOrientations(<DeviceOrientation>[
          DeviceOrientation.portraitUp,
        ]),
      ]);
    }
  }

  await Future.wait(futures);
}