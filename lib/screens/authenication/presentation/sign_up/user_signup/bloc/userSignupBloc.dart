import 'package:doctor_management/constants/strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import 'userSignupEvent.dart';
import 'userSignupState.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Dio _dio = Dio();
  Constants str = Constants();

  SignupBloc() : super(SignupInitial()) {
    on<SignupButtonPressed>(_onSignupButtonPressed);
  }

  Future<void> _onSignupButtonPressed(
    SignupButtonPressed event,
    Emitter<SignupState> emit,
  ) async {
    emit(SignupLoading());
    try {
      // Create user in Firebase
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      if (userCredential.user != null) {
        // Send user data to backend
        final String userId = userCredential.user!.uid; 
        final bool isSuccessful = await _sendUserDataToBackend(event, userId);

        if (isSuccessful) {
          emit(SignupSuccess(str.signupSuccess));
        } else {
          emit(SignupFailure(str.failedToSendBackEndData));
        }
      } else {
        emit(SignupFailure(str.failedToCreateUser));
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = str.errorDuringSignup;
      if (e.code == 'weak-password') {
        errorMessage = str.weakPassword;
      } else if (e.code == 'email-already-in-use') {
        errorMessage = str.acountAlreadyExists;
      }
      emit(SignupFailure(errorMessage));
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }

  Future<bool> _sendUserDataToBackend(SignupButtonPressed event, String userId) async {
    try {
      final response = await _dio.post(
        'https://66d0a8bc181d059277df52d0.mockapi.io/user',  
        data: {
          'first_name': event.firstName,
          'last_name': event.lastName,
          'email': event.email,
          'mobile_number': event.mobileNumber,
          'id': userId, 
        },
      );


      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(str.errorOccured + '$e');
      return false;
    }
  }
}
