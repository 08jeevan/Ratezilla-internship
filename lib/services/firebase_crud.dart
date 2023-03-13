import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:ratezilla_user/model/post.dart';
import 'package:ratezilla_user/model/userinfo.dart';
import 'package:uuid/uuid.dart';

String tdata = DateFormat("HH:mm:ss").format(DateTime.now());
String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());

class FirestoreHelper {
  Future<void> appendToArray(String dbid, String docid, dynamic uid, String username) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    _firestore.collection(dbid).doc(docid).update({
      'liked': FieldValue.arrayUnion([
        {"uid": uid, "username": username},
      ]),
    }).whenComplete(() => print("added"));
  }

  Future<void> removeFromArray(
      String dbid, String docid, dynamic uid, String username) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    _firestore.collection(dbid).doc(docid).update({
      'liked': FieldValue.arrayRemove([
        {"uid": uid, "username": username},
      ]),
    }).whenComplete(() => print("removed"));
  }

  Future<void> likeImage(String postId, String uid, List liked) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      if (liked.contains(uid)) {
        print("UnLiked now");
        await _firestore.collection('Image_posts').doc(postId).update({
          'liked': FieldValue.arrayRemove([uid])
        });
      } else {
        print("Liked now");
        await _firestore.collection('Image_posts').doc(postId).update({
          'liked': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  static Stream<List<UserModel>> read() {
    final userCollection = FirebaseFirestore.instance.collection("users");
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  static Stream<List<PostModel>> readPost({required String dburl}) {
    final userCollection = FirebaseFirestore.instance
        .collection(dburl)
        .where('isaccepted', isEqualTo: 'true');
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList());
  }
//posts for myuploaded post 
  static Stream<List<PostModel>> myUploadedPost({required String dburl, uid}) {
    final userCollection = FirebaseFirestore.instance
        .collection(dburl).where('uid', isEqualTo: uid);
        
        // .where('isaccepted', isEqualTo: 'true');
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList());
  }

  // ADDING USER DATA TO FIRESTORE
  static Future create(UserModel user) async {
    final userCollection =
        FirebaseFirestore.instance.collection("users").doc(user.uid);

    final newUser = UserModel(
      uid: user.uid,
      userfullname: user.userfullname,
      gender: user.gender,
      profilepic: user.profilepic,
      followers: user.followers,
      following: user.following,
    ).toJson();

    try {
      await userCollection.set(newUser);
    } catch (e) {
      // ignore: avoid_print
      print("some error occured $e");
    }
  }

  // ADDING POST WITH DESC TO DB AND RETRIVIG DETAILS
  static Future createPost(
      {required PostModel post, required String dburl}) async {
    // var uuid = Uuid();
    final postCollection = FirebaseFirestore.instance.collection(dburl);

    // String postid = uuid.v1();
    final uid = postCollection.doc(post.postid);
    // final docRef = postCollection.doc();

    final newUser = PostModel(
      uid: post.uid,
      postUrl: post.postUrl,
      profilepic: post.profilepic,
      username: post.username,
      liked: post.liked,
      thumbnail: post.thumbnail,
      postdesc: post.postdesc,
      uploaddate: post.uploaddate,
      postid: post.postid,
      isaccepted: post.isaccepted,
    ).toJson();

    try {
      await uid.set(newUser);
    } catch (e) {
      print("some error occured $e");
    }
  }

  static Future update(UserModel user) async {
    final userCollection = FirebaseFirestore.instance.collection("users");

    final docRef = userCollection.doc(user.uid);

    final newUser = UserModel(
      uid: user.uid,
      profilepic: user.profilepic,
      userfullname: user.userfullname,
      gender: user.gender,
      followers: user.followers,
      following: user.following,
    ).toJson();

    try {
      await docRef.update(newUser);
    } catch (e) {
      print("some error occured $e");
    }
  }

  static Future delete(UserModel user) async {
    final userCollection = FirebaseFirestore.instance.collection("users");

    final docRef = userCollection.doc(user.uid).delete();
  }

  static Future deletePost(docid) async {
    final userCollection = FirebaseFirestore.instance.collection("posts");

    final docRef = userCollection.doc(docid).delete();
  }
}

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Following users

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = snap['following'];
      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {}
  }
}
