

import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String? postUrl;
  final String? uid;
  final String? profilepic;
  final String? username;
  final String? postdesc;
  final String? postid;
  final String? thumbnail;
  final String? uploaddate;
  final String? isaccepted;
  final List? liked;
  

  PostModel({
    required this.postUrl,
    required this.uid,
    required this.profilepic,
    required this.username,
    required this.postid,
    required this.thumbnail,
    required this.postdesc,
    required this.uploaddate,
    required this.liked,
    required this.isaccepted,
  });

  factory PostModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return PostModel(
      postUrl: snapshot['postUrl'],
      postdesc:  snapshot['postdesc'],
      uid: snapshot['uid'],
      thumbnail : snapshot['thumbnail'],
      uploaddate : snapshot['uploaddate'],
      username: snapshot['username'],
      profilepic: snapshot['profilepic'],
      postid: snapshot['postid'],
      isaccepted: snapshot['isaccepted'],
      liked: snapshot['liked'],
    );
  }

  Map<String, dynamic> toJson() => {
        "postUrl": postUrl,
        "uid": uid,
        "thumbnail" : thumbnail,
        "profilepic" : profilepic,
        "postdesc": postdesc,
        "liked" : liked,
        "postid" : postid,
        "uploaddate" : uploaddate,
        "username": username,
        "isaccepted" : isaccepted,
      };
}
