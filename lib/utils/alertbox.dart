import 'package:flutter/material.dart';

Future<void> showMyDialog(context, String label) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children:  <Widget>[
             Container(
              height: 60.0,
              width: 60.0,
              child: Center(child:  CircularProgressIndicator())),
              Text(label),
            ],
          ),
        ),
      );
    },
  );
}

