import 'dart:async';
import 'dart:developer';
import 'package:doctor_management/constants/color.dart';
import 'package:doctor_management/constants/strings.dart';
import 'package:doctor_management/screens/authenication/presentation/forgotPassword/createPassword.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyNumberScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final String email;

  const VerifyNumberScreen({
    Key? key,
    required this.verificationId,
    required this.phoneNumber,
    required this.email,
  }) : super(key: key);

  @override
  _VerifyNumberScreenState createState() => _VerifyNumberScreenState();
}

class _VerifyNumberScreenState extends State<VerifyNumberScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
    Constants str = Constants();

  bool isLoading = false;
  int _timerSeconds = 30;
  late Timer _timer;
  bool _isOtpFilled = false;
  String? _smsCode;

  @override
  void initState() {
    super.initState();
    startTimer();
    for (var controller in _controllers) {
      controller.addListener(_checkOtpFilled);
    }
  }

  void _checkOtpFilled() {
    setState(() {
      _isOtpFilled = _controllers.every((controller) => controller.text.length == 1);
      if (_isOtpFilled) {
        _smsCode = _controllers.map((c) => c.text).join();
      }
    });
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.removeListener(_checkOtpFilled);
      controller.dispose();
    }
    _timer.cancel();
    super.dispose();
  }

  Widget _otpInputField(TextEditingController controller, int index) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        maxLength: 1,
        decoration: InputDecoration(
          counterText: "",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: color.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: color.black),
          ),
        ),
        onChanged: (value) {
          if (value.length == 1 && index < 5) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }

 Future<void> verifyOTP() async {
    setState(() {
      isLoading = true;
    });
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _smsCode!,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(),
        ),
      );
    } catch (e) {
      log(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${str.FailToVerify} ${e.toString()}')),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> resendOTP() async {
  setState(() {
    isLoading = true;
  });
  try {
    // Ensure the phone number includes the country code
    String phoneNumberWithCode = widget.phoneNumber.startsWith('+') 
        ? widget.phoneNumber 
        : '+91${widget.phoneNumber}';

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumberWithCode,
      verificationCompleted: (_) {},
      verificationFailed: (e) {
        log(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${str.FailToVerify} ${e.message}')),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _timerSeconds = 30;
        });
        startTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${str.OTPSend}')),
        );
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  } catch (e) {
    log(e.toString());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${str.FailToVerify} ${e.toString()}')),
    );
  }
  setState(() {
    isLoading = false;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.bgColor,
      appBar: AppBar(
        backgroundColor: color.bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: color.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              str.VerifyNumber,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 10),
             Text(
              str.Enter6DigitCode,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              widget.phoneNumber,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) => _otpInputField(_controllers[index], index)),
            ),
            const SizedBox(height: 20),
            Text(
              "${_timerSeconds ~/ 60}:${(_timerSeconds % 60).toString().padLeft(2, '0')}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: _timerSeconds == 0 ? resendOTP : null,
              child: Text(
                str.resendCode,
                style: TextStyle(
                  color: _timerSeconds == 0 ? color.blue : color.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 40),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _isOtpFilled ? verifyOTP : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isOtpFilled ? color.green : color.grey,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 100.0),
                    ),
                    child:Text(
                      str.Verify,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}