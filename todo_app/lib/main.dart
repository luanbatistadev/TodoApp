import 'dart:async';

import 'package:dependency_module/dependency_module.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_do_app/app/modules/splash/presenter/splash_page_,main.dart';
import 'package:todo_do_app/firebase_options.dart';

import 'app/app_module.dart';
import 'app/app_widget.dart';

Future<void> main() async {
  runApp(const SplashPageMain());

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}
