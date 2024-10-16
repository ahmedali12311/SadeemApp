import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'intro_viewmodel.dart';

class IntroView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<IntroViewModel>.reactive(
      viewModelBuilder: () => IntroViewModel(),
      onViewModelReady: (viewModel) => viewModel.checkFirstLaunch(),
      builder: (context, viewModel, child) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 200,
                child: Image.asset('assets/rocket.gif'),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'مرحبًا بكم في تطبيق البائع الخاص بنا!\nتواصل مع بائعينك المفضلين واكتشف صفقات مذهلة!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: viewModel.navigateToSignUp,
                child: Text('ابدأ الآن'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
