import 'package:ecommerce_app/consts/consts.dart';

Widget appLogoWidgets(double width, double height) {
  return Image.asset(icAppLogo).box.white
      .size(width, height)
      .padding(EdgeInsetsGeometry.all(8))
      .rounded
      .make();
}
