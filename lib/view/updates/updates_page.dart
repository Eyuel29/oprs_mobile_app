import 'package:flutter/material.dart';
import 'package:oprs/components/cards/notification%20_card.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/provider/notification_provider.dart';
import 'package:provider/provider.dart';

class UpdatesPage extends StatefulWidget {
  const UpdatesPage({super.key});
  @override
  State<UpdatesPage> createState() => _UpdatesPageState();
}

class _UpdatesPageState extends State<UpdatesPage> {
  @override
  Widget build(BuildContext context) {
    var notificationProvider = Provider.of<NotificationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Updates"),
        backgroundColor: MyColors.mainThemeDarkColor,
        foregroundColor:MyColors.mainThemeLightColor,
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: notificationProvider.loadNotifications,
              child: notificationProvider.pageLoading ?
              Container(
                margin: const EdgeInsets.only(top: 100),
                alignment: Alignment.topCenter,
                child: const SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(
                    color: MyColors.mainThemeDarkColor,
                    strokeWidth: 3,
                  ),
                )
              ) : notificationProvider.allNotifications.isEmpty ?
              Container(
                margin: const EdgeInsets.only(top: 100),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      notificationProvider.errorMessage.isNotEmpty ? notificationProvider.errorMessage : "No Updates",
                      style: TextStyle(fontSize: 14)
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: () {
                        notificationProvider.loadNotifications();
                      },
                      child: const Text("Retry"),
                    )
                  ],
                ),
              ) : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                itemCount: notificationProvider.allNotifications.length,
                itemBuilder: (context, index) {
                  var notification = notificationProvider.allNotifications.reversed.toList()[index];
                  return NotificationCard(notificationModel: notification);
                },
              ),
            ),
          )
        ],
      )
    );
  }
}