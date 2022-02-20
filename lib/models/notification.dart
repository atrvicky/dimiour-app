import 'package:app/helpers/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

class PushNotification {
  String id = '';
  String title = '';
  String body = '';
  String dataType = '';
  String dataBody = '';

  NotificationType? type;

  PushNotification({
    this.id = '',
    required this.title,
    required this.body,
    required this.dataType,
    required this.dataBody,
    this.type,
  });

  factory PushNotification.fromMessage(RemoteMessage message) {
    PushNotification notification = PushNotification(
      title: message.notification?.title! ?? '',
      body: message.notification?.body! ?? '',
      dataType: message.data['type'],
      id: message.data['notificationID'],
      dataBody: message.data['body'],
    );
    if (notification.dataType == NotificationType.FoodBreak.toString()) {
      notification.type = NotificationType.FoodBreak;
    } else if (notification.dataType ==
        NotificationType.WaterBreak.toString()) {
      notification.type = NotificationType.WaterBreak;
    } else if (notification.dataType ==
        NotificationType.WorkBreakLong.toString()) {
      notification.type = NotificationType.WorkBreakLong;
    } else if (notification.dataType ==
        NotificationType.WorkBreakLong.toString()) {
      notification.type = NotificationType.WorkBreakLong;
    } else if (notification.dataType ==
        NotificationType.WorkResume.toString()) {
      notification.type = NotificationType.WorkResume;
    } else if (notification.dataType == NotificationType.Posture.toString()) {
      notification.type = NotificationType.Posture;
    } else if (notification.dataType == NotificationType.Quote.toString()) {
      notification.type = NotificationType.Quote;
    }
    return notification;
  }
}

@JsonSerializable()
class Notification {
  @JsonKey(name: 'createdAt')
  String apiCreatedAt = '';
  @JsonKey(name: 'notificationType', defaultValue: 'NotificationType.Quote')
  String apiNotificationType = 'NotificationType.Quote';
  @JsonKey(name: 'ack', defaultValue: false)
  bool acknowledged = false;
  @JsonKey(name: 'responded', defaultValue: false)
  bool responded = false;

  @JsonKey(ignore: true)
  DateTime createdTime = DateTime.now();
  @JsonKey(ignore: true)
  String formattedTime = '';
  @JsonKey(ignore: true)
  int timeStamp = 0;
  @JsonKey(ignore: true)
  NotificationType type = NotificationType.Quote;

  Notification({
    this.apiCreatedAt = '',
  });

  String getFormattedType() {
    return type == NotificationType.WaterBreak
        ? 'Water Break'
        : type == NotificationType.FoodBreak
            ? 'Food break'
            : type == NotificationType.WorkBreakShort
                ? 'Short Break'
                : type == NotificationType.WorkBreakLong
                    ? 'Long break'
                    : type == NotificationType.Posture
                        ? 'Fix Posture'
                        : 'Motivate';
  }

  factory Notification.fromJson(Map<String, dynamic> json) {
    DateFormat dateFormat = DateFormat('HH:mm');

    Notification notification = _$NotificationFromJson(json);
    notification.createdTime =
        DateTime.parse(notification.apiCreatedAt).toLocal();
    notification.formattedTime = dateFormat.format(notification.createdTime);
    notification.timeStamp =
        DateTime.parse(notification.apiCreatedAt).millisecondsSinceEpoch;

    if (notification.apiNotificationType ==
        NotificationType.FoodBreak.toString()) {
      notification.type = NotificationType.FoodBreak;
    } else if (notification.apiNotificationType ==
        NotificationType.WaterBreak.toString()) {
      notification.type = NotificationType.WaterBreak;
    } else if (notification.apiNotificationType ==
        NotificationType.WorkBreakLong.toString()) {
      notification.type = NotificationType.WorkBreakLong;
    } else if (notification.apiNotificationType ==
        NotificationType.WorkBreakLong.toString()) {
      notification.type = NotificationType.WorkBreakLong;
    } else if (notification.apiNotificationType ==
        NotificationType.WorkResume.toString()) {
      notification.type = NotificationType.WorkResume;
    } else if (notification.apiNotificationType ==
        NotificationType.Posture.toString()) {
      notification.type = NotificationType.Posture;
    } else if (notification.apiNotificationType ==
        NotificationType.Quote.toString()) {
      notification.type = NotificationType.Quote;
    }

    return notification;
  }
  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}

@JsonSerializable()
class UserTimeline {
  @JsonKey(name: 'entries', defaultValue: [])
  List<Notification> notifications = [];

  UserTimeline({
    this.notifications = const [],
  });

  factory UserTimeline.fromJson(Map<String, dynamic> json) =>
      _$UserTimelineFromJson(json);

  Map<String, dynamic> toJson() => _$UserTimelineToJson(this);
}
