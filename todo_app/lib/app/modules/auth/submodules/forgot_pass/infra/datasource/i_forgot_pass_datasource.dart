import 'package:todo_do_app/app/modules/auth/submodules/forgot_pass/domain/dto/forgot_pass_dto.dart';

abstract class IForgotPassDatasource {
  Future<bool> forgotPass(ForgotPassDTO params);
}
