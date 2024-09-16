abstract class AppointmentEvent {}

class LoadAppointmentData extends AppointmentEvent {
  final Map<String, dynamic> doctor;
  LoadAppointmentData(this.doctor);
}

class SelectDate extends AppointmentEvent {
  final DateTime date;
  SelectDate(this.date);
}

class SelectTime extends AppointmentEvent {
  final String time;
  SelectTime(this.time);
}

class ToggleCalendar extends AppointmentEvent {}

class BookAppointment extends AppointmentEvent {
  final DateTime date;
  final String time;
  final String doctorId;

  BookAppointment({required this.date, required this.time, required this.doctorId});
}