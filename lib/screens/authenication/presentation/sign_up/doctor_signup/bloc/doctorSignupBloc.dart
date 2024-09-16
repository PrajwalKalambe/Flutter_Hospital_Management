import 'package:doctor_management/constants/strings.dart';
import 'package:doctor_management/screens/authenication/presentation/sign_up/doctor_signup/bloc/doctorSignupEvent.dart';
import 'package:doctor_management/screens/authenication/presentation/sign_up/doctor_signup/bloc/doctorSignupState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';

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
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      await userCredential.user?.updateDisplayName('${event.firstName} ${event.lastName}');

      await _sendUserDataToBackend(event);
      emit(SignupSuccess());
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }

  Future<void> _sendUserDataToBackend(SignupButtonPressed event) async {
    try {
      final response = await _dio.post(
        'https://66d0a8bc181d059277df52d0.mockapi.io/doctor', 
        data: {
          'first_name': event.firstName,
          'last_name': event.lastName,
          'email': event.email,
          'mobile_number': event.mobileNumber,
          'designation': event.specialization,
        },
      );

      if (response.statusCode != 201) {
        throw Exception(str.failedToSendBackEndData);
      }
    } catch (e) {
      print(str.errorSendingBackEndData + '$e');
      throw Exception(str.failedToSendBackEndData);
    }
  }
}
