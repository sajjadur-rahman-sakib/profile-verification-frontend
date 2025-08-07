abstract class AuthEvent {}

class SignupEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String address;
  final String profileImagePath;

  SignupEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.address,
    required this.profileImagePath,
  });
}

class VerifyOtpEvent extends AuthEvent {
  final String email;
  final String otp;

  VerifyOtpEvent({required this.email, required this.otp});
}

class UploadDocumentEvent extends AuthEvent {
  final String email;
  final String documentImagePath;

  UploadDocumentEvent({required this.email, required this.documentImagePath});
}

class UploadSelfieEvent extends AuthEvent {
  final String email;
  final String selfieImagePath;

  UploadSelfieEvent({required this.email, required this.selfieImagePath});
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

class DeleteAccountEvent extends AuthEvent {
  final String email;

  DeleteAccountEvent({required this.email});
}

class ChangePasswordEvent extends AuthEvent {
  final String email;
  final String currentPassword;
  final String newPassword;

  ChangePasswordEvent({
    required this.email,
    required this.currentPassword,
    required this.newPassword,
  });
}

class LogoutEvent extends AuthEvent {}
