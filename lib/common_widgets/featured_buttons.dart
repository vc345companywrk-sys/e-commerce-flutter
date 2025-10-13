import 'package:ecommerce_app/consts/consts.dart';

Widget featuredButtons({String? title, icon}) {
  return Row(
    children: [
      Image.asset(icon, width: 50),
      10.widthBox,
      title!.text.fontFamily(semibold).color(darkFontGrey).make(),
    ],
  ).box.margin(EdgeInsetsGeometry.all(4)).width(180).white.outerShadowSm.make();
}
