import 'package:get/get.dart';

// --> Páginas de Login/Início
// (/modules/login_screens)
import '../modules/home_screens/folders_screens/notas_fiscais_folder_page.dart';
import '../modules/login_screens/forgotten_page.dart';
import '../modules/login_screens/login_page.dart';
import '../modules/login_screens/splash_page.dart';
import '../modules/login_screens/welcome_page.dart';
import '../modules/login_screens/register_page.dart';

// --> Páginas Principais
// (/modules/home_screens)
import '../modules/home_screens/home_page.dart';
import '../modules/home_screens/help_page.dart';
import '../modules/home_screens/about_page.dart';
import '../modules/home_screens/tutorial_page.dart';
import '../modules/home_screens/add_folder_page.dart';
import '../modules/home_screens/edit_folder_page.dart';

// Rotas:
class AppRoutes {
  static final routes = [
    // --> Páginas de Login/Início
    // (/modules/login_screens)
    GetPage(name: '/splash', page: () => SplashPage()),
    GetPage(name: '/welcome', page: () => WelcomePage()),
    GetPage(name: '/login', page: () => LoginPage()),
    GetPage(name: '/register', page: () => RegisterPage()),
    GetPage(name: '/forgotten', page: () => ForgottenPasswordPage()),
    // --> Páginas Principais
    // (/modules/home_screens)
    // Header
    GetPage(name: '/home', page: () => HomePage()),
    GetPage(name: '/ajuda', page: () => HelpPage()),
    GetPage(name: '/sobre', page: () => AboutPage()),
    // Home
    GetPage(name: '/adicionar', page: () => AddFolderPage()),
    GetPage(name: '/editar', page: () => EditFolderPage()),
    GetPage(name: '/tutorial', page: () => TutorialPage()),
    GetPage(name: '/pasta', page: () => NotaFiscalPastaPage()),
  ];
}
