import 'package:get/get.dart';
import 'login_page.dart';
import 'home_page.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/login', page: () => LoginPage()),
    GetPage(name: '/home', page: () => HomePage()),
  ];
}
