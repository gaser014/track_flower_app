abstract interface class AuthLocalDataSourceContract {
  Future<void> saveUserToken(String token);
  Future<String?> getUserToken();
  Future<void> deleteUserToken();
}
