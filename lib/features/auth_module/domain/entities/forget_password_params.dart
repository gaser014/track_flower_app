class ForgetPasswordParams {
  final String? email;
  final String? resetCode;
  final String? newPassword;

  ForgetPasswordParams({
    this.email,
    this.resetCode,
    this.newPassword,
  });
}
