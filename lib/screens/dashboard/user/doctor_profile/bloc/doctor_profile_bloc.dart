// doctor_profile_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:doctor_management/constants/strings.dart';
import 'doctor_profile_event.dart';
import 'doctor_profile_state.dart';

class DoctorProfileBloc extends Bloc<DoctorProfileEvent, DoctorProfileState> {
  final Dio _dio;
  Constants str = Constants();

  DoctorProfileBloc(this._dio) : super(DoctorProfileInitial()) {
    on<FetchDoctorProfile>(_onFetchDoctorProfile);
  }

  Future<void> _onFetchDoctorProfile(
    FetchDoctorProfile event,
    Emitter<DoctorProfileState> emit,
  ) async {
    emit(DoctorProfileLoading());
    try {
      final response = await _dio.get('https://66d0a8bc181d059277df52d0.mockapi.io/doctor/${event.doctorId}');
      emit(DoctorProfileLoaded(doctor: response.data));
    } catch (e) {
      emit(DoctorProfileError(message: str.failedToFetchDoctor));
    }
  }
}
