import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fiscal_box/controllers/home_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'routes/app_routes.dart';
import 'controllers/auth_controller.dart';
import 'services/local_db_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDbService.init();

  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  Get.put(AuthController());
  Get.put(HomeController(), permanent: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FiscalBox',
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      getPages: AppRoutes.routes,
      locale: Locale('pt', 'BR'),
    );
  }
}
