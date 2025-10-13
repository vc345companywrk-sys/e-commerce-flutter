import 'package:ecommerce_app/consts/consts.dart';

Widget textFieldAuth({
  String? titleCommon,
  String? hintCommon,
  controller,
  obsSecure,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      titleCommon!.text.color(redColor).fontFamily(semibold).size(16).make(),
      5.heightBox,
      TextFormField(
        obscureText: obsSecure,
        controller: controller,
        decoration: InputDecoration(
          hintStyle: TextStyle(fontFamily: semibold, color: fontGrey),
          hintText: hintCommon,
          isDense: true, //it help to make small
          fillColor: lightGrey,
          filled: true,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: redColor),
          ),
        ),
      ),
    ],
  );
}
