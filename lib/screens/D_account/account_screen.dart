import 'package:ecommerce_app/common_widgets/bg_auth.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/consts/lists.dart';
import 'package:ecommerce_app/controllers/auth_controller.dart';
import 'package:ecommerce_app/screens/D_account/account_details.dart';
import 'package:get/get.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return bgAuth(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              3.heightBox,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.edit_sharp, color: whiteColor),
                ).onTap(() {}),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Image.asset(
                      profile,
                      width: 90,
                      fit: BoxFit.cover,
                    ).box.roundedFull.clip(Clip.antiAlias).make(),
                    3.widthBox,
                    Expanded(
                      child: Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            '${authController.userName.value}.'.text.white
                                .size(17)
                                .fontFamily(semibold)
                                .make(),
                            5.heightBox,
                            "${authController.userEmail.value}.".text.white
                                .size(13)
                                .make(),
                          ],
                        ),
                      ),
                    ),
                    5.widthBox,
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: whiteColor),
                      ),
                      onPressed: () {
                        authController.signOut();
                      },
                      child: logOut.text.fontFamily(semibold).white.make(),
                    ),
                  ],
                ),
              ),
              5.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  accountDetails(
                    title: 'in your cart',
                    count: '00',
                    width: context.screenWidth / 3.3,
                  ),
                  accountDetails(
                    title: 'in your wishlist',
                    count: '00',
                    width: context.screenWidth / 3.3,
                  ),
                  accountDetails(
                    title: 'you Ordered',
                    count: '00',
                    width: context.screenWidth / 3.3,
                  ),
                ],
              ),
              ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) =>
                        Divider(thickness: 1, color: lightGrey),
                    itemCount: profileList.length,
                    itemBuilder: (context, index) => ListTile(
                      leading: Image.asset(profileIc[index], width: 20),
                      title: profileList[index].text
                          .fontFamily(regular)
                          .color(darkFontGrey)
                          .make(),
                    ),
                  ).box.white.rounded
                  .padding(const EdgeInsets.symmetric(horizontal: 15))
                  .shadowSm
                  .margin(const EdgeInsets.all(12))
                  .make()
                  .box
                  .color(redColor)
                  .make(),
            ],
          ),
        ),
      ),
    );
  }
}
