import 'package:english/ui/auth/get_started_page.dart';
import 'package:english/ui/auth/login_page.dart';
import 'package:english/ui/auth/reset_password_page.dart';
import 'package:english/ui/meet/meet_init_page.dart';
import 'package:english/ui/plans/plans_page.dart';
import 'package:flutter/material.dart';
import 'auth/register_page.dart';
import 'root.dart';
import 'splash/splash_page.dart';

class AppRouter {
  static Route<dynamic> onNavigate(RouteSettings settings) {
    late final Widget selectedPage;
    switch (settings.name) {
      case GetsStartedPage.route:
        selectedPage = GetsStartedPage();
        break;
      case RegisterPage.route:
        selectedPage = RegisterPage();
        break;
      case LoginPage.route:
        selectedPage = LoginPage();
        break;
      case SplashPage.route:
        selectedPage = const SplashPage();
        break;
      case ResetPasswordPage.route:
        selectedPage = const ResetPasswordPage();
        break;
      case MeetInitPage.route:
        selectedPage = const MeetInitPage();
        break;
      case PlansPage.route:
        selectedPage = const PlansPage();
        break;
      default:
        selectedPage = const Root();
        break;
    }
    return MaterialPageRoute(builder: (context) => selectedPage);
  }
}
