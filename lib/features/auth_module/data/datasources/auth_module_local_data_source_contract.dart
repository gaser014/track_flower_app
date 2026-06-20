abstract interface class AuthModuleLocalDataSourceContract {
  Future<void> saveDriverToken(String token);
  Future<void> deleteDriverToken();
  Future<void> saveCredentials({
    required String email,
    required String password,
  });
  Future<void> deleteCredentials();
  Future<Map<String, String?>> getSavedCredentials();
}
