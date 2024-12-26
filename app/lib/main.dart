import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:daily_e/src/presentation/layout_app.dart';
import 'package:daily_e/src/presentation/setting_page.dart';
import 'package:daily_e/src/provider/FontProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daily_e/src/presentation/theme_provider.dart';

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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FontProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Đã thêm chính xác
      ],
      child: const MyApp(),
    ),
  );
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
        id: 1,
        channelKey: 'basic_channel',
        title: 'Lời nhắc hàng ngày',
        body: 'Học bài liền tay, tiến bước tương lai!',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: 20,
        minute: 0,
        second: 0,
        millisecond: 0,
        repeats: true,
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
    return Consumer2<FontProvider, ThemeProvider>(
      builder: (context, fontProvider, themeProvider, child) {
        return MaterialApp(
          title: 'Daily E',
          theme: ThemeData.light().copyWith(
            textTheme: TextTheme(
              bodyMedium: TextStyle(
                fontSize: fontProvider.fontSize,
                fontFamily: fontProvider.fontFamily,
              ),
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            textTheme: TextTheme(
              bodyMedium: TextStyle(
                fontSize: fontProvider.fontSize,
                fontFamily: fontProvider.fontFamily,
              ),
            ),
          ),
          themeMode: themeProvider.themeMode, // Gán themeMode từ ThemeProvider
          home: const LayoutApp(),
        );
      },
    );
  }
}
