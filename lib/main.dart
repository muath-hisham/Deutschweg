import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:menschen/screens/settings/notifications/notification.dart';
import 'package:menschen/shared/shared.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/splash.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone data
  tz.initializeTimeZones();

  // Initialize notification plugin
  Notifications.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: MyText.theTitleOfApp,
      theme: ThemeData(
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStatePropertyAll(mainColor),
        ),
        appBarTheme: AppBarTheme(backgroundColor: mainColor),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: mainColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(mainColor),
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
