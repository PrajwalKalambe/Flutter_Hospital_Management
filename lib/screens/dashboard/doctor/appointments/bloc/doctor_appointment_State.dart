import 'package:doctor_management/screens/dashboard/doctor/appointments/bloc/doctor_appointment_bloc.dart';
import 'package:equatable/equatable.dart';

abstract class DoctorAppointmentsState extends Equatable {
  const DoctorAppointmentsState();

  @override
  List<Object> get props => [];
}

class DoctorAppointmentsInitial extends DoctorAppointmentsState {}

class DoctorAppointmentsLoading extends DoctorAppointmentsState {}

class DoctorAppointmentsLoaded extends DoctorAppointmentsState {
  final List<Appointment> appointments;

  const DoctorAppointmentsLoaded(this.appointments);

  @override
  List<Object> get props => [appointments];
}

class DoctorAppointmentsError extends DoctorAppointmentsState {
  final String message;

  const DoctorAppointmentsError(this.message);

  @override
  List<Object> get props => [message];
}
