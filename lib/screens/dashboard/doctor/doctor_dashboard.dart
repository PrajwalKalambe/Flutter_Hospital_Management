import 'package:dio/dio.dart';
import 'package:doctor_management/constants/color.dart';
import 'package:doctor_management/constants/strings.dart';
import 'package:doctor_management/screens/dashboard/doctor/appointments/doctor_appointment.dart';
import 'package:doctor_management/screens/dashboard/doctor/doctor_profile.dart';
import 'package:doctor_management/screens/dashboard/doctor/notification_page.dart';
import 'package:doctor_management/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class DoctorDashboard extends StatefulWidget {
  final String email;
  
  DoctorDashboard({required this.email});
  
  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  late Future<String> doctorIdFuture;
  final Dio _dio = Dio();
  Constants str =Constants();

  @override
  void initState() {
    super.initState();
    doctorIdFuture = _fetchDoctorId(widget.email);
  }

  Future<String> _fetchDoctorId(String email) async {
    try {
      final response = await _dio.get(
        'https://66d0a8bc181d059277df52d0.mockapi.io/doctor',
        queryParameters: {'email': email},
      );

      if (response.statusCode == 200) {
        final doctor = response.data[0];
        final doctorId = doctor['id'].toString(); 
        return doctorId;
      } else {
        throw Exception(str.failedToLoadDoctor);
      }
    } catch (e) {
      throw Exception(str.failedToLoadDoctor + ' $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: color.cyanLight, 
        statusBarIconBrightness: Brightness.light, 
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildSearchBar(),
              _buildBannerArea(),
              _buildManagePackages(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 19.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Upcoming Appointments', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () {},
                      child: Text('See all'),
                    ),
                  ],
                ),
              ),
              FutureBuilder<String>(
                future: doctorIdFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final doctorId = snapshot.data!;
                    return _buildAppointmentCard(doctorId);
                  } else {
                    return Text('No data available');
                  }
                },
              ),
              Spacer(),
              FutureBuilder<String>(
                future: doctorIdFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox.shrink(); 
                  } else if (snapshot.hasError || !snapshot.hasData) {
                    return SizedBox.shrink(); 
                  } else {
                    final doctorId = snapshot.data!;
                    return CustomBottomNavBar(
                      items: [
                        {
                          'icon': Icons.home,
                          'isSelected': true,
                          'onPressed': () {
                            // Navigate to Home
                          },
                        },
                        {
                          'icon': Icons.settings,
                          'onPressed': () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoctorProfilePage(),
                              ),
                            );
                          },
                        },
                        {
                          'icon': Icons.notifications,
                          'onPressed': () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoctorNotificationPage(doctorId: doctorId),
                              ),
                            );
                          },
                        },
                        {
                          'icon': Icons.wallet,
                          'onPressed': () {
                            // Navigate to Wallet
                          },
                        },
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color.cyanLight),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black,
                  backgroundImage: AssetImage('assets/icons/boy_face.png'),
                  radius: 20,
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome Alexa', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Have a Nice day', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
 
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(color: color.cyanLight, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Container(
          decoration: BoxDecoration(
            color: color.black,
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(color: color.white),
              prefixIcon: Icon(Icons.search, color: color.white, size: 28),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBannerArea() {
    return Container(
      height: 150,
      margin: EdgeInsets.all(16),
      color: color.grey,
    );
  }

  Widget _buildManagePackages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text('Manage Packages', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildPackageButton('Silver'),
            _buildPackageButton('Gold'),
            _buildPackageButton('Diamond'),
          ],
        ),
      ],
    );
  }

  Widget _buildPackageButton(String label) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(label),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: color.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        fixedSize: Size(120, 110),
      ),
    );
  }

  Widget _buildAppointmentCard(String doctorId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorAppointmentsPage(
              doctorId: doctorId, 
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        padding: EdgeInsets.all(23),
        decoration: BoxDecoration(
          color: color.cyanLight,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: AssetImage('assets/icons/boy_face.png'),
              radius: 30,
              child: Icon(Icons.person, color: Colors.white),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mr. Jack Sparrow', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Heart Patient'),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      SizedBox(width: 5),
                      Text('13 Aug, 2023', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorAppointmentsPage(
                      doctorId: doctorId,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              child: Text('View Appointment', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
