import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationManager{
  static Future<void> initialize(FlutterLocalNotificationsPlugin flnp) async {
    var androdiInitialization =  const AndroidInitializationSettings("minmap/ic_launcher");
    var initializationSettings = InitializationSettings(android: androdiInitialization);
    await flnp.initialize(initializationSettings);
  }

  static Future<void> showNotification({
    int id = 0,
    required String title,
    required String body,
    var payload,
    required FlutterLocalNotificationsPlugin flnp}
    ) async{

    var androidNotificationDetails = const AndroidNotificationDetails(
        "0",
        "OPRS",
        playSound: true,
        importance: Importance.max,
        priority: Priority.high
    );

    var notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await flnp.show(id, title, body, notificationDetails);
  }
}