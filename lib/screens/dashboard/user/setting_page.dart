import 'package:flutter/material.dart';



class SettingPage extends StatefulWidget {
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
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
