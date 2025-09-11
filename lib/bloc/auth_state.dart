import 'package:verify/models/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthRegistered extends AuthState {
  final String message;

  AuthRegistered(this.message);
}

class AuthOtpSent extends AuthState {
  final String message;

  AuthOtpSent(this.message);
}

class AuthOtpVerified extends AuthState {
  final String message;

  AuthOtpVerified(this.message);
}

class AuthDocumentUploaded extends AuthState {
  final String message;

  AuthDocumentUploaded(this.message);
}

class AuthSelfieUploaded extends AuthState {
  final bool verified;
  final String message;

  AuthSelfieUploaded({required this.verified, required this.message});
}

class AuthSelfieNotMatched extends AuthState {
  final String message;

  AuthSelfieNotMatched(this.message);
}

class AuthAuthenticated extends AuthState {
  final User user;

  AuthAuthenticated(this.user);
}

class AuthAccountDeleted extends AuthState {}

class AuthPasswordChanged extends AuthState {}

class AuthLoggedOut extends AuthState {}

class AuthForgotPasswordSuccess extends AuthState {
  final String message;

  AuthForgotPasswordSuccess(this.message);
}

class AuthResetPasswordSuccess extends AuthState {
  final String message;

  AuthResetPasswordSuccess(this.message);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
