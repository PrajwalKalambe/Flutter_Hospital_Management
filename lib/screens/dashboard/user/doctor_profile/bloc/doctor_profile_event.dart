// doctor_profile_event.dart
import 'package:equatable/equatable.dart';

abstract class DoctorProfileEvent extends Equatable {
  const DoctorProfileEvent();

  @override
  List<Object?> get props => [];
}

class FetchDoctorProfile extends DoctorProfileEvent {
  final int doctorId;

  const FetchDoctorProfile({required this.doctorId});

  @override
  List<Object?> get props => [doctorId];
}
