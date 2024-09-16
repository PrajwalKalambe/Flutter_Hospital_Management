import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:doctor_management/constants/color.dart';
import 'package:doctor_management/constants/strings.dart';
import 'package:doctor_management/screens/dashboard/user/appointments/appointment_page.dart';
import 'package:doctor_management/screens/dashboard/user/doctor_profile/bloc/doctor_profile_bloc.dart';
import 'package:doctor_management/screens/dashboard/user/doctor_profile/bloc/doctor_profile_event.dart';
import 'package:doctor_management/screens/dashboard/user/doctor_profile/bloc/doctor_profile_state.dart';
import 'package:doctor_management/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

String? doctor_name;
// ignore: must_be_immutable
class DoctorProfilePage extends StatelessWidget {
  final int doctorId;
  Constants str = Constants();
  DoctorProfilePage({required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DoctorProfileBloc(Dio())..add(FetchDoctorProfile(doctorId: doctorId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Doctor\'s Profile'),
          backgroundColor: color.newbgColor,
        ),
        body: BlocBuilder<DoctorProfileBloc, DoctorProfileState>(
          builder: (context, state) {
            if (state is DoctorProfileLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is DoctorProfileLoaded) {
              final doctor = state.doctor;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildProfileHeader(doctor),
                    _buildContactDetails(doctor, context),
                  ],
                ),
              );
            } else if (state is DoctorProfileError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }
 Future<void> _fetchDoctorName(int doctorId) async {
  try {
    // Replace with your actual API call
    final response = await Dio().get(
      'https://66d0a8bc181d059277df52d0.mockapi.io/doctor',
      queryParameters: {'doctor_id': doctorId},
    );
    
    // Check if response data is a String (likely JSON) and decode it
    final responseData = response.data is String ? jsonDecode(response.data) : response.data;
    if (responseData is Map<String, dynamic>) {
      final String firstName = responseData['first_name'];
      final String lastName = responseData['last_name'];

      // Set the global doctor_name variable
      doctor_name = 'Dr. $firstName $lastName';

      print('Doctor Name: $doctor_name');
    } else {
      print(str.doctorDataNotValid);
    }
  } catch (e) {
    print(str.errorFetchingDoctor + ' $e');
  }
}
  Widget _buildProfileHeader(Map<String, dynamic> doctor) {
    return Container(
      color: color.newbgColor,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage('assets/icons/face_image.png')
          ),
          SizedBox(height: 16),
          Text(
            'Dr. ${doctor['first_name']} ${doctor['last_name']}',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 8),
          Text(
            doctor['specialization'] ?? 'Specialist',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.yellow, size: 24),
              SizedBox(width: 4),
              Text(
                doctor['rating']?.toString() ?? '4.5',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                ' (${doctor['reviews'] ?? '120'} reviews)',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactDetails(
      Map<String, dynamic> doctor, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(23),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Details',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text(doctor['mobile_number'] ?? '+1 234 567 8900'),
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text(doctor['email'] ?? 'doctor@example.com'),
          ),
          ListTile(
            leading: Icon(Icons.location_on),
            title:
                Text(doctor['address'] ?? '123 Medical Center, City, Country'),
          ),
          SizedBox(height: 230),
       
          Center(
            child: CustomElevatedButton(
              label: 'BOOK APPOINTMENT',
              backgroundColor: Colors.black,
              textColor: Colors.white,
              borderRadius: 30,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppointmentPage(doctor: doctor),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
