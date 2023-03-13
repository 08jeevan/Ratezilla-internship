import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ratezilla_user/global/appbar.dart';
import 'package:ratezilla_user/model/post.dart';
import 'package:ratezilla_user/screens/player/audioplayer.dart';
import 'package:ratezilla_user/services/firebase_auth_methods.dart';
import 'package:ratezilla_user/services/firebase_crud.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ScrollController scrollController = ScrollController();

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  late SharedPreferences prefs;
  String name = " ";
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieve();
  }

  // Ads

  retrieve() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('username')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;
    bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: ScrollAppBar(
        controller: scrollController,
        toolbarHeight: 100,
        backgroundColor: isDarkModeOn == false
            ? Color.fromRGBO(255, 255, 255, 1)
            : const Color(0xff303030),
        elevation: 0.0,
        automaticallyImplyLeading: false,
        flexibleSpace: scrollAppBar(context, user.uid),
      ),
      body: StreamBuilder<List<PostModel>>(
        stream: FirestoreHelper.readPost(dburl: "Audio_posts"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("some error occured"),
            );
          }
          if (snapshot.hasData) {
            final userData = snapshot.data;
            return GridView.builder(
                controller: scrollController,
                padding: EdgeInsets.all(12.0),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 2 / 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: userData!.length,
                itemBuilder: (BuildContext ctx, index) {
                  final singleUser = userData[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        // return AudioPalyerScreen();
                        return PlayerScreen(
                          documentId: singleUser.postid!,
                          audiourl: singleUser.postUrl!,
                          imgurl: singleUser.thumbnail!.isEmpty
                              ? ""
                              : singleUser.thumbnail!.toString(),
                          postid: singleUser.postid.toString(),
                          uid: singleUser.uid.toString(),
                          username: singleUser.username.toString(),
                          likepost: singleUser.liked!,
                        );
                      }));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              child: singleUser.thumbnail!.isEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Image.asset(
                                        "assets/images/bgthumb.png",
                                        height:
                                            MediaQuery.of(context).size.height,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Image.network(
                                        singleUser.thumbnail!.toString(),
                                        height:
                                            MediaQuery.of(context).size.height,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          singleUser.postdesc!.isEmpty
                              ? Container()
                              : Text(singleUser.postdesc!)
                        ],
                      ),
                    ),
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
