import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ratezilla_user/model/post.dart';
import 'package:ratezilla_user/services/firebase_crud.dart';
import 'package:ratezilla_user/utils/fonts.dart';

class AllScreenPost extends StatefulWidget {
  String uid = '';
  AllScreenPost({super.key, required this.uid});

  @override
  _AllScreenPostState createState() => _AllScreenPostState();
}

class _AllScreenPostState extends State<AllScreenPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20.0),
            const Text(
              "Image Posts",
              style: kmediumfont,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 20.0),
            Container(
              height: 200.0,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<List<PostModel>>(
                stream: FirestoreHelper.myUploadedPost(
                    dburl: "Image_posts", uid: widget.uid),
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
                      shrinkWrap: true,
                      itemCount: userData!.length,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, index) {
                        final singleUser = userData[index];
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                height: 180.0,
                                width: 180.0,
                                child: Image.network(
                                  singleUser.postUrl.toString(),
                                  fit: BoxFit.cover,
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
            ),
            SizedBox(height: 20.0),
            const Text(
              "Video Posts",
              style: kmediumfont,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 20.0),
            Container(
              height: 200.0,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<List<PostModel>>(
                stream: FirestoreHelper.myUploadedPost(
                    dburl: "Video_posts", uid: widget.uid),
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
                      shrinkWrap: true,
                      itemCount: userData!.length,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, index) {
                        final singleUser = userData[index];
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                height: 180.0,
                                width: 180.0,
                                child: Image.network(
                                  singleUser.thumbnail.toString(),
                                  fit: BoxFit.cover,
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
            ),
            SizedBox(height: 20.0),
            const Text(
              "Audio Posts",
              style: kmediumfont,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 20.0),
            Container(
              height: 200.0,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<List<PostModel>>(
                stream: FirestoreHelper.myUploadedPost(
                    dburl: "Audio_posts", uid: widget.uid),
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
                      shrinkWrap: true,
                      itemCount: userData!.length,
                     scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, index) {
                        final singleUser = userData[index];
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: singleUser.thumbnail!.isEmpty
                                  ? Container(
                                    height: 180.0,
                                width: 180.0,
                                    child: Image.asset(
                                        "assets/images/bgthumb.png",
                                        height:
                                            MediaQuery.of(context).size.height,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.cover,
                                      ),
                                  ) : Container(
                                height: 180.0,
                                width: 180.0,
                                child: Image.network(
                                  singleUser.postUrl.toString(),
                                  fit: BoxFit.cover,
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
            ),
          ],
        ),
      ),
    );
  }
}
