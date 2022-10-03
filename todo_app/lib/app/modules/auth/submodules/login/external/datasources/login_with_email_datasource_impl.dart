import 'package:core/core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/dtos/login_with_email_dto.dart';
import '../../infra/datasources/i_login_with_email_datasource.dart';
import '../mappers/login_mapper.dart';

class LoginWithEmailDatasourceImpl implements ILoginDatasource {
  const LoginWithEmailDatasourceImpl();

  @override
  Future<UserEntity> loginWithEmail(LoginWithEmailDTO params) async {
    try {
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: params.email, password: params.password);

      return LoginMapper.fromMap(
        {
          'name': user.user?.displayName,
          'email': user.user?.email,
          'id': user.user?.uid,
        },
      );
    } on IAppException {
      rethrow;
    } on FirebaseAuthException catch (e, s) {
      throw DatasourceException(message: e.message??'', stackTrace: s);
    }
  }
}
