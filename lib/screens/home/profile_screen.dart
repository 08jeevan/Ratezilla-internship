import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:ratezilla_user/global/appbar.dart';
import 'package:ratezilla_user/global/themenotifier.dart';
import 'package:ratezilla_user/global/themes.dart';
import 'package:ratezilla_user/screens/home/splash_scree.dart';
import 'package:ratezilla_user/screens/more/faqscreen.dart';
import 'package:ratezilla_user/screens/more/wallet.dart';
import 'package:ratezilla_user/screens/others/allpostscreen.dart';
import 'package:ratezilla_user/services/firebase_auth_methods.dart';
import 'package:ratezilla_user/services/firebase_crud.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';
// import 'package:theme_manager/theme_manager.dart';

final ScrollController scrollController = ScrollController();

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;
    bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: ScrollAppBar(
        controller: scrollController,
        toolbarHeight: 100,
        backgroundColor:
            isDarkModeOn == false ? Colors.white : const Color(0xff303030),
        elevation: 0.0,
        automaticallyImplyLeading: false,
        flexibleSpace: scrollAppBar(context, user.uid),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: FutureBuilder<DocumentSnapshot>(
          future: users.doc(user.uid).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              return ListView(
                controller: scrollController,
                children: [
                  SizedBox(height: 25.0),
                  Center(
                    child: Container(
                      height: 80.0,
                      width: 80.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: data['profilepic']
                                .toString()
                                .contains("assets/images/")
                            ? Image.asset(
                                data['profilepic'],
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                data['profilepic'],
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 22.0),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 35.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.deepPurple, // background (button) color
                        foregroundColor:
                            Colors.white, // foreground (text) color
                      ),
                      onPressed: () {},
                      child: const Text('Edit Profile'),
                    ),
                  ),
                  SizedBox(height: 22.0),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AllScreenPost(uid: user.uid);
                      }));
                    },
                    child: ListTile(
                      leading: Icon(Iconsax.presention_chart),
                      title: Text("View Posts"),
                      trailing: Icon(Icons.arrow_right),
                    ),
                  ),
                  Divider(
                    endIndent: 20.0,
                    indent: 20.0,
                    color: Colors.grey,
                    height: 0,
                  ),
                  // ListTile(
                  //   leading: Icon(Iconsax.status),
                  //   title: Text("View Status"),
                  //   trailing: Icon(Icons.arrow_right),
                  // ),
                  // Divider(
                  //   endIndent: 20.0,
                  //   indent: 20.0,
                  //   color: Colors.grey,
                  //   height: 0,
                  // ),
                  ListTile(
                    leading: Icon(Iconsax.message_question),
                    title: Text("FAQ"),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return FaqScreen();
                      }));
                    },
                  ),
                  Divider(
                    endIndent: 20.0,
                    indent: 20.0,
                    color: Colors.grey,
                    height: 0,
                  ),
                  ListTile(
                    leading: Icon(Icons.shield_outlined),
                    title: Text("Privacy policy"),
                    trailing: Icon(Icons.arrow_right),
                  ),
                  Divider(
                    endIndent: 20.0,
                    indent: 20.0,
                    color: Colors.grey,
                    height: 0,
                  ),
                  ListTile(
                    leading: Icon(Iconsax.paperclip),
                    title: Text("Terms and Conditions"),
                    trailing: Icon(Icons.arrow_right),
                  ),
                  Divider(
                    endIndent: 20.0,
                    indent: 20.0,
                    color: Colors.grey,
                    height: 0,
                  ),
                  ListTile(
                    leading: Icon(Icons.bug_report_outlined),
                    title: Text("Report Bug"),
                    trailing: Icon(Icons.arrow_right),
                  ),
                  Divider(
                    endIndent: 20.0,
                    indent: 20.0,
                    color: Colors.grey,
                    height: 0,
                  ),
                  ListTile(
                    leading: Icon(Icons.format_paint_outlined),
                    title: Text("Theme"),
                    trailing: EasyDynamicThemeAutoSwitch(),
                  ),
                  Divider(
                    endIndent: 20.0,
                    indent: 20.0,
                    color: Colors.grey,
                    height: 0,
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.exit_to_app_outlined, color: Colors.red),
                    title: Text(
                      "Sign Out",
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      context
                          .read<FirebaseAuthMethods>()
                          .signOut(context)
                          .whenComplete(() => {
                                Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(builder: (context) {
                                  return SplashScreen();
                                }), (route) => false)
                              });
                    },
                  ),
                ],
              );
            }

            return const Center(child: Text("loading"));
          },
        ),
      ),
    );
  }
}
