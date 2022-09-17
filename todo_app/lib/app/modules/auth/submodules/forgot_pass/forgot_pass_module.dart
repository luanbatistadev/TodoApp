import 'package:dependency_module/dependency_module.dart';
import 'package:todo_do_app/app/modules/auth/submodules/forgot_pass/domain/usecases/forgot_pass_usecase.dart';
import 'package:todo_do_app/app/modules/auth/submodules/forgot_pass/external/datasource/forgot_pass_datasource_impl.dart';
import 'package:todo_do_app/app/modules/auth/submodules/forgot_pass/infra/repository/i_forgot_pass_repository.dart';
import 'package:todo_do_app/app/modules/auth/submodules/forgot_pass/presenter/store/forgot_pass_store.dart';
import 'package:todo_do_app/app/modules/auth/submodules/forgot_pass/presenter/ui/forgot_pass_page.dart';

class ForgotPassModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.factory((i) => const ForgotPassDatasourceImpl()),
        Bind.factory((i) => ForgotPassRepositoryImpl(i())),
        Bind.factory((i) => ForgotPassUsecaseImpl(i())),
        Bind.singleton((i) => ForgotPassStore(i(),i())),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          Modular.initialRoute,
          child: (context, __) =>  ForgotPassPage(
            store: context.read<ForgotPassStore>(),
          ),
        ),
      ];
}
