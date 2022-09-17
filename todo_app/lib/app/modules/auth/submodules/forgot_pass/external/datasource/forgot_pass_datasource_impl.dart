import 'package:core/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_do_app/app/modules/auth/submodules/forgot_pass/domain/dto/forgot_pass_dto.dart';
import 'package:todo_do_app/app/modules/auth/submodules/forgot_pass/infra/datasource/i_forgot_pass_datasource.dart';

class ForgotPassDatasourceImpl implements IForgotPassDatasource {
  const ForgotPassDatasourceImpl();

  @override
  Future<bool> forgotPass(ForgotPassDTO params) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: params.email);
      return true;
    } on IAppException {
      rethrow;
    } on FirebaseAuthException catch (e, s) {
      throw DatasourceException(message: e.message??'', stackTrace: s);
    }
  }
}
