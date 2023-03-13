import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ratezilla_user/global/navbar.dart';
import 'package:ratezilla_user/model/post.dart';
import 'package:ratezilla_user/services/firebase_auth_methods.dart';
import 'package:ratezilla_user/services/firebase_crud.dart';
import 'package:ratezilla_user/services/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:ratezilla_user/utils/buttons.dart';
import 'package:ratezilla_user/utils/colors.dart';
import 'package:ratezilla_user/utils/textform.dart';
import 'package:uuid/uuid.dart';

import '../../utils/alertbox.dart';

String tdata = DateFormat("HH:mm:ss").format(DateTime.now());
String cdate = DateFormat("dd:MM:yyyy").format(DateTime.now());

class AddPost extends StatefulWidget {
  final String uid;
  const AddPost({Key? key,required this.uid}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  var uuid = Uuid();
  String profilepic = "";
  String uname = "";
  int uid = 0;
  bool isLoading = false;

  String postname = "";
  String postdesc = "";
  String imgurl = "";

  final TextEditingController postnameController = TextEditingController();
  final TextEditingController postdescController = TextEditingController();

  File? imageFile;
  String? imageUrl;

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
    showMyDialog(context, "Hold on... Uploading post");
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("Posts").child(userid).child(uuid.v1());
    await ref.putFile(File(imageFile!.path));
    String imageUrl = await ref.getDownloadURL();
    setState(() {
      imgurl = imageUrl;
    });
    print(imageUrl.toString());
  }

  final snackBarpost = SnackBar(
    content: Text('Please select an Image'),
  );

  final snackBartitle = SnackBar(
    content: Text('Please enter a post name'),
  );

  //

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      uname = userSnap.data()!['userfullname'];
      profilepic = userSnap.data()!['profilepic'];
    } catch (e) {
      // showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
      print("...............................");
      print("User data");
      print("user name: " + uname + "profile URL: "+ profilepic);
    });
  }

  //

  String tdata = DateFormat("hh:mm:ss a").format(DateTime.now());
 String cdate1 = DateFormat("EEEEE, dd, yyyy").format(DateTime.now());
//
  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;
    bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        backgroundColor: isDarkModeOn == false
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
                      print(uname);
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
                    "Add Post",
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: SizedBox(
            child: Column(
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                imageFile == null
                    ? InkWell(
                        onTap: () {
                          imageFromGallery();
                        },
                        child: Card(
                          child: Container(
                            height: 320.0,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: const Center(
                              child:
                                  Icon(Icons.add_a_photo_outlined, size: 40.0),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 320.0,
                        width: MediaQuery.of(context).size.width,
                        child: Image.file(imageFile!),
                      ),
                const SizedBox(
                  height: 35.0,
                ),
                kbasictextform(
                    controller: postnameController,
                    hinttext: "Enter Post name",
                    onChanged: (text) {
                      postname = text;
                    }),
                const SizedBox(
                  height: 15.0,
                ),
                kbasictextform(
                    controller: postdescController,
                    hinttext: "Enter Post description",
                    onChanged: (text) {
                      postdesc = text;
                    }),
                const SizedBox(
                  height: 35.0,
                ),
                kbasicbutton(
                  context,
                  () {
                    if (imageFile == null) {
                      snackBarpost;
                    } else if (postnameController.text.isEmpty) {
                      snackBartitle;
                    } else {
                      uploadimg(user.uid.toString())
                          .whenComplete(
                            () => {
                              print("Upload Complete"),
                              print(imgurl.toString()),
                              FirestoreHelper.createPost(
                                dburl: "Image_posts",
                                post: (PostModel(
                                postUrl: imgurl.toString(),
                                uid: user.uid,
                                profilepic: profilepic.toString(),
                                username: uname.toString(),
                                postdesc: postdescController.text.toString(),
                                liked: [],
                                postid: tdata+cdate+uuid.v1(),
                                thumbnail: "",
                                uploaddate:tdata.toString()+  " - " + cdate1.toString(),
                                isaccepted: "true",
                              ))),
                            },
                          )
                          .whenComplete(() => {
                                Navigator.pop(context),
                              }).whenComplete(() => {
                                Navigator.pop(context),
                              });
                    }
                  },
                  const Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
