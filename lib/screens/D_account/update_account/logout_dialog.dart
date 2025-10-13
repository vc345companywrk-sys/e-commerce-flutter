import 'package:ecommerce_app/consts/consts.dart';

//import 'package:flutter/material.dart';

Future<void> showAppDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmText = "OK",
  VoidCallback? onConfirm,
}) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: lightGrey,
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(ctx);
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(ctx); // close dialog
            if (onConfirm != null) onConfirm(); // run confirm action
          },
          child: Text(confirmText),
        ),
      ],
    ),
  );
}
