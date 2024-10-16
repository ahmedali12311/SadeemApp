import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendors/app/app.locator.dart';
import 'package:vendors/app/app.router.dart';
import 'package:vendors/services/auth_service.dart';

class SignUpViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? nameError;
  String? emailError;
  String? phoneError;
  String? passwordError;
  XFile? imageFile;
  String? generalError;

  Future<void> signUp() async {
    setBusy(true);

    final response = await _authService.signUp(
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      password: passwordController.text,
      imageFile: imageFile,
    );

    setBusy(false);

    if (response.hasError) {
      generalError = (response.error['error']);

      final errorMap = response.error?['error'];
      if (errorMap != null) {
        nameError = errorMap['name'];
        emailError = errorMap['email'];
        phoneError = errorMap['phone'];
        passwordError = errorMap['password'];
      }
      notifyListeners(); // Notify UI to update
    } else {
      print("Sign-up successful: ${response.data}");
      _navigationService.replaceWith(Routes.signInView);
    }
  }

// Inside SignUpViewModel
  String? imageName;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    imageFile = await picker.pickImage(source: ImageSource.gallery);

    // Update the image name based on the picked image
    if (imageFile != null) {
      imageName = imageFile!.name; // You can still keep this if needed
    } else {
      imageName = null; // Reset if no image selected
    }
    notifyListeners();
  }

  void navigateToSignIn() {
    _navigationService.navigateTo(Routes.signInView);
  }
}
