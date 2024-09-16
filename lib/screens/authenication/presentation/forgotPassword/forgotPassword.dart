import 'package:doctor_management/constants/color.dart';
import 'package:doctor_management/constants/strings.dart';
import 'package:doctor_management/screens/authenication/presentation/forgotPassword/opt_screen.dart';
import 'package:doctor_management/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

class ForgotPasswordScreen extends StatefulWidget {
  final String email;

  const ForgotPasswordScreen({Key? key, required this.email}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Constants str = Constants();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.skyBlue,
      appBar: AppBar(
        backgroundColor: color.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: color.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Text(
              str.ForgotPasswordCap,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: color.black,
              ),
            ),
            SizedBox(height: 50),
            Text(
              str.ForgotPasswordString,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: color.black,
              ),
            ),
            SizedBox(height: 60),
            Text(
              str.MobileNumber,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                color: color.black,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _mobileNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                filled: true,
                fillColor: color.white,
                hintText: 'Mobile Number',
                prefixText: '91+ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 130),
            isLoading
                ? CircularProgressIndicator()
                : CustomElevatedButton(
                    label: str.Send,
                    backgroundColor: color.black,
                    textColor: color.white,
                    borderRadius: 30,
                    onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        String mobileNumber = _mobileNumberController.text;
                        // print("Mobile Number: $mobileNumber");

                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: '+91$mobileNumber',
                          verificationCompleted: (phoneAuthCredential) {},
                          verificationFailed: (error) {
                            log(error.toString());
                            setState(() {
                              isLoading = false;
                            });
                          },
                          codeSent: (verificationId, forceResendingToken) {
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VerifyNumberScreen(
                                  phoneNumber: mobileNumber, verificationId: verificationId,
                                  email: _emailController.text,
                                ),
                              ),
                            );
                          },
                          codeAutoRetrievalTimeout: (verificationId) {
                            log("Auto Retrieval timeout");
                            setState(() {
                              isLoading = false;
                            });
                          },
                        );
                      },)
           
          ],
        ),
      ),
    );
  }
}
