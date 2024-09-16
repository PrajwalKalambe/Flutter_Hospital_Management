import 'package:doctor_management/screens/dashboard/user/doctor_profile/doctor_profile.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class SearchDoctor extends StatefulWidget {
  @override
  _SearchDoctorState createState() => _SearchDoctorState();
}

class _SearchDoctorState extends State<SearchDoctor> {
  final Dio _dio = Dio();
  List<dynamic> doctors = [];

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    try {
      final response = await _dio.get('https://66d0a8bc181d059277df52d0.mockapi.io/doctor');
      setState(() {
        doctors = response.data;
      });
    } catch (e) {
      print('Error fetching doctors: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctors'),
      ),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return GestureDetector(
            onTap: () {
              // Ensure the doctor ID is an integer
              final doctorId = int.tryParse(doctor['id'].toString()) ?? 0;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorProfilePage(doctorId: doctorId),
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 22),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/icons/face_image.png'),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dr. ${doctor['first_name']} ${doctor['last_name']}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            doctor['designation'] ?? 'Specialist',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.yellow, size: 18),
                              SizedBox(width: 4),
                              Text(doctor['rating']?.toString() ?? '4.9',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.favorite_border),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
