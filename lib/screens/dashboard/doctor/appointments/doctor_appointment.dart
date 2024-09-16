import 'package:dio/dio.dart';
import 'package:doctor_management/constants/strings.dart';
import 'package:doctor_management/screens/dashboard/doctor/appointments/bloc/doctor_appointment_Event.dart';
import 'package:doctor_management/screens/dashboard/doctor/appointments/bloc/doctor_appointment_State.dart';
import 'package:doctor_management/screens/dashboard/user/doctor_profile/doctor_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_management/screens/dashboard/doctor/appointments/bloc/doctor_appointment_bloc.dart';

// ignore: must_be_immutable
class DoctorAppointmentsPage extends StatefulWidget {
  final String doctorId;
  Constants str = Constants();
  DoctorAppointmentsPage({required this.doctorId});

  @override
  _DoctorAppointmentsPageState createState() => _DoctorAppointmentsPageState();
}

class _DoctorAppointmentsPageState extends State<DoctorAppointmentsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoctorAppointmentsBloc()..add(FetchAppointments(widget.doctorId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Appointments'),
        ),
        body: BlocBuilder<DoctorAppointmentsBloc, DoctorAppointmentsState>(
          builder: (context, state) {
            if (state is DoctorAppointmentsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is DoctorAppointmentsError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is DoctorAppointmentsLoaded) {
              final appointments = state.appointments;
              if (appointments.isEmpty) {
                return Center(child: Text(widget.str.noAppointments));
              }
              return ListView.builder(
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final appointment = appointments[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          color: appointment.status == 'approved'
                              ? Colors.green.withOpacity(0.5)
                              : appointment.status == 'declined'
                                  ? Colors.red.withOpacity(0.5)
                                  : Colors.tealAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 30.0,
                                      backgroundImage:
                                          AssetImage('assets/icons/doctor_image.png'),
                                    ),
                                    SizedBox(width: 16.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Name: ${appointment.userName ?? 'N/A'}',
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Date: ${appointment.date}',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          SizedBox(height: 8.0),
                                          Row(
                                            children: [
                                              Icon(Icons.access_time, color: Colors.black54, size: 16.0),
                                              SizedBox(width: 4.0),
                                              Text(
                                                'Time: ${appointment.time}',
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Icon(Icons.phone, color: Colors.black54),
                                        SizedBox(height: 16.0),
                                        Icon(Icons.message, color: Colors.black54),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.0),
                                if (appointment.status == 'pending') ...[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          // Approve action
                                          await _handleDecision(
                                            context,
                                            appointment,
                                            'approved',
                                            setState,
                                          );
                                        },
                                        child: Text('Approve'),
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                      ),
                                      SizedBox(width: 8.0),
                                      ElevatedButton(
                                        onPressed: () async {
                                          // Decline action
                                          await _handleDecision(
                                            context,
                                            appointment,
                                            'declined',
                                            setState,
                                          );
                                        },
                                        child: Text('Decline'),
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                      ),
                                    ],
                                  ),
                                ] else if (appointment.status == 'approved') ...[
                                  Text('Approved', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                ] else if (appointment.status == 'declined') ...[
                                  Text('Declined', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text(widget.str.noAppointments));
            }
          },
        ),
      ),
    );
  }

  Future<void> _handleDecision(
    BuildContext context,
    Appointment appointment,
    String decision,
    StateSetter setState,
  ) async {
    final date = appointment.date;

    setState(() {
      appointment.status = decision;
    });

    try {
      final response = await Dio().post(
        'https://66d18e2962816af9a4f411ef.mockapi.io/notifications',
        data: {
          'user_id': appointment.userId,
          'message': 'Your appointment on $date with doctor has been $decision.',
          'userName': appointment.userName,
          'doctor_id': appointment.doctorId,
        },
      );

      if (response.statusCode == 200) {
        // Handle success if needed
      } else {
        // Handle failure if needed
      }
    } catch (e) {
      // Handle error
      print('Error sending notification: $e');
    }
  }
}