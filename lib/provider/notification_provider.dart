import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:oprs/model/notification.dart';
import 'package:oprs/repo/notification_repo.dart';
import 'package:oprs/view/updates/notification.dart';

class NotificationProvider extends ChangeNotifier {
  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  List<NotificationModel> allNotifications = [];
  int unseenNotificationCount = 0;
  bool pageLoading = false;
  String errorMessage = "";

  NotificationProvider(){
    NotificationManager.initialize(flutterLocalNotificationsPlugin);
  }

  Future<void> onPageRefresh() async {
    loadNotifications();
  }

  Future<void> loadNotificationCount() async {
    pageLoading = true;
    notifyListeners();
    final value = await NotificationRepo().getNotificationCount();
    if (value["status"] == 200) {
      unseenNotificationCount = value["count"] ?? 0;
      errorMessage = "";
    } else {
      errorMessage = value["message"] ?? "Something went wrong!";
    }
    pageLoading = false;
    notifyListeners();
  }

  Future<void> loadNotifications() async {
    pageLoading = true;
    notifyListeners();
    final value = await NotificationRepo().getNotifications();
    if (value["status"] == 200) {
      allNotifications = value["notifications"];
      errorMessage = "";
      if(allNotifications.length == 1){
        await NotificationManager.showNotification(
            id: 0,
            title: allNotifications[0].title,
            body: allNotifications[0].body,
            flnp: flutterLocalNotificationsPlugin
        );
      }else if(allNotifications.length > 1){
        await NotificationManager.showNotification(
            id: 0,
            title: "Notifications!",
            body: "You have $unseenNotificationCount notifications!",
            flnp: flutterLocalNotificationsPlugin
        );
      }
    } else {
      errorMessage = value["message"] ?? "Something went wrong!";
    }
    pageLoading = false;
    notifyListeners();
  }
}