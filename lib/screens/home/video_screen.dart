import 'package:chewie/chewie.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:ratezilla_user/global/appbar.dart';
import 'package:ratezilla_user/model/post.dart';
import 'package:ratezilla_user/screens/more/videoplayerscreen.dart';
import 'package:ratezilla_user/services/firebase_auth_methods.dart';
import 'package:ratezilla_user/services/firebase_crud.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';

final ScrollController scrollController = ScrollController();

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
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
      body: StreamBuilder<List<PostModel>>(
        stream: FirestoreHelper.readPost(dburl: "Video_posts"),
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
            return ListView.builder(
              controller: scrollController,
              shrinkWrap: true,
              itemCount: userData!.length,
              itemBuilder: (context, index) {
                final singleUser = userData[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      height: 40.0,
                                      width: 40,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          singleUser.profilepic!.isEmpty
                                              ? ""
                                              : singleUser.profilepic
                                                  .toString(),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    SizedBox(
                                      height: 25.0,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          singleUser.username!.isEmpty
                                              ? ""
                                              : singleUser.username.toString(),
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: 260.0,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      // color: Colors.blueGrey,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                          singleUser.thumbnail!.isEmpty
                                              ? ""
                                              : singleUser.thumbnail.toString(),
                                          fit: BoxFit.cover, frameBuilder:
                                              (context, child, frame,
                                                  wasSynchronouslyLoaded) {
                                        return child;
                                      }, loadingBuilder: (context, child,
                                              loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      }),
                                    ),
                                  ),
                                  Container(
                                    height: 260.0,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Colors.black26,
                                    ),
                                  ),
                                  Container(
                                    height: 80.0,
                                    width: 80.0,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(150.0),
                                      color: Color.fromARGB(255, 194, 227, 255),
                                    ),
                                    child: Center(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return VideoPlayerScreen(
                                              playerrul:
                                                  singleUser.postUrl!.isEmpty
                                                      ? ''
                                                      : singleUser.postUrl
                                                          .toString(),
                                            );
                                          }));
                                        },
                                        child: Icon(
                                          Icons.play_arrow_rounded,
                                          size: 48.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              //

                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 6.0),
                                child: Container(
                                  height: 25.0,
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                         var likes = singleUser.liked;
                                                likes.toString().contains(
                                                        singleUser.uid!)
                                                    ? FirestoreHelper()
                                                        .removeFromArray(
                                                            "Video_posts",
                                                            singleUser.postid!,
                                                            singleUser.uid,
                                                            singleUser
                                                                .username!)
                                                    : FirestoreHelper()
                                                        .appendToArray(
                                                            "Video_posts",
                                                            singleUser.postid!,
                                                            singleUser.uid,
                                                            singleUser
                                                                .username!);
                                                setState(() {});
                                                // likepost.contains(uid)
                                                //     ? FirestoreHelper().removeFromArray(
                                                //         "Image_posts", postid, uid, username)
                                                //     : FirestoreHelper().appendToArray(
                                                //         "Image_posts", postid, uid, username);
                                              },
                                        child: Icon(
                                          Icons.thumb_up_alt_outlined,
                                          size: 28.0,
                                        ),
                                      ),
                                      SizedBox(width: 12.0),
                                      Text(singleUser.liked!.length.toString() +
                                          " Like"),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        singleUser.username!.isEmpty
                                            ? ""
                                            : singleUser.username.toString() +
                                                " ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17),
                                      ),
                                      Expanded(
                                        child: Text(
                                          singleUser.postdesc!.isEmpty
                                              ? ""
                                              : singleUser.postdesc.toString(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 4.0, 0.0, 2.0),
                                child: Container(
                                  height: 25.0,
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    children: [
                                      Text(
                                        singleUser.uploaddate!.isEmpty
                                            ? ""
                                            : singleUser.uploaddate.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
