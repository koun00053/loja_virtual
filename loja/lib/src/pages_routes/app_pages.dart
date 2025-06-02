import 'package:dagugi_acessorios/main.dart';
import 'package:dagugi_acessorios/src/auth/components/sing_up_screen.dart';
import 'package:dagugi_acessorios/src/pages/auth/sign_in_screen.dart';
import 'package:dagugi_acessorios/src/pages/auth/splash_screen.dart';
import 'package:dagugi_acessorios/src/pages/base/base_screen.dart';
import 'package:get/get.dart';

abstract class AppPages {
  static final pages = <GetPage>{
    GetPage(
      page: () => SplashScreen(),
      name: PagesRouts.splashRoute,
    ),
    GetPage(
      page: () => SignInScreen(),
      name: PagesRouts.signinRoute,
    ),
    GetPage(
      page: () => SignUpScreen(),
      name: PagesRouts.signupRoute,
    ),
    GetPage(
      page: () => BaseScreen(),
      name: PagesRouts.baseRoute,
    ),
  };
}

abstract class PagesRouts {
  static const String signinRoute = '/signin';
  static const String signupRoute = '/signup';
  static const String splashRoute = '/splash';
  static const String baseRoute = '/';
}
