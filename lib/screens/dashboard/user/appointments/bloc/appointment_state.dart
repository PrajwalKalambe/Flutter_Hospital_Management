class AppointmentState {
  final Map<String, dynamic> doctor;
  final DateTime selectedDate;
  final String? selectedTime;
  final bool isCalendarVisible;
  final bool isBookingSuccessful;
  final String? errorMessage;

  AppointmentState({
    this.doctor = const {},
    DateTime? selectedDate,
    this.selectedTime,
    this.isCalendarVisible = false,
    this.isBookingSuccessful = false,
    this.errorMessage,
  }) : selectedDate = selectedDate ?? DateTime.now();

  AppointmentState copyWith({
    Map<String, dynamic>? doctor,
    DateTime? selectedDate,
    String? selectedTime,
    bool? isCalendarVisible,
    bool? isBookingSuccessful,
    String? errorMessage,
  }) {
    return AppointmentState(
      doctor: doctor ?? this.doctor,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      isCalendarVisible: isCalendarVisible ?? this.isCalendarVisible,
      isBookingSuccessful: isBookingSuccessful ?? this.isBookingSuccessful,
      errorMessage: errorMessage,
    );
  }
}