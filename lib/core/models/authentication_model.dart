import 'package:json_annotation/json_annotation.dart';

part 'authentication_model.g.dart';

@JsonSerializable()
class UserAuthModel {
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  @JsonKey(name: 'email_id')
  final String emailId;
  @JsonKey(name: 'mobile_no')
  final String mobileNo;
  @JsonKey(name: 'password')
  final String password;

  UserAuthModel({
    required this.firstName,
    required this.lastName,
    required this.emailId,
    required this.mobileNo,
    required this.password,
  });

  factory UserAuthModel.fromJson(Map<String, dynamic> json) => _$UserAuthModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserAuthModelToJson(this);
}
