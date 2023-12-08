import 'package:flutter/material.dart';
import 'package:login_app3/screen/homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> clearSharedPreferences(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => HomeScreen()),
  );
}

Future<bool> showConfirmationDialog(BuildContext context) async {
  bool confirmed = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'تأیید',
          textAlign: TextAlign.right,
        ),
        content: Text(
          'آیا از تصمیم خود برای خروج از سامانه مطمئن هستید؟',
          textAlign: TextAlign.right,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(
              'خیر',
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('بله'),
          ),
        ],
      );
    },
  );

  return confirmed == true;
}
