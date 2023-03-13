import 'package:flutter/material.dart';

kbasicbutton(context, VoidCallback onTap, Widget text) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    height: 50.0,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple[400], // background (button) color
        foregroundColor: Colors.white, // foreground (text) color
      ),
      onPressed: onTap,
      child: text,
    ),
  );
}
