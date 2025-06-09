import 'package:get/get.dart';
import 'modules/login_screens/login_page.dart';
import 'home_page.dart';
import 'modules/login_screens/welcome_page.dart';
import 'modules/login_screens/register_page.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/welcome', page: () => WelcomePage()),
    GetPage(name: '/login', page: () => LoginPage()),
    GetPage(name: '/register', page: () => RegisterPage()),
    GetPage(name: '/home', page: () => HomePage()),
  ];
}
