// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class CreateNewPasswordScreen extends StatefulWidget {
//   final String email;

//   const CreateNewPasswordScreen({
//     Key? key,
//     required this.email,
//   }) : super(key: key);

//   @override
//   _CreateNewPasswordScreenState createState() => _CreateNewPasswordScreenState();
// }

// class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
//   final TextEditingController _newPasswordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();
//   bool _isNewPasswordObscured = true;
//   bool _isConfirmPasswordObscured = true;
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _newPasswordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   Widget _passwordInputField({
//     required TextEditingController controller,
//     required bool isObscured,
//     required VoidCallback toggleVisibility,
//   }) {
//     return TextField(
//       controller: controller,
//       obscureText: isObscured,
//       decoration: InputDecoration(
//         hintText: "Enter Password",
//         suffixIcon: IconButton(
//           icon: Icon(
//             isObscured ? Icons.visibility_off : Icons.visibility,
//             color: Colors.grey,
//           ),
//           onPressed: toggleVisibility,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(25.0),
//           borderSide: const BorderSide(
//             color: Colors.grey,
//           ),
//         ),
//         filled: true,
//         fillColor: Colors.white,
//         contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//       ),
//       style: const TextStyle(fontSize: 18),
//     );
//   }

//   Future<void> _updatePassword() async {
//   if (_newPasswordController.text != _confirmPasswordController.text) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Passwords do not match')),
//     );
//     return;
//   }

//   setState(() {
//     _isLoading = true;
//   });

//   try {
//     // Get an instance of FirebaseAuth
//     final auth = FirebaseAuth.instance;

//     // Send a password reset email
//     await auth.sendPasswordResetEmail(email: widget.email);

//     // Wait for a short time to ensure the reset is processed
//     await Future.delayed(Duration(seconds: 2));

//     // Try to sign in with the new password
//     UserCredential userCredential = await auth.signInWithEmailAndPassword(
//       email: widget.email,
//       password: _newPasswordController.text,
//     );

//     // If sign-in is successful, update the password
//     await userCredential.user?.updatePassword(_newPasswordController.text);

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Password updated successfully.')),
//     );

//     // Navigate back to login page
//     Navigator.of(context).popUntil((route) => route.isFirst);

//   } on FirebaseAuthException catch (e) {
//     String errorMessage = 'An error occurred. Please try again.';
//     if (e.code == 'weak-password') {
//       errorMessage = 'The password provided is too weak.';
//     } else if (e.code == 'requires-recent-login') {
//       errorMessage = 'This operation is sensitive and requires recent authentication. Log in again before retrying this request.';
//     } else if (e.code == 'user-not-found') {
//       errorMessage = 'No user found for that email.';
//     } else if (e.code == 'wrong-password') {
//       errorMessage = 'Wrong password provided for that user.';
//     }
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Error: $errorMessage')),
//     );
//   } finally {
//     setState(() {
//       _isLoading = false;
//     });
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFDFF6F0),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFDFF6F0),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 30.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(height: 20),
//             const Text(
//               "CREATE NEW PASSWORD",
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 22,
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               "Your New Password Must Be Different",
//               style: TextStyle(
//                 fontSize: 16,
//               ),
//             ),
//             const Text(
//               "From Previously Used Password",
//               style: TextStyle(
//                 fontSize: 16,
//               ),
//             ),
//             const SizedBox(height: 40),
//             _passwordInputField(
//               controller: _newPasswordController,
//               isObscured: _isNewPasswordObscured,
//               toggleVisibility: () {
//                 setState(() {
//                   _isNewPasswordObscured = !_isNewPasswordObscured;
//                 });
//               },
//             ),
//             const SizedBox(height: 20),
//             _passwordInputField(
//               controller: _confirmPasswordController,
//               isObscured: _isConfirmPasswordObscured,
//               toggleVisibility: () {
//                 setState(() {
//                   _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
//                 });
//               },
//             ),
//             const SizedBox(height: 40),
//             _isLoading
//                 ? CircularProgressIndicator()
//                 : ElevatedButton(
//                     onPressed: _updatePassword,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(25.0),
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 20.0,
//                         horizontal: 100.0,
//                       ),
//                     ),
//                     child: const Text(
//                       "SAVE",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:doctor_management/constants/color.dart';
import 'package:doctor_management/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
    Constants str = Constants();


  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Widget _emailInputField() {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "Enter Email",
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            color: color.grey,
          ),
        ),
        filled: true,
        fillColor: color.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      ),
      style: const TextStyle(fontSize: 18),
    );
  }

  Future<void> _sendResetLink() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(str.pleaseEnterMail)),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(str.passwordResetLinkSendMail)),
      );
      // Optionally, navigate back to login page
      Navigator.of(context).pop();
      
    } on FirebaseAuthException catch (e) {
      String errorMessage = str.errorOccured;
      if (e.code == 'user-not-found') {
        errorMessage = str.noUserFound;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${str.error}: $errorMessage')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
             Text(
              str.resetPassword,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 10),
             Text(
              str.enterEmailtoReset,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
             Text(
              str.passwordResetLink,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
            _emailInputField(),
            const SizedBox(height: 40),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _sendResetLink,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 100.0,
                      ),
                    ),
                    child:  Text(
                      str.Send,
                      style: TextStyle(
                        color: color.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}