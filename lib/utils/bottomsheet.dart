import 'package:flutter/material.dart';
import 'package:ratezilla_user/utils/buttons.dart';
import 'package:ratezilla_user/utils/fonts.dart';

bottomshee(context, String label) {
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 26.0, vertical: 30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Hurrahh!!",
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w600,
                    )),
              ),
              SizedBox(height: 24.0),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    child: Image(
                      height: 90.0,
                      width: 90.0,
                      image: AssetImage(
                        'assets/images/Emoji.png',
                      ),
                    ),
                  )),
                  Expanded(
                    child: Container(
                      child: Text(
                        "You’re eligible to redeem your rewards, please click on the button below to redeem your rewards! ",
                        style: kmediumfont,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40.0,
              ),
              kbasicbutton(context, () {}, Text(label)),
            ],
          ),
        );
      });
}

bottomsheetwo(context, String label) {
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 26.0, vertical: 30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Oopss!!",
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w600,
                    )),
              ),
              SizedBox(height: 24.0),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    child: Image(
                      height: 90.0,
                      width: 90.0,
                      image: AssetImage(
                        'assets/images/Emojisad.png',
                      ),
                    ),
                  )),
                  Expanded(
                    child: Container(
                      child: Text(
                        "We are sorry to inform you that you’re not eligible to redeem your rewards, please try again next time! ",
                        style: kmediumfont,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40.0,
              ),
              kbasicbutton(context, () {}, Text(label)),
            ],
          ),
        );
      });
}

