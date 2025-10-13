import 'package:ecommerce_app/common_widgets/app_logo_widgets.dart';
import 'package:ecommerce_app/common_widgets/bg_auth.dart';
import 'package:ecommerce_app/common_widgets/button_auth.dart';
import 'package:ecommerce_app/common_widgets/textfield_auth.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/consts/lists.dart';
import 'package:ecommerce_app/controllers/auth_controller.dart';
import 'package:ecommerce_app/screens/A_home/home.dart';
import 'package:ecommerce_app/screens/E_auth/signup_screen.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //final AuthController authController = Get.find<AuthController>();
  var authController = Get.put(AuthController());
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      //Listen for auth state changes and navigate when logged in
      if (authController.isLoggedIn.value) {
        // Use delayed navigation to avoid context issues
        Future.delayed(Duration(milliseconds: 100), () {
          if (Get.currentRoute == '/login') {
            Get.offAll(() => Home());
          }
        });
      }
      return bgAuth(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
            child: Column(
              children: [
                //it adjust the screen according to the devive(0.1 => use 10% from 100% of size of Screen)
                (context.screenHeight * 0.1).heightBox,
                //app_logo_widgets.dart
                appLogoWidgets(50, 50),
                10.heightBox,
                //strings.dart
                'Login to $appname'.text.fontFamily(bold).white.size(17).make(),
                17.heightBox,

                Column(
                      children: [
                        //textField_auth.dart
                        textFieldAuth(
                          titleCommon: email,
                          hintCommon: emailHint,
                          controller: emailController,
                          obsSecure: false,
                        ),
                        7.heightBox,
                        textFieldAuth(
                          titleCommon: password,
                          hintCommon: passwordHint,
                          controller: passwordController,
                          obsSecure: true,
                        ),
                        3.heightBox,
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: forgetPassword.text.make(),
                          ),
                        ),
                        7.heightBox,

                        // //for SUPABASE
                        // Obx(
                        //   () => authController.errorMessage.isNotEmpty
                        //       ? Text(
                        //           authController.errorMessage.value,
                        //           style: TextStyle(color: Colors.red),
                        //         )
                        //       : SizedBox.shrink(),
                        // ),
                        Obx(
                          () => authController.isLoading.value
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(redColor),
                                )
                              : buttonAuth(
                                  color: redColor,
                                  textColor: whiteColor,
                                  title: login,
                                  onPress: () async {
                                    // //EXTRA SAFE VALIDATION
                                    // if (emailController.text == null) {
                                    //   VxToast.show(
                                    //     context,
                                    //     msg: "Email field error",
                                    //   );
                                    //   return;
                                    // }

                                    final email = emailController.text.trim();
                                    final password = passwordController.text
                                        .trim();

                                    if (email.isEmpty) {
                                      // Check if it's whitespace-only
                                      if (emailController.text.trim().isEmpty &&
                                          emailController.text.isNotEmpty) {
                                        VxToast.show(
                                          context,
                                          msg: "Email contains only spaces",
                                        );
                                      } else {
                                        VxToast.show(
                                          context,
                                          msg: "Please enter email",
                                        );
                                      }
                                      return;
                                    }

                                    if (password.isEmpty) {
                                      VxToast.show(
                                        context,
                                        msg: "Please enter password",
                                      );
                                      return;
                                    }

                                    authController.isLoading(true);

                                    // final success = await authController.signIn(
                                    //   email,
                                    //   password,
                                    // );
                                    await authController.signIn(
                                      email,
                                      password,
                                    );

                                    authController.isLoading(false);
                                  },
                                ).box.width(context.screenHeight - 50).make(),
                        ),
                        15.heightBox,
                        createNewAccount.text.color(fontGrey).make(),
                        5.heightBox,
                        buttonAuth(
                          color: lightgolden,
                          title: signup,
                          textColor: redColor,
                          onPress: () {
                            Get.to(() => SignupScreen());
                          },
                        ).box.width(context.screenWidth - 50).make(),
                        20.heightBox,
                        loginWith.text.color(fontGrey).make(),
                        5.heightBox,
                        //SOCILA MEDIA LOGO
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            3,
                            (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundColor: lightGrey,
                                radius: 25,
                                child: Image.asset(
                                  socialMediaLogo[index],
                                  width: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ).box.white.rounded
                    .padding(const EdgeInsets.all(16))
                    .width(context.screenWidth - 45)
                    .shadowSm
                    .make(),
              ],
            ),
          ),
        ),
      );
    });
  }
}
