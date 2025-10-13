import 'package:ecommerce_app/common_widgets/app_logo_widgets.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/controllers/auth_controller.dart';
import 'package:ecommerce_app/screens/A_home/home.dart';
import 'package:ecommerce_app/screens/E_auth/login_screen.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
    _initializeApp();
  }

  // In your splash screen's initState
  // In your splash screen's initState
  Future<void> _checkAuthAndNavigate() async {
    try {
      await Future.delayed(Duration(seconds: 3));

      // Check auth status
      await authController.checkCurrentUser();

      // Use the new navigation method
      authController.navigateBasedOnAuthState();
    } catch (e) {
      print('Splash screen error: $e');
      Get.offAll(() => LoginScreen());
    }
  }

  Future<void> _initializeApp() async {
    // Show splash for 3 seconds
    await Future.delayed(Duration(seconds: 3));

    // Check authentication status and navigate
    if (authController.isLoggedIn.value) {
      Get.offAll(() => Home());
    } else {
      Get.offAll(() => LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(196, 255, 82, 82),
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Image.asset(icSplashBg, width: 300),
              ),
              20.heightBox,
              appLogoWidgets(77, 77),
              const SizedBox(height: 10),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(whiteColor),
              ),
              5.heightBox,
              appname.text.fontFamily(bold).size(20).white.make(),

              // Optional: Show loading status
              Obx(
                () => authController.isLoading.value
                    ? "Checking authentication...".text.white.size(12).make()
                    : SizedBox.shrink(),
              ),

              const Spacer(),
              appversion.text.white.size(7).make(),
              credits.text.white.fontFamily(semibold).size(3).make(),
              5.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
