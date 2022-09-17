import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:todo_do_app/app/modules/auth/submodules/forgot_pass/domain/dto/forgot_pass_dto.dart';
import 'package:todo_do_app/app/modules/auth/submodules/forgot_pass/domain/repository/i_forgot_pass_repository.dart';


abstract class IForgotPassUsecase {
  Future<Either<IAppException, bool>> call(ForgotPassDTO params);
}

class ForgotPassUsecaseImpl implements IForgotPassUsecase {
  ForgotPassUsecaseImpl(this._forgotPassWithEmailRepository);

  final IForgotPassRepository _forgotPassWithEmailRepository;

  @override
  Future<Either<IAppException, bool>> call(ForgotPassDTO params) async {
    return _forgotPassWithEmailRepository.forgotPass(params);
  }
}
