import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ratezilla_user/services/firebase_auth_methods.dart';
import 'package:ratezilla_user/utils/buttons.dart';
import 'package:ratezilla_user/utils/fonts.dart';
import 'package:ratezilla_user/utils/global.dart';
import 'package:ratezilla_user/utils/textform.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String phonenovalue = "";
  //
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue[100],
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: kpaddingsymentric14,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      "Rate",
                      style: ksmallintroboldfont,
                    ),
                    Text(
                      "zilla",
                      style: ksmallintrothinfont,
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Container(
                padding: kglobalpadding,
                decoration: const BoxDecoration(
                  borderRadius: kcircularborder16,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: kpaddingsymentric6,
                      child: Text(
                        "Login with mobile number",
                        style: kmediumfont,
                      ),
                    ),
                    const SizedBox(height: 22.0),
                    const Text(
                      "Enter your mobile number",
                      style: ksmallfont,
                    ),
                    const SizedBox(height: 6.0),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Text(
                              "+91",
                              style: kmediumfont,
                            ),
                            alignment: Alignment.center,
                          ),
                        ),
                        const SizedBox(width: 6.0),
                        Expanded(
                          flex: 5,
                          child: kbasictextform(
                           controller:  phoneController,
                           hinttext:  "Enter Phone number",
                           onChanged: (text){
                            phonenovalue = text;
                           }
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22.0),
                    kbasicbutton(
                      context,
                      () {
                        context
                            .read<FirebaseAuthMethods>()
                            .phoneSignIn(context, phoneController.text);
                      },
                      const Text("Get OTP"),
                    ),
                  ],
                ),
              ),
            )
            //
            //
            //

            // ),
          ],
        ),
      ),
    );
  }
}

// CustomButton(
//                 onTap: () {
//                   Navigator.pushNamed(context, PhoneScreen.routeName);
//                 },
//                 text: 'Phone Sign In'),
