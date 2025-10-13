import 'package:ecommerce_app/consts/consts.dart';

Widget buildInfoTile(String title, String value, {Color? valueColor}) {
  return ListTile(
    title: title.text.color(darkFontGrey).make(),
    trailing: value.text
        .color(valueColor ?? darkFontGrey)
        .fontFamily(semibold)
        .make(),
  );
}
