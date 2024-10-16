import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'sign_in_viewmodel.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SignInView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignInViewModel>.reactive(
      viewModelBuilder: () => SignInViewModel(),
      builder: (context, viewModel, child) => Scaffold(
        body: Stack(
          children: [
            // White background
            Container(
              color: Colors.white,
            ),
            // Vendor image with opacity
            Opacity(
              opacity: 0.1,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/vendor.jpg'), // Ensure the image path is correct
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Main content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 60),
                    Text(
                      'مرحبًا بعودتك',
                      style: TextStyle(
                        fontSize: 36, // Increased font size
                        fontWeight: FontWeight.bold,
                        color:
                            Color(0xFF3A9C9F), // Changed color for consistency
                        letterSpacing: 1.2, // Added letter spacing
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 30),
                    _buildTextField(
                      context,
                      viewModel.emailController,
                      'البريد الإلكتروني',
                      false, // No error message for this field
                      TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      context,
                      viewModel.passwordController,
                      'كلمة المرور',
                      false, // No error message for this field
                      null,
                      true,
                    ),
                    SizedBox(height: 20),

                    // Error message display
                    if (viewModel.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          viewModel.errorMessage!,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    if (viewModel.isBusy)
                      LoadingAnimationWidget.fallingDot(
                        color: Theme.of(context).primaryColor,
                        size: 40,
                      )
                    else
                      _buildFlatButton(
                        onPressed: viewModel.signIn,
                        text: 'تسجيل الدخول',
                      ),
                    SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: viewModel.navigateToSignUp,
                        child: Text(
                          'لا تملك حسابًا؟ انضم إلينا',
                          style: TextStyle(
                              color: Color(0xFF3A9C9F),
                              fontSize: 16), // Consistent color and size
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

  Widget _buildTextField(BuildContext context, TextEditingController controller,
      String label, bool isError, // Change to bool to indicate error state
      [TextInputType? keyboardType,
      bool obscureText = false]) {
    return Directionality(
      textDirection: TextDirection.rtl, // Set text direction to RTL
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black26, blurRadius: 10, offset: Offset(0, 5)),
          ],
        ),
        child: TextField(
          controller: controller,
          textAlign: TextAlign.right, // Align text to the right
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white, // Change text color based on theme
          ),
          decoration: InputDecoration(
            labelText: label,
            errorText: isError ? null : null, // Do not show error text here
            prefixIcon: Icon(Icons.person, color: Color(0xFF3A9C9F)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: isError ? Colors.red : Colors.transparent, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: isError ? Colors.red : Color(0xFF3A9C9F), width: 2),
            ),
            contentPadding: EdgeInsets.all(16),
          ),
          keyboardType: keyboardType,
          obscureText: obscureText,
        ),
      ),
    );
  }

  Widget _buildFlatButton(
      {required VoidCallback onPressed, required String text}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3A9C9F), Color(0xFF1A7B7C)],
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
        child: Text(
          text,
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
