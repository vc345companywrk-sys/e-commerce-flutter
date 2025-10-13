import 'package:ecommerce_app/consts/consts.dart';

// Widget buttonAuth({color, onPress, String? title, textColor}) {
//   return ElevatedButton(
//     style: ElevatedButton.styleFrom(
//       backgroundColor: color,
//       padding: EdgeInsets.all(12),
//     ),
//     onPressed: () {
//       onPress;
//     },
//     child: title!.color(textColor).fontFamily(bold).make(),
//   );
// }
Widget buttonAuth({
  required Color color,
  required VoidCallback onPress,
  required String title,
  required Color textColor,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      padding: EdgeInsets.all(12),
    ),
    onPressed: onPress,
    child: title.text.color(textColor).fontFamily(bold).make(), // FIXED
  );
}
