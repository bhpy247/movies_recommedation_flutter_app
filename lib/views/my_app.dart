import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../backend/app_theme/app_theme_provider.dart';
import '../backend/authentication/authentication_provider.dart';
import '../backend/movies/movies_provider.dart';
import '../backend/navigation/navigation_controller.dart';
import '../utils/my_print.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyPrint.printOnConsole("MyApp Build Called");

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppThemeProvider>(create: (_) => AppThemeProvider(), lazy: false),
        ChangeNotifierProvider<AuthenticationProvider>(create: (_) => AuthenticationProvider(), lazy: false),
        ChangeNotifierProvider<MoviesProvider>(create: (_) => MoviesProvider(), lazy: false),
      ],
      child: const MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeProvider>(
      builder: (BuildContext context, AppThemeProvider appThemeProvider,Widget? child) {
        MyPrint.printOnConsole("ThemeMode:${appThemeProvider.getThemeData().brightness}");
        return MaterialApp(

          debugShowCheckedModeBanner: false,
          navigatorKey: NavigationController.mainScreenNavigator,
          title: "Basic Project Structure",
          theme: appThemeProvider.getThemeData(),
          onGenerateRoute: NavigationController.onMainAppGeneratedRoutes,
        );
      },
    );
  }
}