// login_page.dart

import 'package:doctor_management/screens/authenication/presentation/sign_up/doctor_signup/doctor_sign_up.dart';
import 'package:doctor_management/screens/authenication/presentation/sign_up/user_sign_up.dart';
import 'package:doctor_management/screens/dashboard/doctor/doctor_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_management/constants/color.dart';
import 'package:doctor_management/constants/iconLinks.dart';
import 'package:doctor_management/constants/strings.dart';
import 'package:doctor_management/screens/authenication/presentation/forgotPassword/forgotPassword.dart';
import 'package:doctor_management/screens/dashboard/user/user_dashboard.dart';
import 'package:doctor_management/widgets/custom_button.dart';
import 'package:flutter/gestures.dart';
import 'package:doctor_management/screens/authenication/presentation/login/bloc/loginBloc.dart';
import 'package:doctor_management/screens/authenication/presentation/login/bloc/loginEvent.dart';
import 'package:doctor_management/screens/authenication/presentation/login/bloc/loginState.dart';
import 'package:doctor_management/screens/authenication/presentation/login/google_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  final String userType;

  LoginPage({required this.userType});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GoogleAuthService _googleAuthService = GoogleAuthService();
  Constants str = Constants();
  

  @override
  void initState() {
    // TODO: implement activate
    super.initState();
    _emailController.clear();
    _passwordController.clear();
    
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        backgroundColor: color.white,
        appBar: AppBar(
          backgroundColor: color.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: color.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => 
                  widget.userType == 'doctor' ? DoctorDashboard(email: _emailController.text) : UserDashboard(email: _emailController.text)),
              );
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    str.Login,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 50),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'EMAIL',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: Icon(Icons.visibility_off),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      child: Text(str.ForgotPassword,
                          style: TextStyle(fontSize: 16, color: color.lightBrown)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen(email: _emailController.text,)));
                      },
                    ),
                  ),
                  SizedBox(height: 60),
                  if (state is LoginLoading)
                    Center(child: CircularProgressIndicator())
                  else
                    CustomElevatedButton(
                      label: str.Login,
                      backgroundColor: color.black,
                      textColor: color.white,
                      borderRadius: 30,
                      onPressed: () {
                        BlocProvider.of<LoginBloc>(context).add(
                          LoginButtonPressed(
                            email: _emailController.text,
                            password: _passwordController.text,
                          ),
                        );
                      },
                    ),
                  SizedBox(height: 20),
                  Center(child: Text(str.Or)),
                  SizedBox(height: 20),
                  Center(child: Text(str.LogInWith)),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialButton(links.google, _handleGoogleSignIn),
                      SizedBox(width: 20),
                      _socialButton(links.apple, () {}),
                      SizedBox(width: 20),
                      _socialButton(links.facebook, () {}),
                    ],
                  ),
                  SizedBox(height: 50),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: color.black, fontSize: 17),
                        children: [
                          TextSpan(text: str.NoAccount),
                          TextSpan(
                            text: str.RegisterNow,
                            style: TextStyle(color: color.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => widget.userType == 'doctor'
                                        ? DoctorSignupPage()
                                        : UserSignupPage(),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _socialButton(String iconPath, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(11),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
          border: Border.all(color: Colors.cyan, width: 4),
        ),
        child: Image.asset(iconPath, width: 60, height: 45),
      ),
    );
  }

  void _handleGoogleSignIn() async {
    User? user = await _googleAuthService.signInWithGoogle();
    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => 
          widget.userType == 'doctor' ? DoctorDashboard(email: _emailController.text,) : UserDashboard(email:_emailController.text)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(str.googleSignInFailed)),
      );
    }
  }
}