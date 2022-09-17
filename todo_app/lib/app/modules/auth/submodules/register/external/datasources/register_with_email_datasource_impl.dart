import 'package:core/core.dart';
import 'package:core/user/external/mappers/user_entity_mapper.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/dtos/register_with_email_dto.dart';
import '../../infra/datasources/i_register_with_email_datasource.dart';

class RegisterWithEmailDatasourceImpl implements IRegisterWithEmailDatasource {
  const RegisterWithEmailDatasourceImpl();

  @override
  Future<UserEntity> registerWithEmail(RegisterWithEmailDTO params) async {


    try {
      final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: params.email, password: params.password);
      await FirebaseAuth.instance.currentUser!.updateDisplayName(params.name);
      return UserEntityMapper.fromMap({
        'name': params.name,
        'email': user.user?.email,
        'tasks': [],
      });
    } on IAppException {
      rethrow;
    } catch (e, s) {
      throw DatasourceException(message: e.toString(), stackTrace: s);
    }
  }
}
