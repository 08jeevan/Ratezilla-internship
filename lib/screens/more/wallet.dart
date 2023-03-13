import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ratezilla_user/global/navbar.dart';
import 'package:ratezilla_user/utils/bottomsheet.dart';
import 'package:ratezilla_user/utils/buttons.dart';
import 'package:ratezilla_user/utils/colors.dart';
import 'package:ratezilla_user/utils/fonts.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // controller: controller,
        toolbarHeight: 120,
        backgroundColor: EasyDynamicTheme.of(context).themeMode == true
            ? Colors.white
            : const Color(0xff303030),
        elevation: 0.0,
        automaticallyImplyLeading: false,
        flexibleSpace: ClipPath(
          clipper: Customshape(),
          child: Container(
            height: 180,
            width: MediaQuery.of(context).size.width,
            color: primaryColor,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 24.0),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Text(
                    "Ratezilla",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 24.0),
                    child: Icon(
                      Icons.arrow_back,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            Color(0xffe16b5c),
                            Color(0xfff39060),
                            Color(0xffffb56b),
                          ],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 16.0),
                                child: Text("RateZilla Rewards",
                                    style: TextStyle(fontSize: 18.0)),
                              ),
                              const SizedBox(height: 26.0),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 4.0),
                                child: Text(
                                  "400 Coins",
                                  style: ksemilargefont,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 2.0),
                                child: Row(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4.0, vertical: 10.0),
                                      child: Text(
                                        "Valid From : ",
                                        style: ksmallfont,
                                      ),
                                    ),
                                    SizedBox(width: 20.0),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4.0, vertical: 10.0),
                                      child: Text(
                                        "Valid To : ",
                                        style: ksmallfont,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Image(
                            image: AssetImage(
                              "assets/images/coins.png",
                            ),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 25.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: kbasicbutton(
                    context,
                    () {
                      bottomshee(context, "Redeem Now");
                    },
                    Text("Redeem your rewards"),
                  ),
                ),
                SizedBox(height: 15.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: kbasicbutton(
                    context,
                    () {
                      bottomsheetwo(context, "Close");
                    },
                    Text("Redeem your rewards"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
