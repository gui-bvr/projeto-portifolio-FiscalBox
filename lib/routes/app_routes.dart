import 'package:get/get.dart';

// --> Páginas de Testes
// (/modules/test_screens)
import '../modules/test_screens/test_page_1.dart';

// --> Páginas de Login/Início
// (/modules/login_screens)
import '../modules/login_screens/forgotten_page.dart';
import '../modules/login_screens/login_page.dart';
import '../modules/login_screens/welcome_page.dart';
import '../modules/login_screens/register_page.dart';

// --> Páginas Principais
// (/modules/home_screens)
import '../modules/home_screens/home_page.dart';

// Rotas:
class AppRoutes {
  static final routes = [
    // --> Páginas de Testes
    // (/modules/test_screens)
    GetPage(name: '/test', page: () => TestPage()),
    // --> Páginas de Login/Início
    // (/modules/login_screens)
    GetPage(name: '/welcome', page: () => WelcomePage()),
    GetPage(name: '/login', page: () => LoginPage()),
    GetPage(name: '/register', page: () => RegisterPage()),
    GetPage(name: '/forgotten', page: () => ForgottenPasswordPage()),
    // --> Páginas Principais
    // (/modules/home_screens)
    GetPage(name: '/home', page: () => HomePage()),
  ];
}
