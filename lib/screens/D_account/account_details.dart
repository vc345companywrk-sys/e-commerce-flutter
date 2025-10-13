import 'package:ecommerce_app/consts/consts.dart';

Widget accountDetails({width, String? count, String? title}) {
  return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          count!.text.fontFamily(semibold).size(14).color(darkFontGrey).make(),
          2.heightBox,
          title!.text.fontFamily(regular).size(10).make(),
        ],
      ).box.white.rounded
      .width(width)
      .padding(const EdgeInsets.all(5))
      .margin(const EdgeInsets.all(2))
      .height(60)
      .make();
}
