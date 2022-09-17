import 'package:core/core.dart';
import 'package:core/translate/app_localizations.dart';
import 'package:dependency_module/dependency_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:tads_design_system/tads_design_system.dart';
import 'package:todo_do_app/app/modules/auth/submodules/forgot_pass/presenter/store/forgot_pass_state.dart';
import 'package:todo_do_app/app/modules/auth/submodules/forgot_pass/presenter/store/forgot_pass_store.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({
    Key? key,
    required this.store,
  }) : super(key: key);
  final ForgotPassStore store;

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: TADSCustomInitPage(
        verticalPadding: 40,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment:
                kIsWeb ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.1),
              TADSCustomTitlePainel(
                title: AppLocalizations.of(context)!.forgotPass,
                subtitle: AppLocalizations.of(context)!.forgotPassSubTitle,
              ),
              SizedBox(height: size.height * 0.18),
              TADSCustomTextField(
                label: AppLocalizations.of(context)!.emailField,
                prefixIcon: IconlyLight.message,
                onChanged: (value) => widget.store.email = value,
                validate: (_) => widget.store.emailInstance
                    .hasError(AppLocalizations.of(context)!.emailError),
              ),
              SizedBox(height: size.height * 0.18),
              Column(
                children: [
                  TripleBuilder<ForgotPassStore, IAppException,
                      ForgotPassState>(
                    store: widget.store,
                    builder: (context, state) {
                      return TADSCustomButton(
                        text: AppLocalizations.of(context)!.resetPass,
                        isLoading: state.isLoading,
                        width: 320,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (!state.isLoading) {
                              widget.store
                                  .forgotPass(AppLocalizations.of(context)!);
                            }
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.02),
              TADSCustomButtonWithPhrase(
                phrase: AppLocalizations.of(context)!.resetedMyPass,
                buttonTitle: AppLocalizations.of(context)!.resetPassToLogin,
                onPressed: () =>
                    Modular.to.pushReplacementNamed(AppRoutes.toLogin),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
