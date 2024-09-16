import 'package:equatable/equatable.dart';

abstract class SignupState extends Equatable {
  const SignupState();
  
  @override
  List<Object> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {
  final String message;

  const SignupSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class SignupFailure extends SignupState {
  final String error;

  const SignupFailure(this.error);

  @override
  List<Object> get props => [error];
}