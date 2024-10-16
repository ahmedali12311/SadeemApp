import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendors/app/app.locator.dart';
import 'package:vendors/app/app.router.dart';

import '../../../services/auth_service.dart';

class IntroViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();

  Future<void> checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('firstLaunch') ?? true;

    // Check if the user has a valid token
    final token = prefs.getString('authToken');

    if (isFirstLaunch) {
      // First time launching the app
      _navigationService.replaceWith(Routes.introView);
    } else if (token != null && await _authService.isValidToken()) {
      // Token is valid, redirect to VendorView
      _navigationService.replaceWith(Routes.vendorView);
    } else {
      // No valid token, proceed to SignInView
      _navigationService.replaceWith(Routes.signInView);
    }
  }

  Future<void> navigateToSignUp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('firstLaunch', false);
    _navigationService.replaceWith(Routes.signUpView);
  }
}
