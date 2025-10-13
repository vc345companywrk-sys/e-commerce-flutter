import 'package:ecommerce_app/consts/consts.dart';

//BACKGROUND FOR AUTHENTICATION SCREENS(LOGIN AND SINGNUP)
Widget bgAuth({Widget? child}) {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(imgBackground),
        fit: BoxFit.fill,
      ),
    ),
    child: child,
  );
}
