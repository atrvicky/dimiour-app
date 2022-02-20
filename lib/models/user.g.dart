// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['_id'] as String,
  )
    ..name = json['nickname'] as String? ?? ''
    ..email = json['email'] as String? ?? ''
    ..phone = json['phone'] as String? ?? ''
    ..accessToken = json['accessToken'] as String? ?? ''
    ..workStartHour = json['workStartHour'] as int? ?? 9
    ..workStartMinute = json['workStartMinute'] as int? ?? 0
    ..workEndtHour = json['workEndHour'] as int? ?? 17
    ..workEndMinute = json['workEndMinute'] as int? ?? 0
    ..workDays = json['workDays'] as String? ?? '0111110'
    ..workInfoSetup = json['workInfoSetup'] as bool? ?? false
    ..apiUserType = json['userType'] as String? ?? 'UserType.Admin';
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      '_id': instance.id,
      'nickname': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'accessToken': instance.accessToken,
      'workStartHour': instance.workStartHour,
      'workStartMinute': instance.workStartMinute,
      'workEndHour': instance.workEndtHour,
      'workEndMinute': instance.workEndMinute,
      'workDays': instance.workDays,
      'workInfoSetup': instance.workInfoSetup,
      'userType': instance.apiUserType,
    };
