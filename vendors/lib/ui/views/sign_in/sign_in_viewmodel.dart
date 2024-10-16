import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:vendors/services/auth_service.dart';
import 'package:vendors/app/app.locator.dart';
import 'package:vendors/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class SignInViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  final _navigationService = locator<NavigationService>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? errorMessage; // Single error message

  Future<void> signIn() async {
    setBusy(true);
    final response = await _authService.signIn(
      email: emailController.text,
      password: passwordController.text,
    );
    setBusy(false);

    if (response.hasError) {
      // Display a generic error message
      errorMessage = response.error?['error'];
      notifyListeners();
    } else {
      _navigationService.navigateTo(Routes.vendorView);
    }
  }

  void navigateToSignUp() {
    _navigationService.navigateTo(Routes.signUpView);
  }
}
