import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:doctor_management/constants/strings.dart';
import 'package:doctor_management/screens/dashboard/doctor/appointments/bloc/doctor_appointment_Event.dart';
import 'package:doctor_management/screens/dashboard/doctor/appointments/bloc/doctor_appointment_State.dart';

class DoctorAppointmentsBloc extends Bloc<DoctorAppointmentsEvent, DoctorAppointmentsState> {
  final Dio _dio = Dio();
  Constants str= Constants();

  DoctorAppointmentsBloc() : super(DoctorAppointmentsInitial()) {
    on<FetchAppointments>(_onFetchAppointments);
  }

  Future<void> _onFetchAppointments(
    FetchAppointments event,
    Emitter<DoctorAppointmentsState> emit,
  ) async {
    emit(DoctorAppointmentsLoading());
    try {
      final response = await _dio.get(
        'https://66d18e2962816af9a4f411ef.mockapi.io/appointments',
        queryParameters: {'doctor_id': event.doctorId},
      );
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<Appointment> appointments = data
          .map((item) => Appointment.fromJson(item))
          .where((appointment) => appointment.userName != null) 
          .toList();
        emit(DoctorAppointmentsLoaded(appointments));
      } else {
        emit(DoctorAppointmentsError(str.failedToLoadAppointment));
      }
    } catch (e) {
      emit(DoctorAppointmentsError(str.failedToLoadAppointment + '$e'));
    }
  }
}

// Model
class Appointment {
  final String id;
  final String doctorId;
  final String date;
  final String time;
  final String createdAt;
  final String userId; 
  final String? userName; 
  String status;

  Appointment({
    required this.id,
    required this.doctorId,
    required this.date,
    required this.time,
    required this.createdAt,
    required this.userId,
    this.userName, // Allow null values
    this.status='pending',
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      doctorId: json['doctor_id'],
      date: json['date'],
      time: json['time'],
      createdAt: json['created_at'],
      userId: json['user_id'].toString(), // Convert userId to String
      userName: json['user_name'], // This will be null if the field is not present
      status:json['status'] ?? 'pending',
    );
  }
}
