import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? gender;
  final String? userfullname;
  final String? uid;
  final String? profilepic;
  final List? followers;
  final List? following;

  UserModel({
    required this.userfullname,
    required this.gender,
    required this.uid,
    required this.profilepic,
    required this.followers,
    required this.following,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      userfullname: snapshot['userfullname'],
      profilepic: snapshot['profilepic'],
      gender: snapshot['gender'],
      uid: snapshot['uid'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }

  Map<String, dynamic> toJson() => {
        "userfullname": userfullname,
        "gender": gender,
        "profilepic": profilepic,
        "id": uid,
        "followers": followers,
        "following": following
      };
}
