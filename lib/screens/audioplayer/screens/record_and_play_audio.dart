import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:ratezilla_user/global/appbar.dart';
import 'package:ratezilla_user/model/post.dart';
import 'package:ratezilla_user/screens/audioplayer/providers/play_audio_provider.dart';
import 'package:ratezilla_user/screens/audioplayer/providers/record_audio_provider.dart';
import 'package:ratezilla_user/screens/upload/add_video_screen.dart';
import 'package:ratezilla_user/services/firebase_auth_methods.dart';
import 'package:ratezilla_user/services/firebase_crud.dart';
import 'package:ratezilla_user/utils/alertbox.dart';
import 'package:ratezilla_user/utils/buttons.dart';
import 'package:ratezilla_user/utils/colors.dart';
import 'package:ratezilla_user/utils/fonts.dart';
import 'package:ratezilla_user/utils/textform.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:uuid/uuid.dart';

String tdata = DateFormat("HH:mm:ss").format(DateTime.now());
String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());

class RecordAndPlayScreen extends StatefulWidget {
  final String uid;
  const RecordAndPlayScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<RecordAndPlayScreen> createState() => _RecordAndPlayScreenState();
}

class _RecordAndPlayScreenState extends State<RecordAndPlayScreen> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  //
//
  var uuid = Uuid();
  String profilepic = "";
  String uname = "";
  int uid = 0;
  bool isLoading = false;
  String postname = "";
  String postdesc = "";
  String imgurl = '';
  String audurl = "";

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
      print("user name: " + uname + "profile URL: " + profilepic);
    });
  }

  final TextEditingController postnameController = TextEditingController();
  final TextEditingController postdescController = TextEditingController();
  File? imageFile;
  String? imageUrl;

  imageFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  Future uploadaudio(String audiourl) async {
    var uuid = const Uuid();
    showMyDialog(context, "Hold on... Uploading post");
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("Posts").child(uuid.v1());
    await ref.putFile(File(audiourl));
    String audioUrl = await ref.getDownloadURL();
    // String imageUrl = await ref.getDownloadURL();
    setState(() {
      audurl = audioUrl;
    });
    print(imageUrl.toString());
  }

  Future uploadthumb(String path) async {
    var uuid = const Uuid();
    showMyDialog(context, "Hold on... Uploading post");
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("Posts").child(uuid.v1());
    await ref.putFile(File(path));
    String imageUrl = await ref.getDownloadURL();
    setState(() {
      imgurl = imageUrl;
    });
    print(imageUrl.toString());
  }

  //

  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;
    bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;
    final _recordProvider = Provider.of<RecordAudioProvider>(context);
    final _playProvider = Provider.of<PlayAudioProvider>(context);

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
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                const SizedBox(height: 20),
                _recordProvider.recordedFilePath.isEmpty
                    ? _recordingSection()
                    : _audioPlayingSection(),
                if (_recordProvider.recordedFilePath.isNotEmpty &&
                    !_playProvider.isSongPlaying)
                  const SizedBox(height: 10),
                if (_recordProvider.recordedFilePath.isNotEmpty &&
                    !_playProvider.isSongPlaying)
                  _resetButton(),
                SizedBox(
                  height: 25.0,
                ),
                Divider(
                  color: Colors.black,
                ),
                SizedBox(
                  height: 25.0,
                ),
                _recordProvider.recordedFilePath.isEmpty
                    ? Container()
                    : Column(
                        children: [
                          Text("More Info"),
                          SizedBox(height: 15.0),
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
                            height: 25.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              imageFile == null
                                  ? ElevatedButton(
                                      onPressed: () {
                                        imageFromGallery();
                                      },
                                      child: Text("Select Thumbnail"),
                                    )
                                  : ElevatedButton(
                                      onPressed: () {},
                                      child: Text("Thumbnail Selected"),
                                    ),
                              SizedBox(width: 8.0),
                              ElevatedButton(
                                onPressed: () {
                                  if (imageFile == null) {
                                    uploadaudio(
                                            _recordProvider.recordedFilePath)
                                        .whenComplete(() => {
                                              print("Upload Complete"),
                                              print(imgurl.toString()),
                                              FirestoreHelper.createPost(
                                                dburl: "Audio_posts",
                                                post: (PostModel(
                                                  postUrl: audurl.toString(),
                                                  uid: user.uid,
                                                  profilepic:
                                                      profilepic.toString(),
                                                  username: uname.toString(),
                                                  isaccepted: "true",
                                                  postdesc: postdescController
                                                      .text
                                                      .toString(),
                                                  liked: [],
                                                  postid: tdata+cdate+uuid.v1(),
                                                  thumbnail: "",
                                                  uploaddate: tdata.toString() +
                                                      " - " +
                                                      cdate1.toString(),
                                                )),
                                              ),
                                            })
                                        .whenComplete(
                                            () => Navigator.pop(context)).whenComplete(
                                            () => Navigator.pop(context)).whenComplete(
                                            () => Navigator.pop(context));
                                  } else {
                                    uploadthumb(imageFile!.path)
                                        .whenComplete(() => uploadaudio(
                                                _recordProvider
                                                    .recordedFilePath)
                                            .whenComplete(() => {
                                                  print("Upload Complete"),
                                                  print(imgurl.toString()),
                                                  FirestoreHelper.createPost(
                                                      dburl: "Audio_posts",
                                                      post: (PostModel(
                                                        postUrl:
                                                            audurl.toString(),
                                                        uid: user.uid,
                                                        profilepic: profilepic
                                                            .toString(),
                                                        isaccepted: "true",
                                                        username:
                                                            uname.toString(),
                                                        postdesc:
                                                            postdescController
                                                                .text
                                                                .toString(),
                                                        liked: [],
                                                        postid: tdata+cdate+uuid.v1(),
                                                        thumbnail:
                                                            imgurl.toString(),
                                                        uploaddate: tdata
                                                                .toString() +
                                                            " - " +
                                                            cdate1.toString(),
                                                      ))),
                                                }))
                                         .whenComplete(
                                            () => Navigator.pop(context)).whenComplete(
                                            () => Navigator.pop(context)).whenComplete(
                                            () => Navigator.pop(context));
                                  }
                                },
                                child: Text("Upload Audio"),
                              ),
                            ],
                          )
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _recordHeading() {
    return const Center(
      child: Text(
        'Record Audio',
        style: kmediumfont,
      ),
    );
  }

  // _playAudioHeading() {
  //   return const Center(
  //     child: Text(
  //       'Play Audio',
  //       style: kmediumfont,
  //     ),
  //   );
  // }

  _recordingSection() {
    final _recordProvider = Provider.of<RecordAudioProvider>(context);
    final _recordProviderWithoutListener =
        Provider.of<RecordAudioProvider>(context, listen: false);

    if (_recordProvider.isRecording) {
      return InkWell(
        onTap: () async => await _recordProviderWithoutListener.stopRecording(),
        child: RippleAnimation(
          repeat: true,
          color: const Color(0xff4BB543),
          minRadius: 40,
          ripplesCount: 6,
          child: _commonIconSection(),
        ),
      );
    }

    return InkWell(
      onTap: () async => await _recordProviderWithoutListener.recordVoice(),
      child: _commonIconSection(),
    );
  }

  _commonIconSection() {
    return Container(
      width: 70,
      height: 70,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xff4BB543),
        borderRadius: BorderRadius.circular(100),
      ),
      child: const Icon(Icons.keyboard_voice_rounded,
          color: Colors.white, size: 30),
    );
  }

  _audioPlayingSection() {
    final _recordProvider = Provider.of<RecordAudioProvider>(context);

    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          // color: Colors.white,
        ),
        child: Row(
          children: [
            _audioControllingSection(_recordProvider.recordedFilePath),
            _audioProgressSection(),
          ],
        ),
      ),
    );
  }

  _audioControllingSection(String songPath) {
    final _playProvider = Provider.of<PlayAudioProvider>(context);
    final _playProviderWithoutListen =
        Provider.of<PlayAudioProvider>(context, listen: false);

    return IconButton(
      onPressed: () async {
        if (songPath.isEmpty) return;

        await _playProviderWithoutListen.playAudio(File(songPath));
      },
      icon: Icon(
          _playProvider.isSongPlaying ? Icons.pause : Icons.play_arrow_rounded),
      color: Colors.blue,
      iconSize: 30,
    );
  }

  _audioProgressSection() {
    final _playProvider = Provider.of<PlayAudioProvider>(context);

    return Expanded(
        child: Container(
      width: double.maxFinite,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: LinearPercentIndicator(
        percent: _playProvider.currLoadingStatus,
        backgroundColor: Colors.black26,
        progressColor: Colors.blue,
      ),
    ));
  }

  _resetButton() {
    final _recordProvider =
        Provider.of<RecordAudioProvider>(context, listen: false);

    return kbasicbutton(context, () {
      _recordProvider.clearOldData();
    }, const Text("Reset"));
  }
}
