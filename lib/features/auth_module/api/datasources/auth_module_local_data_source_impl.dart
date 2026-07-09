import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/features/auth_module/data/datasources/auth_module_local_data_source_contract.dart';

@Injectable(as: AuthModuleLocalDataSourceContract)
class AuthModuleLocalDataSourceImpl
    implements AuthModuleLocalDataSourceContract {}
