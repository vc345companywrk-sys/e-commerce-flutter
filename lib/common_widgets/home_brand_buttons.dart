import 'package:ecommerce_app/consts/consts.dart';

Widget homeBrandButtons({width, height, icon, String? title, onPress}) {
  return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(icon, width: 20),
          title!.text.size(13).fontFamily(semibold).make(),
        ],
      ).box.rounded
      .size(width, height)
      .white
      .shadowSm
      .margin(const EdgeInsets.all(3))
      .make();
}
