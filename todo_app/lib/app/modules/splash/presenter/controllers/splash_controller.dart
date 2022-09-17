import 'package:core/core.dart';
import 'package:dependency_module/dependency_module.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class SplashController {
  const SplashController(
      this._getUserInfoUsecase, this.authStore, this.connectionService);

  final IGetUserInfoUsecase _getUserInfoUsecase;
  final AuthStore authStore;
  final IConnectionService connectionService;

  Future<void> initApp() async {
    final result = await _getUserInfoUsecase();

    result.fold((l) => authStore.logout(), login);
  }

  Future<void> login(UserEntity user) async {
    !kIsWeb && !connectionService.isOnline
        ? _loginIfIsOffline(user)
        : await _loginIfIsOnlineOrIsWeb(user);
  }

  void _loginIfIsOffline(UserEntity user) => authStore.authentication(user);

  Future<void> _loginIfIsOnlineOrIsWeb(UserEntity user) async {
    if (FirebaseAuth.instance.currentUser != null) {
      await authStore.authentication(user);
    } else {
      authStore.logout();
    }
  }

  void redirectUser(AuthState state) {
    if (state is AuthLoggedState) {
      Modular.to.pushReplacementNamed(AppRoutes.toHome);
    } else if (state is AuthLoggedOutState) {
      Modular.to.pushReplacementNamed(AppRoutes.toLogin);
    }
  }
}
