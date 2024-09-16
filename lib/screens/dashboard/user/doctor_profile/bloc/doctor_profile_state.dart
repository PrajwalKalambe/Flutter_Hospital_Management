// doctor_profile_state.dart
import 'package:equatable/equatable.dart';

abstract class DoctorProfileState extends Equatable {
  const DoctorProfileState();

  @override
  List<Object?> get props => [];
}

class DoctorProfileInitial extends DoctorProfileState {}

class DoctorProfileLoading extends DoctorProfileState {}

class DoctorProfileLoaded extends DoctorProfileState {
  final Map<String, dynamic> doctor;

  const DoctorProfileLoaded({required this.doctor});

  @override
  List<Object?> get props => [doctor];
}

class DoctorProfileError extends DoctorProfileState {
  final String message;

  const DoctorProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}
