import 'package:doctor_management/screens/authenication/presentation/sign_up/doctor_signup/bloc/doctorSignupBloc.dart';
import 'package:doctor_management/screens/authenication/presentation/sign_up/doctor_signup/bloc/doctorSignupEvent.dart';
import 'package:doctor_management/screens/authenication/presentation/sign_up/doctor_signup/bloc/doctorSignupState.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_management/constants/color.dart';
import 'package:doctor_management/constants/strings.dart';
import 'package:doctor_management/screens/authenication/presentation/login/login.dart';
import 'package:doctor_management/widgets/custom_button.dart';

class DoctorSignupPage extends StatefulWidget {
  final Color backgroundColor;
  final Color buttonColor;
  final Color textColor;
  final Color borderColor;
  final double borderRadius;
  final double elevation;

  DoctorSignupPage({
    this.backgroundColor = const Color(0xFFE0F7FA),
    this.buttonColor = Colors.black,
    this.textColor = Colors.black,
    this.borderColor = const Color(0xFF80DEEA),
    this.borderRadius = 30.0,
    this.elevation = 5.0,
  });

  @override
  State<DoctorSignupPage> createState() => _DoctorSignupPageState();
}

class _DoctorSignupPageState extends State<DoctorSignupPage> {
  Constants str = Constants();
  final _formKey = GlobalKey<FormState>();

  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _mobileNumber = '';
  String _password = '';
  String _specialization = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupBloc(),
      child: Scaffold(
        backgroundColor: widget.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: widget.textColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocConsumer<SignupBloc, SignupState>(
          listener: (context, state) {
            if (state is SignupSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(str.signupSuccess)),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(userType: 'doctor'),
                ),
              );
            } else if (state is SignupFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      str.SignUp,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: widget.textColor,
                      ),
                    ),
                    SizedBox(height: 40),
                    _buildTextField(Icons.person_outline, 'First Name',
                        onSaved: (value) => _firstName = value!),
                    SizedBox(height: 20),
                    _buildTextField(Icons.person_outline, 'Last Name',
                        onSaved: (value) => _lastName = value!),
                    SizedBox(height: 20),
                    _buildTextField(Icons.email_outlined, 'Email',
                        onSaved: (value) => _email = value!),
                    SizedBox(height: 20),
                    _buildTextField(Icons.phone_android, 'Mobile Number',
                        onSaved: (value) => _mobileNumber = value!),
                    SizedBox(height: 20),
                    _buildTextField(Icons.design_services_outlined, 'Specialization',
                        onSaved: (value) => _specialization = value!),
                    SizedBox(height: 20),
                    _buildTextField(Icons.lock_outline, 'Password',
                        obscureText: true, onSaved: (value) => _password = value!),
                    SizedBox(height: 40),
                    state is SignupLoading
                        ? Center(child: CircularProgressIndicator())
                        : CustomElevatedButton(
                            label: str.SignUp,
                            backgroundColor: color.black,
                            textColor: color.white,
                            borderRadius: 30,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                BlocProvider.of<SignupBloc>(context).add(
                                  SignupButtonPressed(
                                    firstName: _firstName,
                                    lastName: _lastName,
                                    email: _email,
                                    mobileNumber: _mobileNumber,
                                    password: _password,
                                    specialization: _specialization,
                                  ),
                                );
                              }
                            },
                          ),
                    SizedBox(height: 20),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: str.alreadyHaveAccount,
                          style: TextStyle(
                              color: widget.textColor, fontSize: 16),
                          children: [
                            TextSpan(
                              text: str.Login,
                              style: TextStyle(color: color.blue, fontSize: 18),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(userType: 'doctor'),
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
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(IconData icon, String hintText,
      {bool obscureText = false, required Function(String?) onSaved}) {
    return TextFormField(
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: widget.textColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: widget.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: widget.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: widget.borderColor),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $hintText';
        }
        return null;
      },
      onSaved: onSaved,
    );
  }
}
