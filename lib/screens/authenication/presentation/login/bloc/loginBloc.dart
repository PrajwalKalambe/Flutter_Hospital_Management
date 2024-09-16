import 'package:doctor_management/constants/strings.dart';
import 'package:doctor_management/screens/authenication/presentation/login/bloc/loginEvent.dart';
import 'package:doctor_management/screens/authenication/presentation/login/bloc/loginState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Constants str = Constants();

  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      if (userCredential.user != null) {
        emit(LoginSuccess(message: str.loginSuccessful));
      } else {
        emit(LoginFailure(error: str.loginFailed));
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = str.noUserFound;
      } else if (e.code == 'wrong-password') {
        errorMessage = str.wrongPassProvided;
      } else {
        errorMessage = str.errorOccured;
      }
      emit(LoginFailure(error: errorMessage));
    } catch (e) {
      emit(LoginFailure(error: str.errorOccured));
    }
  }
  
}