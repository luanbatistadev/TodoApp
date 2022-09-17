import 'package:core/translate/app_localizations.dart';

class ForgotPassDTO {
  const ForgotPassDTO({
    this.email = '',
    this.localizations,
  });
  final String email;
  final AppLocalizations? localizations;
}
