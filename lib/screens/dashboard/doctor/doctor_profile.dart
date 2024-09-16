import 'package:flutter/material.dart';



class DoctorProfilePage extends StatefulWidget {
  @override
  State<DoctorProfilePage> createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage:
                         AssetImage('assets/icons/doctor_image.png') // Replace with your image URL
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Dr. Alexa',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Heart Specialist',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star, color: Colors.yellow),
                        Text(
                          '4.8 (23 reviews)',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.person_outline),
                title: Text('Your profile'),
                onTap: () {
                  // Navigate to the profile page
                },
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text('History Transaction'),
                onTap: () {
                  // Navigate to the transaction history page
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.lock_outline),
                title: Text('Change password'),
                onTap: () {
                  // Navigate to the change password page
                },
              ),
              ListTile(
                leading: Icon(Icons.lock_reset),
                title: Text('Forgot password'),
                onTap: () {
                  // Navigate to the forgot password page
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.notifications_none),
                title: Text('Notification'),
                onTap: () {
                  // Navigate to the notifications settings page
                },
              ),
              ListTile(
                leading: Icon(Icons.language),
                title: Text('Languages'),
                onTap: () {
                  // Navigate to the language settings page
                },
              ),
              ListTile(
                leading: Icon(Icons.help_outline),
                title: Text('Help and Support'),
                onTap: () {
                  // Navigate to the help and support page
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
