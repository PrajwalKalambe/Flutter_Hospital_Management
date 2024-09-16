import 'package:equatable/equatable.dart';

// Events
abstract class DoctorAppointmentsEvent extends Equatable {
  const DoctorAppointmentsEvent();

  @override
  List<Object> get props => [];
}

class FetchAppointments extends DoctorAppointmentsEvent {
  final String doctorId;

  const FetchAppointments(this.doctorId);

  @override
  List<Object> get props => [doctorId];
}