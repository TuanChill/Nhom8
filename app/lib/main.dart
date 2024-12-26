import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:daily_e/src/presentation/layout_app.dart';
import 'package:daily_e/themes.dart';
import 'package:flutter/material.dart';

void main() {
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'Basic notifications',
      channelDescription: 'Notification channel',
      defaultColor: const Color(0xFF9D50DD),
      ledColor: Colors.white,
    )
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void scheduleDailyNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1, // ID phải là duy nhất
        channelKey: 'basic_channel',
        title: 'Lời nhắc hàng ngày',
        body: 'Học bài liền tay, tiến bước tương lai!',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: 20, // 8h tối
        minute: 0,
        second: 0,
        millisecond: 0,
        repeats: true, // Lặp lại hàng ngày
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    scheduleDailyNotification();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily E',
      theme: lightMode,
      darkTheme: darkMode,
      home: const LayoutApp(),
    );
  }
}
