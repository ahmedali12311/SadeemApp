import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:vendors/ui/views/sign_in/sign_in_view.dart';
import 'package:vendors/ui/views/sign_up/sign_up_view.dart';
import 'package:vendors/ui/views/intro/intro_view.dart';

@StackedApp(routes: [
  MaterialRoute(page: IntroView, initial: true),
  MaterialRoute(page: SignUpView),
  MaterialRoute(page: SignInView),
], dependencies: [
  LazySingleton(classType: NavigationService),
])
class App {}
