import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ratezilla_user/services/firebase_auth_methods.dart';
import 'package:provider/provider.dart';
import 'package:ratezilla_user/services/firebase_crud.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
         SizedBox(height: 25.0),
            Center(
              child: Container(
                height: 60.0,
                width: 60.0,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 25.0),
            Row(
              children: [
                Expanded(
                    child: Column(
                  children: [Text("Posts"), Text("1")],
                )),
                Expanded(
                    child: Column(
                  children: [Text("Following"), Text("45")],
                )),
                Expanded(
                  child: Column(
                    children: [Text("Followers"), Text("88")],
                  ),
                ),

              ],
            ),
            SizedBox(height: 22.0),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 35.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.deepPurple, // background (button) color
                  foregroundColor: Colors.white, // foreground (text) color
                ),
                onPressed: () {},
                child: const Text('Follow'),
              ),
            ),
            SizedBox(height: 22.0),
        ],
      ),
    );
  }
}
