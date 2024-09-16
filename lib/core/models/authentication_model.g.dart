// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAuthModel _$UserAuthModelFromJson(Map<String, dynamic> json) =>
    UserAuthModel(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      emailId: json['email_id'] as String,
      mobileNo: json['mobile_no'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$UserAuthModelToJson(UserAuthModel instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email_id': instance.emailId,
      'mobile_no': instance.mobileNo,
      'password': instance.password,
    };
