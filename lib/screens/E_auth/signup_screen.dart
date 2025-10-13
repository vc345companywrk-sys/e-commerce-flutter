import 'package:ecommerce_app/common_widgets/app_logo_widgets.dart';
import 'package:ecommerce_app/common_widgets/bg_auth.dart';
import 'package:ecommerce_app/common_widgets/button_auth.dart';
import 'package:ecommerce_app/common_widgets/textfield_auth.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/controllers/auth_controller.dart';

// import 'package:ecommerce_app/consts/social_medial_logo.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool? isCheck = false; //for checkbox
  final AuthController authController = Get.find<AuthController>();
  //var authController = Get.put(AuthController());
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return bgAuth(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              //it adjust the screen according to the devive(0.1 => use 10% from 100% of size of Screen)
              (context.screenHeight * 0.07).heightBox,
              //app_logo_widgets.dart
              appLogoWidgets(50, 50),
              10.heightBox,
              //strings.dart
              'Signup to $appname'.text.fontFamily(bold).white.size(17).make(),
              17.heightBox,
              Obx(
                () =>
                    Column(
                          children: [
                            //textField_auth.dart
                            textFieldAuth(
                              titleCommon: name,
                              hintCommon: nameHint,
                              controller: nameController,
                              obsSecure: false,
                            ),
                            3.heightBox,
                            textFieldAuth(
                              titleCommon: email,
                              hintCommon: emailHint,
                              controller: emailController,
                              obsSecure: false,
                            ),
                            3.heightBox,
                            textFieldAuth(
                              titleCommon: phone,
                              hintCommon: phoneHint,
                              controller: phoneController,
                              obsSecure: false,
                            ),
                            3.heightBox,
                            textFieldAuth(
                              titleCommon: password,
                              hintCommon: passwordHint,
                              controller: passwordController,
                              obsSecure: true,
                            ),
                            3.heightBox,
                            textFieldAuth(
                              titleCommon: reTypePassword,
                              hintCommon: passwordHint,
                              controller: confirmPasswordController,
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
                            10.heightBox,
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: whiteColor,
                                  activeColor: redColor,
                                  value: isCheck,
                                  onChanged: (newValue) {
                                    setState(() {
                                      isCheck = newValue;
                                    });
                                  },
                                ),
                                //1.widthBox,
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "I agree to the ",
                                          style: TextStyle(
                                            fontFamily: regular,
                                            color: fontGrey,
                                          ),
                                        ),
                                        TextSpan(
                                          text: termsAndCondition,
                                          style: TextStyle(
                                            fontFamily: regular,
                                            color: redColor,
                                          ),
                                        ),
                                        TextSpan(
                                          text: " & ",
                                          style: TextStyle(
                                            fontFamily: regular,
                                            color: fontGrey,
                                          ),
                                        ),
                                        TextSpan(
                                          text: privacyPolicy,
                                          style: TextStyle(
                                            fontFamily: regular,
                                            color: redColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            5.heightBox,
                            authController.isLoading.value
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                      redColor,
                                    ),
                                  )
                                : buttonAuth(
                                    color: isCheck == true
                                        ? redColor
                                        : lightgolden,
                                    textColor: whiteColor,
                                    title: signup,
                                    onPress: () async {
                                      if (isCheck != false) {
                                        try {
                                          // Clear previous errors
                                          authController.errorMessage('');

                                          authController.isLoading(true);

                                          // Validation
                                          if (emailController.text.isEmpty ||
                                              passwordController.text.isEmpty ||
                                              confirmPasswordController
                                                  .text
                                                  .isEmpty) {
                                            authController.errorMessage(
                                              'Please fill all fields',
                                            );
                                            authController.isLoading(false);
                                            return;
                                          }

                                          if (passwordController.text !=
                                              confirmPasswordController.text) {
                                            authController.errorMessage(
                                              'Passwords do not match',
                                            );
                                            authController.isLoading(false);
                                            return;
                                          }

                                          if (passwordController.text.length <
                                              6) {
                                            authController.errorMessage(
                                              'Password must be at least 6 characters',
                                            );
                                            authController.isLoading(false);
                                            return;
                                          }

                                          // Basic email validation
                                          if (!emailController.text.contains(
                                                '@',
                                              ) ||
                                              !emailController.text.contains(
                                                '.',
                                              )) {
                                            authController.errorMessage(
                                              'Please enter a valid email address',
                                            );
                                            authController.isLoading(false);
                                            return;
                                          }

                                          await authController.signUp(
                                            emailController.text,
                                            passwordController.text,
                                            nameController.text,
                                            phoneController.text,
                                          );
                                          authController.isLoading(false);
                                          Get.snackbar(
                                            'Success',
                                            'Open new account Succesfully',
                                          );
                                        } catch (e) {
                                          authController.signOut();
                                          authController.isLoading(false);
                                          Get.snackbar(
                                            'Error!',
                                            'Some went wrong!',
                                          );
                                        }
                                      }
                                    },
                                  ).box.width(context.screenHeight - 50).make(),
                            25.heightBox,
                            //WRAPING INTO GESTURE DETECTOR OF VELOCITY X(.onTap(){})
                            // RichText(
                            //   text: TextSpan(
                            //     children: [
                            //       TextSpan(
                            //         text: alreadyAccount,
                            //         style: TextStyle(
                            //           fontFamily: bold,
                            //           color: fontGrey,
                            //         ),
                            //       ),
                            //       TextSpan(
                            //         text: login,
                            //         style: TextStyle(
                            //           fontFamily: bold,
                            //           color: redColor,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ).onTap(() {
                            //   //Gesture Detector
                            //   Get.back();
                            // }),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                alreadyAccount.text.color(fontGrey).make(),
                                login.text.color(redColor).make(),
                              ],
                            ).onTap(() {
                              Get.back();
                            }),
                            5.heightBox,
                          ],
                        ).box.white.rounded
                        .padding(const EdgeInsets.all(16))
                        .width(context.screenWidth - 45)
                        .shadowSm
                        .make(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
