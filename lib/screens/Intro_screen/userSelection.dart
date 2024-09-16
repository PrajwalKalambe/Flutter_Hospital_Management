// user_selection_page.dart

import 'package:flutter/material.dart';
import 'package:doctor_management/constants/iconLinks.dart';
import 'package:doctor_management/constants/strings.dart';
import 'package:doctor_management/screens/authenication/presentation/login/login.dart';
import 'package:doctor_management/constants/color.dart';
import 'package:doctor_management/widgets/custom_button.dart';

class UserSelectionPage extends StatefulWidget {
  @override
  State<UserSelectionPage> createState() => _UserSelectionPageState();
}

class _UserSelectionPageState extends State<UserSelectionPage> {
  Constants str = Constants();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.mintBackground,
      appBar: AppBar(
        backgroundColor: color.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: color.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text(
              str.userSelection,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            _buildSelectionCard(context, str.Doctor, links.doctorImage),
            SizedBox(height: 50),
            _buildSelectionCard(context, str.Patient, links.patientImage),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionCard(BuildContext context, String title, String imagePath) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _handleSelection(context, title),
          child: Container(
            height: 240,
            width: 290,
            decoration: BoxDecoration(
              border: Border.all(color: color.cyanLight, width: 8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: 15),
        CustomElevatedButton(
            label: title,
            backgroundColor: color.black,
            textColor: color.white,
            borderRadius: 30,
            onPressed: () => _handleSelection(context, title))
      ],
    );
  }

  void _handleSelection(BuildContext context, String userType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(userType: userType.toLowerCase()),
      ),
    );
  }
}