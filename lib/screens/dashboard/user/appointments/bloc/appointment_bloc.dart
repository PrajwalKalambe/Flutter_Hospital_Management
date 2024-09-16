import 'package:dio/dio.dart';
import 'package:doctor_management/constants/strings.dart';
import 'package:doctor_management/screens/dashboard/user/appointments/bloc/appointment_event.dart';
import 'package:doctor_management/screens/dashboard/user/appointments/bloc/appointment_state.dart';
import 'package:doctor_management/screens/dashboard/user/user_dashboard.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final Dio _dio = Dio(); // Initialize Dio
  Constants str=Constants();

  AppointmentBloc() : super(AppointmentState()) {
    on<LoadAppointmentData>(_onLoadAppointmentData);
    on<SelectDate>(_onSelectDate);
    on<SelectTime>(_onSelectTime);
    on<ToggleCalendar>(_onToggleCalendar);
    on<BookAppointment>(_onBookAppointment);
  }

  void _onLoadAppointmentData(LoadAppointmentData event, Emitter<AppointmentState> emit) {
    emit(state.copyWith(doctor: event.doctor));
  }

  void _onSelectDate(SelectDate event, Emitter<AppointmentState> emit) {
    emit(state.copyWith(selectedDate: event.date));
  }

  void _onSelectTime(SelectTime event, Emitter<AppointmentState> emit) {
    emit(state.copyWith(selectedTime: event.time));
  }

  void _onToggleCalendar(ToggleCalendar event, Emitter<AppointmentState> emit) {
    emit(state.copyWith(isCalendarVisible: !state.isCalendarVisible));
  }

  Future<void> _onBookAppointment(BookAppointment event, Emitter<AppointmentState> emit) async {
    try {
      // Book the appointment
      final userResponse = await _dio.post(
        'https://66d18e2962816af9a4f411ef.mockapi.io/appointments',
        data: {
          'doctor_id': event.doctorId,
          'date': DateFormat('yyyy-MM-dd').format(event.date),
          'time': event.time,
          'user_name': user_name, 
          'user_id': user_id, // Ensure user_id is the correct type
        },
      );

      if (userResponse.statusCode == 200 || userResponse.statusCode == 201) {
        // On successful booking, send notification
        final notificationResponse = await _dio.post(
          'https://66d18e2962816af9a4f411ef.mockapi.io/notifications', 
          data: {
            'user_name': user_name, 
            'message': '${user_name} has booked an appointment with the doctor on ${event.date} at ${event.time}.',
            'doctor_id': event.doctorId, 
            'user_id': user_id, // Ensure user_id is the correct type
          },
        );

        if (notificationResponse.statusCode == 200 || notificationResponse.statusCode == 201) {
          emit(state.copyWith(isBookingSuccessful: true));
        } else {
          emit(state.copyWith(errorMessage: str.failedToSendNotification));
          // Consider logging the response body here
        }
      } else {
        emit(state.copyWith(errorMessage: str.failedToBookNotification));
        // Consider logging the response body here
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: str.errorOccured));
      // Log the error for debugging
      print('Booking Error: $e');
    }
  }
}
