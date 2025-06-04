import 'package:get/get.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'welcome_page.dart';
import 'register_page.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/welcome', page: () => const WelcomePage()),
    GetPage(name: '/login', page: () => LoginPage()),
    GetPage(name: '/register', page: () => RegisterPage()),
    GetPage(name: '/home', page: () => HomePage()),
  ];
}
