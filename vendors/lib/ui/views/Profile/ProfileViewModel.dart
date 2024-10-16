import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendors/services/profileservice.dart';
import 'package:vendors/models/user.dart';

class ProfileViewModel extends BaseViewModel {
  final ProfileService _profileService = ProfileService();
  User? user;
  String? errorMessage;
  Map<String, String?> fieldErrors = {};

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void initializeControllers() {
    nameController.text = user?.name ?? '';
    emailController.text = user?.email ?? '';
    phoneController.text = user?.phone ?? '';
  }

  Future<void> fetchUserData() async {
    setBusy(true);
    try {
      user = await _profileService.getUserData();
      clearErrors();
    } catch (e) {
      errorMessage = 'Failed to load user data: $e';
    }
    setBusy(false);
    notifyListeners();
  }

  Future<void> updateUserData(String userId, String name, String email,
      String password, String phone, XFile? imageFile) async {
    // Clear errors before starting the update
    clearErrors();

    setBusy(true);
    try {
      await _profileService.updateUserData(
        userId,
        name,
        email,
        password,
        phone,
        imageFile,
      );
      await fetchUserData();
    } catch (e) {
      handleErrors(e); // Handle any errors
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  void clearErrors() {
    fieldErrors.clear(); // Clear field errors
    errorMessage = ''; // Clear general error message
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      user?.pickedImage = image; // Store the picked image
      notifyListeners(); // Notify listeners to refresh UI
    }
  }

  String? getProfileImage() {
    // Prioritize the local picked image if it exists, otherwise use the backend image URL
    if (user?.pickedImage != null) {
      return user?.pickedImage?.path;
    }
    return user?.imageUrl;
  }

  void handleErrors(dynamic error) {
    // Clear existing errors
    clearErrors();

    // Check if the error is of type Exception
    if (error is Exception) {
      String errorMessage = error.toString();

      // Attempt to parse the message as JSON
      if (errorMessage.contains('{')) {
        final jsonStartIndex = errorMessage.indexOf('{');
        final jsonString = errorMessage.substring(jsonStartIndex);

        try {
          Map<String, dynamic> errorMap = jsonDecode(jsonString);

          if (errorMap.containsKey('error') && errorMap['error'] is Map) {
            final newFieldErrors = Map<String, String?>.from(errorMap['error']);

            // Use a single assignment to ensure no duplicates
            fieldErrors.addAll(newFieldErrors);

            print('Field errors: $fieldErrors');
          } else {
            errorMessage =
                'Failed to update user data: Unknown error structure';
          }
        } catch (e) {
          errorMessage = 'Failed to parse error message: $e';
        }
      } else {
        errorMessage = 'Failed to update user data: $errorMessage';
      }
    } else {
      errorMessage = 'An unknown error occurred';
    }

    // Update the view model with the new error message
    this.errorMessage = errorMessage;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
