import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'sign_up_viewmodel.dart';

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  List<Color> _signUpButtonColors = [Color(0xFF3A9C9F), Color(0xFF1A7B7C)];
  List<Color> _uploadImageButtonColors = [Color(0xFF3A9C9F), Color(0xFF1A7B7C)];
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.reactive(
      viewModelBuilder: () => SignUpViewModel(),
      builder: (context, viewModel, child) => Scaffold(
        body: Stack(
          children: [
            Container(
              color: Colors.white,
            ),
            Opacity(
              opacity: 0.1,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/vendor.jpg'), // Your image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'إنشاء حسابك',
                      style: TextStyle(
                        fontSize: 36, // Increased font size
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3A9C9F), // Changed color
                        letterSpacing: 1.2, // Added letter spacing
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 30),
                    _buildTextField(
                        viewModel.nameController, 'الاسم', viewModel.nameError),
                    SizedBox(height: 16),
                    _buildTextField(
                        viewModel.emailController,
                        'البريد الإلكتروني',
                        viewModel.emailError,
                        TextInputType.emailAddress),
                    SizedBox(height: 16),
                    _buildTextField(viewModel.phoneController, 'رقم الهاتف',
                        viewModel.phoneError, TextInputType.phone),
                    SizedBox(height: 16),
                    _buildTextField(viewModel.passwordController, 'كلمة المرور',
                        viewModel.passwordError, null, true),
                    SizedBox(height: 20),
                    _buildAnimatedButton(
                      onPressed: () {
                        _animateButtonPress(true);
                        viewModel.pickImage();
                      },
                      text: 'رفع صورة',
                      colors: _uploadImageButtonColors,
                    ),
// Display the selected image and its name if available
                    if (viewModel.imageFile !=
                        null) // Show the image if it's not null
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Distribute space between children
                          children: [
                            Expanded(
                              // Allows the text to use the remaining space
                              child: Text(
                                viewModel
                                    .imageFile!.name, // Show the image name
                                style: TextStyle(
                                    fontSize:
                                        16), // Set your desired text style
                                overflow: TextOverflow
                                    .ellipsis, // Prevent overflow if text is too long
                              ),
                            ),
                            Container(
                              height: 50, // Set height for square
                              width: 50, // Set width for square
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xFF3A9C9F),
                                    width: 2), // Optional border
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: FileImage(File(viewModel.imageFile!
                                      .path)), // Load the image from file
                                  fit: BoxFit.cover, // Scale the image to fit
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (viewModel.generalError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          viewModel.generalError!,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    SizedBox(height: 20),
                    _buildAnimatedButton(
                      onPressed: () {
                        _animateButtonPress(false);
                        viewModel.signUp();
                      },
                      text: 'تسجيل',
                      colors: _signUpButtonColors,
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: viewModel.navigateToSignIn,
                        child: Text(
                          "هل لديك حساب؟ قم بتسجيل الدخول",
                          style: TextStyle(
                              color: Color(0xFF3A9C9F),
                              fontSize: 16), // Styling for button text
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _animateButtonPress(bool isUploadImageButton) {
    setState(() {
      if (isUploadImageButton) {
        _uploadImageButtonColors = [Color(0xFF1A7B7C), Color(0xFF3A9C9F)];
      } else {
        _signUpButtonColors = [Color(0xFF1A7B7C), Color(0xFF3A9C9F)];
      }
    });

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        if (isUploadImageButton) {
          _uploadImageButtonColors = [Color(0xFF3A9C9F), Color(0xFF1A7B7C)];
        } else {
          _signUpButtonColors = [Color(0xFF3A9C9F), Color(0xFF1A7B7C)];
        }
      });
    });
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String? error, [
    TextInputType? keyboardType,
    bool obscureText = false,
  ]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Directionality(
          textDirection: TextDirection.rtl, // Set text direction to RTL
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // White background
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: controller,
              textAlign: TextAlign.right, // Align text to the right
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                  color: error != null
                      ? Colors.red
                      : Colors
                          .black, // Change label color to red if error, otherwise black
                ),
                prefixIcon: Icon(Icons.person,
                    color: Color(
                        0xFF3A9C9F)), // Icon is on the left side but aligns with the text
                border: error != null
                    ? OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      )
                    : OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                contentPadding: EdgeInsets.all(16),
              ),
              keyboardType: keyboardType,
              obscureText: obscureText,
            ),
          ),
        ),
        error != null
            ? Text(
                error,
                style: TextStyle(color: Colors.red),
              )
            : Container(), // Empty container if no error
      ],
    );
  }

  Widget _buildAnimatedButton(
      {required VoidCallback onPressed,
      required String text,
      required List<Color> colors}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
              color: Colors.black26, blurRadius: 10, offset: Offset(0, 5)),
        ],
      ),
      height: 60,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: onPressed,
        child: Text(
          text,
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
