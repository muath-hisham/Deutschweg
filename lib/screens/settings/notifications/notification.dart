import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:menschen/global_values.dart';
import 'package:menschen/models/word_model.dart';
import 'package:timezone/timezone.dart' as tz;

class Notifications {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    var androidInitialize =
        AndroidInitializationSettings('mipmap/launcher_icon');

    // const AndroidInitializationSettings initializationSettingsAndroid =
    //     AndroidInitializationSettings('app_icon');

    // Combine both Android and iOS initialization settings
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitialize,
    );
    // Initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> scheduleHourlyNotification(Word word) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      _titleBuild(word),
      word.translation,
      _nextInstance(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'notification',
          'Review words',
          // channelDescription: 'Channel for hourly notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents:
          DateTimeComponents.time, // Ensures it repeats hourly
    );
  }

  static tz.TZDateTime _nextInstance() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = now.add(Duration(hours: Global.notificationRepeatTime));
    return scheduledDate;
  }

  static String _titleBuild(Word word) {
    String title = word.artical!;
    if (title.isNotEmpty) title += " ";
    title += word.word;
    return title;
  }
}
