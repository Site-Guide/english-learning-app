import 'package:flutter/material.dart';
import 'auth/register_page.dart';
import 'root.dart';
import 'splash/splash_page.dart';

class AppRouter {
  static Route<dynamic> onNavigate(RouteSettings settings) {
    late final Widget selectedPage;
    switch (settings.name) {
      case RegisterPage.route:
        selectedPage = RegisterPage();
        break;

      case SplashPage.route:
        selectedPage = const SplashPage();
        break;
      default:
        selectedPage = const Root();
        break;
    }
    return MaterialPageRoute(builder: (context) => selectedPage);
  }
}
