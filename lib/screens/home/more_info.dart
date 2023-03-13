import 'dart:io';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ratezilla_user/backend/slider.dart';
import 'package:ratezilla_user/global/navbar.dart';
import 'package:ratezilla_user/global/sharedpref.dart';
import 'package:ratezilla_user/model/userinfo.dart';
import 'package:ratezilla_user/screens/home/video_screen.dart';
import 'package:ratezilla_user/services/firebase_auth_methods.dart';
import 'package:ratezilla_user/services/firebase_crud.dart';
import 'package:ratezilla_user/utils/alertbox.dart';
import 'package:ratezilla_user/utils/bottomsheet.dart';
import 'package:ratezilla_user/utils/buttons.dart';
import 'package:ratezilla_user/utils/fonts.dart';
import 'package:ratezilla_user/utils/global.dart';
import 'package:ratezilla_user/utils/textform.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class MoreUserInfo extends StatefulWidget {
  const MoreUserInfo({super.key});

  @override
  State<MoreUserInfo> createState() => _MoreUserInfoState();
}

class _MoreUserInfoState extends State<MoreUserInfo> {
  var uuid = const Uuid();
  final TextEditingController usernameController = TextEditingController();
  final List<String> items = ['Male', 'Female'];
  String? selectedValue;
  String imgurl = "";
  bool isuploading = false;
  late SharedPreferences prefs;
  String newuser = "";
  String avatarimg = '';

  File? imageFile;
  String? imageUrl;

  popupdialogue(
      {required VoidCallback ontapavatar, required VoidCallback ontapgallery}) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Select from"),
        content: Column(
          children: [
            TextButton(
              onPressed: ontapavatar,
              child: const Text("Avatar"),
            ),
            TextButton(
              onPressed: ontapgallery,
              child: const Text("Gallery"),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Container(
              color: Colors.green,
              padding: const EdgeInsets.all(14),
              child: const Text("okay"),
            ),
          ),
        ],
      ),
    );
  }

  popupdialoguewithavatars() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Select Avatar"),
        content: GridView(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 2 / 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          children: [
            Container(
                child: InkWell(
                    onTap: () {
                      setState(() {
                        avatarimg = "assets/images/Avtaar8.png";
                      });
                      Navigator.of(ctx).pop();
                    },
                    child: Image.asset("assets/images/Avtaar8.png"))),
            Container(child: Image.asset("assets/images/Avtaar6.png")),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Container(
              color: Colors.green,
              padding: const EdgeInsets.all(14),
              child: const Text("okay"),
            ),
          ),
        ],
      ),
    );
  }

  save() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('username', usernameController.text.toString());
  }

  storeOnboardInfo() async {
    print("Shared pref called");
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
    print(prefs.getInt('onBoard'));
  }

  imageFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      //  maxHeight: 200, maxWidth: 200);
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  Future uploadimg(String userid) async {
    var uuid = const Uuid();
    showMyDialog(context, "Hold on... Creating account");
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref =
        storage.ref().child("userprofile").child(userid).child(uuid.v1());
    await ref.putFile(File(imageFile!.path));
    String imageUrl = await ref.getDownloadURL();
    setState(() {
      imgurl = imageUrl;
    });
    print(imageUrl.toString());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100.0,
              ),
              const Text(
                "Almost there!!",
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              if (imageFile == null && avatarimg.isEmpty)
                Align(
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 100.0,
                        width: 100.0,
                      ),
                      Positioned(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey[350],
                          ),
                          height: 80.0,
                          width: 80.0,
                        ),
                      ),
                      Positioned(
                        bottom: 1.0,
                        right: 1.0,
                        child: InkWell(
                          onTap: () {
                            imageFromGallery();
                            // popupdialogue(
                            //   ontapavatar: () {
                            //     popupdialoguewithavatars();
                            //   },
                            //   ontapgallery: () {
                            //     imageFromGallery();
                            //   },
                            // );
                          },
                          child: Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: Colors.deepPurple,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else if (imageFile != null)
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 100.0,
                    width: 100.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(
                        imageFile!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              else if (avatarimg.isNotEmpty)
                Align(
                  alignment: Alignment.center,
                  child: Card(
                    child: Container(
                      height: 100.0,
                      width: 100.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          "assets/images/Avtaar8.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(
                height: 25.0,
              ),
              const Text(
                "What should we call you",
                style: kmediumfont,
              ),
              const SizedBox(
                height: 15.0,
              ),
              kbasictextform(
                controller: usernameController,
                hinttext: "Enter your name",
                onChanged: (text) {
                  value = text;
                },
              ),
              SizedBox(
                height: 25.0,
              ),
              const Text(
                "Select your gender",
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Card(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      hint: Text('Select option'),
                      items: items
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                ),
                              ))
                          .toList(),
                      value: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value as String;
                        });
                      },
                      buttonHeight: 40,
                      buttonWidth: 140,
                      itemHeight: 40,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              kbasicbutton(context, () {
                save();
                setState(() {
                  isuploading = true;
                });
                if (usernameController.text.isEmpty) {
                  print("null...............................");
                } else {
                  uploadimg(user.uid.toString()).whenComplete(() => {
                        FirestoreHelper.create(
                          UserModel(
                            userfullname: usernameController.text.toString(),
                            uid: user.uid.toString(),
                            profilepic: imgurl.isEmpty ? avatarimg.toString() : imgurl.toString(),
                            gender: selectedValue.toString(),
                            followers: [],
                            following: [],
                          ),
                        ).whenComplete(() => {
                              // Navigator.pushNamedAndRemoveUntil(context, MaterialPageRoute, (route) => false)
                              Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(builder: (context) {
                                return MyNavBar();
                              }), (route) => false)
                            }),
                      });

                  SharedPref.setString("username");
                  storeOnboardInfo();
                }
              }, Text("Continue"))
            ],
          ),
        ),
      ),
    );
  }
}
