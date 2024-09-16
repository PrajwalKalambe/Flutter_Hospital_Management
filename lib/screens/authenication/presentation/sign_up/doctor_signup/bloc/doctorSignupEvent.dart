import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignupButtonPressed extends SignupEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String mobileNumber;
  final String password;
  final String specialization;

  const SignupButtonPressed({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobileNumber,
    required this.password,
    required this.specialization,
  });

  @override
  List<Object> get props => [
        firstName,
        lastName,
        email,
        mobileNumber,
        password,
        specialization,
      ];
}
