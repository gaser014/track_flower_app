import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/features/auth_module/data/datasources/auth_module_remote_data_source_contract.dart';

@Injectable(as: AuthModuleRemoteDataSourceContract)
class AuthModuleRemoteDataSourceImpl
    implements AuthModuleRemoteDataSourceContract {}
