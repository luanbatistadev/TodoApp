import 'package:core/shared/failures/i_app_exception.dart';
import 'package:dartz/dartz.dart';
import 'package:todo_do_app/app/modules/auth/submodules/forgot_pass/domain/dto/forgot_pass_dto.dart';

abstract class IForgotPassRepository {
  Future<Either<IAppException, bool>> forgotPass(ForgotPassDTO params);
}
