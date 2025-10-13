import 'package:ecommerce_app/consts/consts.dart';

Widget buildActionTile(IconData icon, String title, VoidCallback onTap) {
  return ListTile(
    leading: Icon(icon, color: redColor),
    title: title.text.color(darkFontGrey).make(),
    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: darkFontGrey),
    onTap: onTap,
  );
}
