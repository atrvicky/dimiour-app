// ignore_for_file: avoid_init_to_null

import 'package:app/helpers/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: '_id')
  String id = '';
  @JsonKey(name: 'nickname', defaultValue: '')
  String name = '';
  @JsonKey(name: 'email', defaultValue: '')
  String email = '';
  @JsonKey(name: 'phone', defaultValue: '')
  String phone = '';
  @JsonKey(name: 'accessToken', defaultValue: '')
  String accessToken = '';
  @JsonKey(name: 'workStartHour', defaultValue: 9)
  int workStartHour = 9;
  @JsonKey(name: 'workStartMinute', defaultValue: 0)
  int workStartMinute = 0;
  @JsonKey(name: 'workEndHour', defaultValue: 17)
  int workEndtHour = 17;
  @JsonKey(name: 'workEndMinute', defaultValue: 0)
  int workEndMinute = 0;
  @JsonKey(name: 'workDays', defaultValue: '0111110')
  String workDays = '0111110';
  @JsonKey(name: 'workInfoSetup', defaultValue: false)
  bool workInfoSetup = false;

  @JsonKey(name: 'userType', defaultValue: 'UserType.Admin')
  String apiUserType = UserType.Admin.toString();
  @JsonKey(ignore: true)
  UserType userType = UserType.User;

  @JsonKey(ignore: true)
  UserState? loginState = UserState.LoggedOut;

  User({
    this.id = '',
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
