import 'package:flutter/material.dart';
import 'package:moviesapp/backend/movies/movies_provider.dart';
import 'package:provider/provider.dart';
import 'package:moviesapp/backend/authentication/authentication_provider.dart';
import 'package:moviesapp/utils/my_print.dart';
import 'backend/app_theme/app_theme_provider.dart';
import 'backend/navigation/navigation_controller.dart';

import 'init.dart';

Future<void> main() async {
  await runErrorSafeApp();
}

