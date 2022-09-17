import 'package:core/core.dart';
import 'package:core/translate/app_localizations.dart';
import 'package:dependency_module/dependency_module.dart';
import 'package:todo_do_app/app/modules/auth/submodules/forgot_pass/domain/dto/forgot_pass_dto.dart';
import 'package:todo_do_app/app/modules/auth/submodules/forgot_pass/domain/usecases/forgot_pass_usecase.dart';
import 'package:todo_do_app/app/modules/auth/submodules/forgot_pass/presenter/store/forgot_pass_state.dart';

class ForgotPassStore extends StreamStore<IAppException, ForgotPassState> {
  ForgotPassStore(
    this._forgotPassUsecase,
    this._overlayService,
  ) : super(const ForgotPassState(false));
  final emailInstance = Email();
  String? get email => emailInstance.value;
  set email(String? value) => emailInstance.value = value;

  final IForgotPassUsecase _forgotPassUsecase;
  final IOverlayService _overlayService;

  Future<void> forgotPass(AppLocalizations localizations) async {
    setLoading(true);
    final result = await _forgotPassUsecase(
      ForgotPassDTO(
        email: emailInstance.value!,
        localizations: localizations,
      ),
    );
    setLoading(false);
    result.fold(
      (l) => _overlayService.showErrorSnackBar(l.message),
      (r) => _overlayService
          .showSuccessSnackBar(localizations.resetPassSuccess + '$email'),
    );
  }
}
