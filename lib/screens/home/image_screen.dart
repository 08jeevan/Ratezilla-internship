import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:hidable/hidable.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:ratezilla_user/global/appbar.dart';
import 'package:ratezilla_user/model/post.dart';
import 'package:ratezilla_user/screens/upload/add_post_screen.dart';
import 'package:ratezilla_user/screens/upload/add_video_screen.dart';
import 'package:ratezilla_user/screens/userinfo/usermoreinfo.dart';
import 'package:ratezilla_user/services/firebase_auth_methods.dart';
import 'package:ratezilla_user/services/firebase_crud.dart';
import 'package:provider/provider.dart';
import 'package:ratezilla_user/utils/colors.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../utils/likeanimation.dart';
import '../others/imagezoom.dart';

final ScrollController scrollController = ScrollController();

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  late SharedPreferences prefs;
  late String likev = "0";
  bool contains = false;
  String name = " ";
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieve();
  }

  // Ads

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('Image_posts').snapshots();

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

    DateTime now = DateTime.now();
    var timeNow = int.parse(DateFormat('kk').format(now));
    var greetingmessage = '';
    if (timeNow <= 12) {
      greetingmessage = 'Good Morning! ';
    } else if ((timeNow > 12) && (timeNow <= 16)) {
      greetingmessage = 'Good Afternoon! ';
    } else {
      greetingmessage = 'Good Evening! ';
    }

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
        stream: FirestoreHelper.readPost(dburl: "Image_posts"),
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
                return Column(
                  children: [
                    index == 0
                        ? Padding(
                            padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 22.0),
                            child: Row(
                              children: [
                                Text(
                                  greetingmessage.toString(),
                                  style: const TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  name.isEmpty == true
                                      ? "no data"
                                      : name.toString(),
                                  style: const TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(
                            height: 0.0,
                          ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Card(
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {},
                                        child: Container(
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
                                      ),
                                      const SizedBox(width: 10.0),
                                      SizedBox(
                                        height: 25.0,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            singleUser.username!.isEmpty
                                                ? ""
                                                : singleUser.username
                                                    .toString(),
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ImageZoom(
                                        imgUrl: singleUser.postUrl!.toString(),
                                      );
                                    }));
                                  },
                                  child: Hero(
                                    tag: 'fullscreen',
                                    child: Container(
                                      // height: 320.0,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        // color: Colors.blueGrey,
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                            singleUser.postUrl!.isEmpty
                                                ? ""
                                                : singleUser.postUrl.toString(),
                                            fit: BoxFit.cover, frameBuilder:
                                                (context, child, frame,
                                                    wasSynchronouslyLoaded) {
                                          return child;
                                        }, loadingBuilder: (context, child,
                                                loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return const Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(12.0),
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          }
                                        }),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6.0),
                                  child: Container(
                                    height: 25.0,
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      children: [
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                var likes = singleUser.liked;
                                                likes.toString().contains(
                                                        singleUser.uid!)
                                                    ? FirestoreHelper()
                                                        .removeFromArray(
                                                            "Image_posts",
                                                            singleUser.postid!,
                                                            singleUser.uid,
                                                            singleUser
                                                                .username!)
                                                    : FirestoreHelper()
                                                        .appendToArray(
                                                            "Image_posts",
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
                                              child: singleUser.liked!.contains(
                                                      (singleUser.uid))
                                                  ? const Icon(
                                                      Icons
                                                          .thumb_up_alt_rounded,
                                                      size: 28.0,
                                                    )
                                                  : const Icon(
                                                      Icons
                                                          .thumb_up_alt_outlined,
                                                      size: 28.0,
                                                    ),
                                            ),
                                            SizedBox(width: 12.0),
                                            Text(singleUser.liked!.length
                                                    .toString() +
                                                " Like"),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                singleUser.postdesc!.isEmpty
                                    ? Container()
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Row(
                                            children: [
                                              Container(
                                                child: Text(
                                                  singleUser.username!.isEmpty
                                                      ? ""
                                                      : singleUser.username!
                                                          .toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 17,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8.0),
                                              Expanded(
                                                child: Text(
                                                  singleUser.postdesc!.isEmpty
                                                      ? ""
                                                      : singleUser.postdesc!
                                                          .toString(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 4.0, 0.0, 2.0),
                                  child: SizedBox(
                                    height: 25.0,
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      children: [
                                        Text(
                                          singleUser.uploaddate!.isEmpty
                                              ? ""
                                              : singleUser.uploaddate!
                                                  .toString(),
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
                  ],
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

listbuilding({
  required context,
  required String img,
  required String uid,
  required VoidCallback onTap,
  required String profilepic,
  required String postdesc,
  required String username,
  required String uploaddate,
  required String postid,
  required List likepost,
  required VoidCallback likes,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Card(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: onTap,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      height: 40.0,
                      width: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          profilepic.isEmpty ? "" : profilepic.toString(),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  SizedBox(
                    height: 25.0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        username.isEmpty ? "" : username.toString(),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ImageZoom(
                    imgUrl: img,
                  );
                }));
              },
              child: Hero(
                tag: 'fullscreen',
                child: Container(
                  // height: 320.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    // color: Colors.blueGrey,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(img.isEmpty ? "" : img,
                        fit: BoxFit.cover, frameBuilder:
                            (context, child, frame, wasSynchronouslyLoaded) {
                      return child;
                    }, loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    }),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Container(
                height: 25.0,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            var likes = likepost;
                            print("likes is: " + likes.toString());
                            likes.forEach((like) {
                              likes.toString().contains(uid)
                                  ? FirestoreHelper().removeFromArray(
                                      "Image_posts", postid, uid, username)
                                  : FirestoreHelper().appendToArray(
                                      "Image_posts", postid, uid, username);
                            });
                            // likepost.contains(uid)
                            //     ? FirestoreHelper().removeFromArray(
                            //         "Image_posts", postid, uid, username)
                            //     : FirestoreHelper().appendToArray(
                            //         "Image_posts", postid, uid, username);
                          },
                          child: likepost.contains((uid))
                              ? const Icon(
                                  Icons.thumb_up_alt_rounded,
                                  size: 28.0,
                                )
                              : const Icon(
                                  Icons.thumb_up_alt_outlined,
                                  size: 28.0,
                                ),
                        ),
                        SizedBox(width: 12.0),
                        Text(likepost.length.toString() + " Like"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            postdesc.isEmpty
                ? Container()
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              username.isEmpty ? "" : username.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              postdesc.isEmpty ? "" : postdesc.toString(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 2.0),
              child: SizedBox(
                height: 25.0,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Text(
                      uploaddate.isEmpty ? "" : uploaddate.toString(),
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
  );
}

ratetilebutton({required String number, required VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 223, 223, 223),
        shape: BoxShape.circle,
      ),
      child: Text(number),
    ),
  );
}
