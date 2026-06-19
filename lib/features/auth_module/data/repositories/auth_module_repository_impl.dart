import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/auth_module/data/datasources/auth_module_local_data_source_contract.dart';
import 'package:track_flowers_app/features/auth_module/data/datasources/auth_module_remote_data_source_contract.dart';
import 'package:track_flowers_app/features/auth_module/domain/repositories/auth_module_repository.dart';

@Injectable(as: AuthModuleRepository)
class AuthModuleRepositoryImpl implements AuthModuleRepository {
  final AuthModuleRemoteDataSourceContract _remote;
  final AuthModuleLocalDataSourceContract _local;

  const AuthModuleRepositoryImpl(this._remote, this._local);

  // ── Remote ────────────────────────────────────────────────────────────────

  @override
  Future<Result<void>> logoutDriver() async {
    final result = await _remote.logoutDriver();
    return result.when(
      success: (_) => const Success(data: null),
      error: (e) => Error(exception: e),
    );
  }

  // ── Local — token ─────────────────────────────────────────────────────────

  @override
  Future<Result<void>> saveDriverToken(String token) async {
    try {
      await _local.saveDriverToken(token);
      return const Success(data: null);
    } on Exception catch (e) {
      return Error(exception: e);
    }
  }

  @override
  Future<Result<void>> deleteDriverToken() async {
    try {
      await _local.deleteDriverToken();
      return const Success(data: null);
    } on Exception catch (e) {
      return Error(exception: e);
    }
  }

  // ── Local — credentials ───────────────────────────────────────────────────

  @override
  Future<Result<void>> saveCredentials({
    required String email,
    required String password,
  }) async {
    try {
      await _local.saveCredentials(email: email, password: password);
      return const Success(data: null);
    } on Exception catch (e) {
      return Error(exception: e);
    }
  }

  @override
  Future<Result<void>> deleteCredentials() async {
    try {
      await _local.deleteCredentials();
      return const Success(data: null);
    } on Exception catch (e) {
      return Error(exception: e);
    }
  }

  @override
  Future<Result<Map<String, String?>>> getSavedCredentials() async {
    try {
      final credentials = await _local.getSavedCredentials();
      return Success(data: credentials);
    } on Exception catch (e) {
      return Error(exception: e);
    }
  }
}
