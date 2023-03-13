import 'package:flutter/material.dart';

String value = "";

kbasictextform(
    {required TextEditingController controller,
    required String hinttext,
    required Function onChanged}) {
  return TextField(
    controller: controller,
    // keyboardType: TextInputType.number,
    decoration: InputDecoration(
      hintText: hinttext,
    ),
  );
}
