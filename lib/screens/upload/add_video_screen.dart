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
import 'package:ratezilla_user/utils/alertbox.dart';
import 'package:ratezilla_user/utils/buttons.dart';
import 'package:ratezilla_user/utils/colors.dart';
import 'package:ratezilla_user/utils/textform.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

String tdata = DateFormat("HH:mm:ss").format(DateTime.now());
String cdate = DateFormat("dd-MM-yyyy").format(DateTime.now());
String cdate1 = DateFormat("EEEEE, dd, yyyy").format(DateTime.now());

enum MediaType {
  image,
  video;
}

class AddVideo extends StatefulWidget {
  final String uid;
  const AddVideo({Key? key,required this.uid}) : super(key: key);

  @override
  State<AddVideo> createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {
  String postname = "";
  String postdesc = "";
  String imgurl = "";
  String thumburl = "";
  var uuid = Uuid();

  
  String profilepic = "";
  String uname = "";
  int uid = 0;
  bool isLoading = false;

  //

  final TextEditingController postnameController = TextEditingController();
  final TextEditingController postdescController = TextEditingController();

  File? imageFile;
  String? imageUrl;
  String? imagePath;
  File? uint8list;

  void pickMedia(ImageSource source) async {
    XFile? file;
    if (_mediaType == MediaType.image) {
      file = await ImagePicker().pickImage(source: source);
    } else {
      file = await ImagePicker().pickVideo(source: source);
    }
    if (file != null) {
      imageUrl = file.path;
      if (_mediaType == MediaType.video) {
        imagePath = await VideoThumbnail.thumbnailFile(
            video: file.path,
            imageFormat: ImageFormat.PNG,
            quality: 100,
            maxWidth: 300,
            maxHeight: 300);
      }
      setState(() {});
    }
  }

  MediaType _mediaType = MediaType.video;

  Future uploadimg(String userid) async {
    var uuid = const Uuid();
    FirebaseStorage storage = FirebaseStorage.instance;
    showMyDialog(context, "Hold on... Uploading video");
    Reference ref1 =
        storage.ref().child("posts").child(userid).child(uuid.v1());
    Reference ref2 =
        storage.ref().child("posts").child(userid).child(uuid.v1());
    await ref1.putFile(File(imageUrl!));
    await ref2.putFile(File(imagePath!));
    String imageUrl1 = await ref1.getDownloadURL();
    String imageUrl2 = await ref2.getDownloadURL();
    setState(() {
      imgurl = imageUrl1;
      thumburl = imageUrl2;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
      print("...........uid is...........");
      print(widget.uid);
      print("...........uid is...........");
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
  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;

    bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        backgroundColor:
            isDarkModeOn == false ? Colors.white : const Color(0xff303030),
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
                (imagePath == null)
                    ? InkWell(
                        onTap: () {
                          // imageFromGallery();
                          pickMedia(ImageSource.gallery);
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
                        child: Image.file(File(imagePath!))),
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
                    uploadimg(user.uid.toString()).whenComplete(
                      () => {
                        print("Upload Complete"),
                        print(imgurl.toString()),
                        print(thumburl.toString()),
                        FirestoreHelper.createPost(
                                dburl: "Video_posts",
                                post: (PostModel(
                                postUrl: imgurl.toString(),
                                uid: user.uid,
                                profilepic: profilepic.toString(),
                                username: uname.toString(),
                                postdesc: postdescController.text.toString(),
                                liked: [],
                                postid: tdata+cdate+uuid.v1(),
                                thumbnail: thumburl.toString(),
                                uploaddate:tdata.toString()+  " - " + cdate1.toString(),
                                isaccepted: "true",
                              ))
                        ).whenComplete(() {
                          Navigator.pop(context);
                        }).whenComplete(() => {
                                Navigator.pop(context),
                              }),
                      },
                    );
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
