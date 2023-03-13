import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String username;
  final String userimg;

  Post({
    required this.username,
    required this.userimg,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "userimg": userimg,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      username: snapshot['username'],
      userimg: snapshot['userimg'],
      );
  }
}
