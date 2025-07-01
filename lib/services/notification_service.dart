import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:typed_data';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Timezone veritabanını başlat
    tz.initializeTimeZones();

    // Android başlatma ayarları
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS başlatma ayarları
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    // Her iki platform için başlatma ayarları
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    // Eklentiyi başlat
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Android 13+ için izinleri iste
    await _requestAndroidPermissions();
  }

  Future<void> _requestAndroidPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await androidImplementation?.requestNotificationsPermission();
    await androidImplementation?.requestExactAlarmsPermission();
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    // Bildirim gönderimi yoruma alındı.
    // final AndroidNotificationDetails androidDetails =
    //     AndroidNotificationDetails(
    //       'pomodoro_channel',
    //       'Pomodoro Notifications',
    //       channelDescription: 'Notifications for Pomodoro timers',
    //       importance: Importance.max,
    //       priority: Priority.high,
    //       ticker: 'ticker',
    //       enableVibration: true,
    //     );

    // const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    // final NotificationDetails notificationDetails = NotificationDetails(
    //   android: androidDetails,
    //   iOS: iosDetails,
    // );

    // await flutterLocalNotificationsPlugin.show(
    //   id,
    //   title,
    //   body,
    //   notificationDetails,
    // );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'pomodoro_channel_scheduled',
          'Pomodoro Scheduled Notifications',
          channelDescription: 'Notifications for scheduled Pomodoro timers',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          enableVibration: true,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> showOngoingNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'pomodoro_ongoing_channel',
          'Pomodoro Ongoing Notifications',
          channelDescription: 'Ongoing notification for Pomodoro timer',
          importance: Importance.low,
          priority: Priority.low,
          ongoing: true,
          showWhen: false,
          onlyAlertOnce: true,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }

  Future<void> cancelOngoingNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
