import 'package:doctor_management/constants/color.dart';
import 'package:doctor_management/constants/strings.dart';
import 'package:doctor_management/screens/dashboard/user/appointments/bloc/appointment_bloc.dart';
import 'package:doctor_management/screens/dashboard/user/appointments/bloc/appointment_event.dart';
import 'package:doctor_management/screens/dashboard/user/appointments/bloc/appointment_state.dart';
import 'package:doctor_management/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentPage extends StatelessWidget {
  final Map<String, dynamic> doctor;

  AppointmentPage({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppointmentBloc()..add(LoadAppointmentData(doctor)),
      child: AppointmentView(),
    );
  }
}

// ignore: must_be_immutable
class AppointmentView extends StatelessWidget {
  final List<String> _timeSlots = ['10:00 AM', '11:00 AM', '12:00 PM'];
  Constants str = Constants();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppointmentBloc, AppointmentState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
        if (state.isBookingSuccessful) {
          _showBookingSuccessDialog(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Doctor's Details"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDoctorInfo(state.doctor),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDateSection(context, state),
                      SizedBox(height: 50),
                      _buildTimeSection(context, state),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(40.0),
            child: CustomElevatedButton(
                label: 'DONE',
                backgroundColor: color.black,
                textColor: color.white,
                borderRadius: 50,
                onPressed: (){
                  final state = context.read<AppointmentBloc>().state;
            if (state.selectedTime != null) {
              context.read<AppointmentBloc>().add(BookAppointment(
                    date: state.selectedDate,
                    time: state.selectedTime!,
                    doctorId: state.doctor['id'],
                  ));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(str.selectDateTime)),
              );
            }
                }),
          ),
        );
      },
    );
  }

  Widget _buildDoctorInfo(Map<String, dynamic> doctor) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/icons/face_image.png'),
        radius: 25,
      ),
      title: Text(
        'Dr. ${doctor['first_name']} ${doctor['last_name']}',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Text(doctor['designation'] ?? 'Heart Specialist'),
    );
  }

  Widget _buildDateSection(BuildContext context, AppointmentState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('DATE', style: TextStyle(fontWeight: FontWeight.bold)),
            TextButton(
              child: Text('Calendar >'),
              onPressed: () =>
                  context.read<AppointmentBloc>().add(ToggleCalendar()),
            ),
          ],
        ),
        if (state.isCalendarVisible)
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(Duration(days: 365)),
            focusedDay: state.selectedDate,
            selectedDayPredicate: (day) => isSameDay(state.selectedDate, day),
            onDaySelected: (
              selectedDay,
              focusedDay,
            ) {
              context.read<AppointmentBloc>().add(SelectDate(selectedDay));
              context.read<AppointmentBloc>().add(ToggleCalendar());
            },
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(5, (index) {
              final date = DateTime.now().add(Duration(days: index));
              return GestureDetector(
                onTap: () =>
                    context.read<AppointmentBloc>().add(SelectDate(date)),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSameDay(state.selectedDate, date)
                        ? Colors.teal
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(DateFormat('d').format(date)),
                      Text(DateFormat('E').format(date)),
                    ],
                  ),
                ),
              );
            }),
          ),
      ],
    );
  }

  Widget _buildTimeSection(BuildContext context, AppointmentState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('TIME', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _timeSlots.map((time) {
            return GestureDetector(
              onTap: () =>
                  context.read<AppointmentBloc>().add(SelectTime(time)),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: state.selectedTime == time
                      ? Colors.teal
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(time,
                    style: TextStyle(
                        color: state.selectedTime == time
                            ? Colors.white
                            : Colors.black)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }



  void _showBookingSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.teal,
                  size: 60,
                ),
                SizedBox(height: 20),
                Text(
                  'BOOKING SUCCESSFUL',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 10),
                Text(str.successfullAppointment),
              ],
            ),
          ),
        );
      },
    );

    // Delay for 3 seconds before navigating back to the DoctorProfilePage
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pop(context); // Close the dialog
      Navigator.pop(context); // Navigate back to the previous page
    });
  }
}
