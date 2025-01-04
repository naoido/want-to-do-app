import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showNormalDialog(BuildContext context, String text, String message, VoidCallback callback) {
  showDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(text),
        content: Text(message),
        actions: [
          CupertinoDialogAction(child: const Text('いいえ'), onPressed: () {
            Navigator.pop(context);
          }),
          CupertinoDialogAction(onPressed: callback, child: const Text('はい'))
        ],
      );
    });
}