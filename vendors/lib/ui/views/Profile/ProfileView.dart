import 'dart:io';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:vendors/ui/views/cart/CartView.dart';
import 'package:vendors/ui/views/orders/userorderview.dart';
import 'package:vendors/ui/views/vendor/VendorView.dart';
import 'ProfileViewModel.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late int _selectedIndex = 1;
  void _onTabSelected(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => VendorView(),
          transitionDuration: Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    } else if (index == 1) {
      // Do nothing because we are already on ProfileView
    } else if (index == 2) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => CartView(),
          transitionDuration: Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    } else {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              UserOrderView(),
          transitionDuration: Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      onModelReady: (viewModel) {
        viewModel.fetchUserData().then((_) {
          viewModel.initializeControllers();
        });
      },
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return Scaffold(
            backgroundColor: Colors.white, // Set a consistent background color
            body: Center(
              child: LoadingAnimationWidget.fallingDot(
                color: Theme.of(context).primaryColor,
                size: 40,
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
            backgroundColor: Color(0xFF3A9C9F),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildProfileImage(viewModel),
                  SizedBox(height: 24),
                  _buildTextField(
                      context,
                      viewModel,
                      viewModel.nameController,
                      'Name',
                      viewModel.fieldErrors['name'],
                      (value) => viewModel.user?.name = value),
                  _buildTextField(
                      context,
                      viewModel,
                      viewModel.emailController,
                      'Email',
                      viewModel.fieldErrors['email'],
                      (value) => viewModel.user?.email = value),
                  _buildTextField(
                      context,
                      viewModel,
                      viewModel.phoneController,
                      'Phone',
                      viewModel.fieldErrors['phone'],
                      (value) => viewModel.user?.phone = value),
                  _buildTextField(
                      context,
                      viewModel,
                      viewModel.passwordController,
                      'Password',
                      viewModel.fieldErrors['password'],
                      (value) => viewModel.user?.password = value,
                      obscureText: true),
                  SizedBox(height: 20),
                  _buildUpdateButton(viewModel, context),
                ],
              ),
            ),
          ),
          bottomNavigationBar: FlashyTabBar(
            selectedIndex: _selectedIndex,
            showElevation: true,
            onItemSelected: _onTabSelected,
            backgroundColor: Theme.of(context).colorScheme.primary,
            items: [
              FlashyTabBarItem(
                icon: Icon(Icons.home,
                    color: Theme.of(context).colorScheme.onPrimary),
                title: Text('Home',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary)),
              ),
              FlashyTabBarItem(
                icon: Icon(Icons.person,
                    color: Theme.of(context).colorScheme.onPrimary),
                title: Text('Profile',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary)),
              ),
              FlashyTabBarItem(
                icon: Icon(Icons.shopping_cart,
                    color: Theme.of(context).colorScheme.onPrimary),
                title: Text('Cart',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary)),
              ),
              FlashyTabBarItem(
                icon: Icon(Icons.list_alt,
                    color: Theme.of(context).colorScheme.onPrimary),
                title: Text('Orders',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileImage(ProfileViewModel viewModel) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: viewModel.getProfileImage() != null
              ? (viewModel.user?.pickedImage != null
                  ? FileImage(File(viewModel.getProfileImage()!))
                  : NetworkImage(viewModel.getProfileImage()!)
                      as ImageProvider<Object>?)
              : AssetImage('assets/profile.jpg') as ImageProvider<Object>,
        ),
        GestureDetector(
          onTap: () async {
            await viewModel.pickImage();
          },
          child: Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
            ),
            child: Icon(Icons.camera_alt, color: Color(0xFF3A9C9F)),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    BuildContext context,
    ProfileViewModel viewModel,
    TextEditingController controller,
    String label,
    String? errorText,
    Function(String) onChanged, {
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        style: TextStyle(
          height: 1.5,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white, // Change text color based on theme
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Color(0xFF3A9C9F)),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF3A9C9F)),
          ),
          errorText: errorText,
          errorStyle: TextStyle(color: Colors.red),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: errorText != null ? Colors.red : Color(0xFF3A9C9F),
            ),
          ),
        ),
        obscureText: obscureText,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildUpdateButton(ProfileViewModel viewModel, BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await viewModel.updateUserData(
          viewModel.user?.id ?? '',
          viewModel.nameController.text,
          viewModel.emailController.text,
          viewModel.passwordController.text,
          viewModel.phoneController.text,
          viewModel.user?.pickedImage,
        );

        // Check for field errors and display the appropriate message
        if (viewModel.fieldErrors.isNotEmpty) {
          // Combine field errors into a single message to show in snackbar
          String combinedErrors = viewModel.fieldErrors.values
              .where((error) => error != null)
              .join('\n');
          _showSnackBar(context, combinedErrors, isError: true);
        } else if (viewModel.errorMessage != null &&
            viewModel.errorMessage!.isNotEmpty) {
          _showSnackBar(context, viewModel.errorMessage!, isError: true);
        } else {
          _showSnackBar(context, 'Profile updated successfully',
              isError: false);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF3A9C9F),
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text('Update Profile', style: TextStyle(color: Colors.white)),
    );
  }

  void _showSnackBar(BuildContext context, String message,
      {required bool isError}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: isError ? Colors.white : Colors.black),
      ),
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
