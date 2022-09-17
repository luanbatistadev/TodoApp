import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:todo_do_app/app/modules/auth/submodules/forgot_pass/domain/dto/forgot_pass_dto.dart';
import 'package:todo_do_app/app/modules/auth/submodules/forgot_pass/domain/repository/i_forgot_pass_repository.dart';
import 'package:todo_do_app/app/modules/auth/submodules/forgot_pass/infra/datasource/i_forgot_pass_datasource.dart';

class ForgotPassRepositoryImpl implements IForgotPassRepository {
  const ForgotPassRepositoryImpl(this._forgotPassWithEmailDatasource);

  final IForgotPassDatasource _forgotPassWithEmailDatasource;

  @override
  Future<Either<IAppException, bool>> forgotPass(ForgotPassDTO params) async {
    try {
      final result = await _forgotPassWithEmailDatasource.forgotPass(params);

      return Right(result);
    } on IAppException catch (e) {
      return Left(e);
    }
  }
}
