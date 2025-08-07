import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verify/models/user_model.dart';
import '../services/api_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService apiService;
  User? currentUser;

  AuthBloc(this.apiService) : super(AuthInitial()) {
    on<SignupEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await apiService.signup(
          event.name,
          event.email,
          event.password,
          event.address,
          File(event.profileImagePath),
        );

        emit(AuthOtpSent(response['message']));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<VerifyOtpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await apiService.verifyOtp(event.email, event.otp);

        emit(AuthOtpVerified(response['message']));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<UploadDocumentEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await apiService.uploadDocument(
          event.email,
          File(event.documentImagePath),
        );

        emit(AuthDocumentUploaded(response['message']));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<UploadSelfieEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await apiService.uploadSelfie(
          event.email,
          File(event.selfieImagePath),
        );

        if (response['verified'] == true) {
          emit(
            AuthSelfieUploaded(verified: true, message: response['message']),
          );
        } else {
          emit(AuthSelfieNotMatched(response['message']));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await apiService.login(event.email, event.password);

        currentUser = User(
          name: response['name'] as String,
          email: response['email'] as String,
          address: response['address'] as String,
          profilePictureUrl: response['profile_picture'] is String
              ? response['profile_picture'] as String
              : '',
        );
        emit(AuthAuthenticated(currentUser!));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<DeleteAccountEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await apiService.deleteAccount(event.email);

        currentUser = null;
        emit(AuthAccountDeleted());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<ChangePasswordEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await apiService.changePassword(
          event.email,
          event.currentPassword,
          event.newPassword,
        );

        emit(AuthPasswordChanged());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());

      currentUser = null;
      emit(AuthLoggedOut());
    });
  }
}
