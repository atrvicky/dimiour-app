// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) {
  return Notification(
    apiCreatedAt: json['createdAt'] as String,
  )
    ..apiNotificationType =
        json['notificationType'] as String? ?? 'NotificationType.Quote'
    ..acknowledged = json['ack'] as bool? ?? false
    ..responded = json['responded'] as bool? ?? false;
}

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'createdAt': instance.apiCreatedAt,
      'notificationType': instance.apiNotificationType,
      'ack': instance.acknowledged,
      'responded': instance.responded,
    };

UserTimeline _$UserTimelineFromJson(Map<String, dynamic> json) {
  return UserTimeline(
    notifications: (json['entries'] as List<dynamic>?)
            ?.map((e) => Notification.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$UserTimelineToJson(UserTimeline instance) =>
    <String, dynamic>{
      'entries': instance.notifications,
    };
