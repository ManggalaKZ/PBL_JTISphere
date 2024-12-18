import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';

Future showCustomDialog({
  required String title,
  required List<Widget> children,
}) async {
  await showDialog<void>(
    barrierColor: Color.fromARGB(145, 0, 0, 0),
    context: globalContext,
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: EdgeInsets.fromLTRB(24, 24, 24, 5),
        contentPadding:
            EdgeInsets.fromLTRB(24, 0, 24, 5), // Remove default content padding
        actionsAlignment: MainAxisAlignment.end,

        title: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(color: Colors.black),
          ),
        ),
        content: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListBody(
              children: <Widget>[
                ...children,
              ],
            ),
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Ok',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
