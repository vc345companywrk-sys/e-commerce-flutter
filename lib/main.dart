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
  await dotenv.load(fileName: '.env');
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
//**************************************troubleshoot */
// lib/main.dart
// lib/main.dart
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'controllers/auth_controller.dart';
// import 'package:ecommerce_app/screens/E_auth/signup_test.dart';
// import 'package:ecommerce_app/service/supabase_service.dart';
// import 'package:ecommerce_app/screens/E_auth/login_test.dart';
// import 'package:ecommerce_app/screens/A_home/home_test.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   try {
//     print('🚀 Initializing Supabase...');

//     await Supabase.initialize(
//       url: 'https://iffkycfypeqxsgjzwjbx.supabase.co',
//       anonKey:
//           'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlmZmt5Y2Z5cGVxeHNnanp3amJ4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgzNjk4NDMsImV4cCI6MjA3Mzk0NTg0M30.hFJBMMlmHWL0CxPINb9jbsnBM9ZxVeJher_DvEW_xws',
//     );

//     print('✅ Supabase initialized successfully');
//     runApp(MyApp());
//   } catch (e) {
//     print('❌ Supabase initialization failed: $e');
//     runApp(
//       MaterialApp(
//         home: Scaffold(body: Center(child: Text('Error: $e'))),
//       ),
//     );
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Ecommerce App',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       initialRoute: '/',
//       getPages: [
//         GetPage(
//           name: '/',
//           page: () => AppWrapper(),
//           binding: BindingsBuilder(() {
//             Get.put(
//               AuthController(),
//               permanent: true,
//             ); // ✅ FIXED: permanent binding
//           }),
//         ),
//         GetPage(
//           name: '/login',
//           page: () => LoginTest(),
//           binding: BindingsBuilder(() {
//             Get.put(
//               AuthController(),
//               permanent: true,
//             ); // ✅ FIXED: permanent binding
//           }),
//         ),
//         GetPage(
//           name: '/signup',
//           page: () => SignupTest(),
//           binding: BindingsBuilder(() {
//             Get.put(
//               AuthController(),
//               permanent: true,
//             ); // ✅ FIXED: permanent binding
//           }),
//         ),
//         GetPage(name: '/home', page: () => HomeTest()),
//       ],
//     );
//   }
// }

// class AppWrapper extends StatelessWidget {
//   final AuthController authController =
//       Get.find<AuthController>(); // ✅ Now it will always be available

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (authController.isLoading.value && !authController.isLoggedIn.value) {
//         return Scaffold(
//           body: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircularProgressIndicator(),
//                 SizedBox(height: 20),
//                 Text('Checking authentication...'),
//               ],
//             ),
//           ),
//         );
//       }
//       return authController.isLoggedIn.value ? HomeTest() : LoginTest();
//     });
//   }
// }
