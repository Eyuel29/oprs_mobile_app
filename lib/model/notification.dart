import 'package:oprs/model/user.dart';
class NotificationModel{
    User initiator;
    int receiverId;
    String type;
    String title;
    String body;
    bool viewed;
    String date;

    NotificationModel({
        required this.initiator,
        required this.receiverId,
        required this.type,
        required this.title,
        required this.body,
        required this.viewed,
        required this.date,
    });

    factory NotificationModel.fromJson(Map<String, dynamic> json) {
        User i = User.fromJson(json["initiator"]);
        var notification = NotificationModel(
            initiator : i,
            receiverId : json["receiver_id"] ?? 0,
            type : json["type"] ?? "",
            title : json["title"] ?? "",
            body : json["body"] ?? "",
            viewed : json["viewed"]  == true || false ? json["viewed"] : json["viewed"] == 1 ? true : false,
            date : json["date"] ?? ""
        );
        return notification;
    }
}