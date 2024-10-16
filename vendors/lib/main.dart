import 'package:flutter/material.dart';
import 'package:vendors/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:vendors/app/app.router.dart';
import 'package:get_it/get_it.dart';
import 'package:vendors/services/auth_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    GetIt.instance.registerSingleton<AuthService>(AuthService());
    setupLocator();
    runApp(MyApp());
  } catch (e) {
    print('Error during initialization: $e');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.teal, // Set primary color
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.teal, // Ensure color scheme uses primary color
          onPrimary: Colors.white, // Text color on primary color
          onSurface: Colors.black, // General text color
        ),
        // Remove or adjust the snackBarTheme
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors
              .black, // <--- Remove this line if you want to control background color per SnackBar
          contentTextStyle: TextStyle(color: Colors.white),
        ),
      ),
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      navigatorObservers: [StackedService.routeObserver],
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text('404 - Not Found'),
            ),
            body: Center(
              child: Text('Page not found'),
            ),
          ),
        );
      },
    );
  }
}
