import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/controllers/auth_controller.dart';
import 'package:ecommerce_app/controllers/cart_controller.dart';
import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:ecommerce_app/screens/A_home/home.dart';
import 'package:ecommerce_app/screens/E_auth/login_screen.dart';
import 'package:ecommerce_app/screens/E_auth/signup_screen.dart';

import 'package:ecommerce_app/screens/splash_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; //Using GetX

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Supabase
  await dotenv.load(fileName: 'backend/.env');
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //We are using so we have to change the MaterialApp to GetMaterialApp
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appname,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: darkFontGrey),
          backgroundColor: Colors.transparent,
        ),
        fontFamily: regular,
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      //home: const SplashScreen(),
      //ADD THIS: Define named routes
      // initialBinding: BindingsBuilder(() {
      //   Get.put(HomeController());
      //   Get.put(CartController());
      // }),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => SplashScreen(),
          binding: BindingsBuilder(() {
            Get.put(AuthController(), permanent: true);
            Get.put(CartController(), permanent: true);
            Get.put(HomeController(), permanent: true);
          }),
        ),
        GetPage(
          name: '/login',
          page: () => LoginScreen(),
          binding: BindingsBuilder(() {
            Get.put(AuthController(), permanent: true);
            Get.put(CartController(), permanent: true);
            Get.put(HomeController(), permanent: true);
          }),
        ),
        GetPage(
          name: '/signup',
          page: () => SignupScreen(),
          binding: BindingsBuilder(() {
            Get.put(AuthController(), permanent: true);
            Get.put(CartController(), permanent: true);
            Get.put(HomeController(), permanent: true);
          }),
        ),
        GetPage(
          name: '/home',
          page: () => Home(),
          binding: BindingsBuilder(() {
            Get.put(CartController(), permanent: true);
            Get.put(HomeController(), permanent: true);
          }),
        ),
      ],
    );
  }
}
