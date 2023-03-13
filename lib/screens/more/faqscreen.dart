import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:ratezilla_user/global/appbar.dart';
import 'package:ratezilla_user/services/firebase_auth_methods.dart';
import 'package:ratezilla_user/utils/fonts.dart';
import 'package:ratezilla_user/utils/global.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';
import 'package:provider/provider.dart';

final ScrollController scrollController = ScrollController();

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

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
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          ExpandablePanel(
            header:
                Text("How will Ratezilla benefit users?", style: kmediumfont),
            collapsed: Container(),
            expanded: Text(
              "In Ratezilla, we have benefits for all users. Every post will be evaluated by the total number of majority likes received and Ratezilla coins will be granted to users which will be available in Wallet. Coins in wallet can be redeemed anytime",
              softWrap: true,
              style: kmediumfontlight,
            ),
          ),
          Divider(),
          ExpandablePanel(
            header: Text("Is registration in Ratezilla free of cost?",
                style: kmediumfont),
            collapsed: Container(),
            expanded: Text(
              "Ratezilla app is free to use and does not involve any registration fees or charges. Registration and app usability is free",
              softWrap: true,
              style: kmediumfontlight,
            ),
          ),
          Divider(),
          ExpandablePanel(
            header: Text("How many ways a User can post in Ratezilla?",
                style: kmediumfont),
            collapsed: Container(),
            expanded: Text(
              "Registered users in Ratezilla can post Images, Videos, Audio content",
              softWrap: true,
              style: kmediumfontlight,
            ),
          ),
          Divider(),
          ExpandablePanel(
            header: Text("In Ratezilla, are users allowed to post any content?",
                style: kmediumfont),
            collapsed: Container(),
            expanded: Text(
              "Yes, Ratezilla let’s users to post quality contents which will be inspired to everyone. Admins will approve the posts before it is available to open public. Once the posts are available in open publish forum, other users can start rating and liking the posts",
              softWrap: true,
              style: kmediumfontlight,
            ),
          ),
          Divider(),
          ExpandablePanel(
            header:
                Text("How is rating system in Ratezilla?", style: kmediumfont),
            collapsed: Container(),
            expanded: Text(
              "For every post, users can either like or dislike a content based on individual perspective. Likes will be rating system from 6 to 10 and likewise dislikes will be rated from 0 to 6",
              softWrap: true,
              style: kmediumfontlight,
            ),
          ),
          Divider(),
          ExpandablePanel(
            header: Text("How long your post is visible to public forum?",
                style: kmediumfont),
            collapsed: Container(),
            expanded: Text(
              "Every post will be evaluated by Admin and published. Every post will be visible to open forum or general public for 3 weeks.",
              softWrap: true,
              style: kmediumfontlight,
            ),
          ),
          Divider(),
          ExpandablePanel(
            header:
                Text("Can we add friends in Ratezilla?", style: kmediumfont),
            collapsed: Container(),
            expanded: Text(
              "Yes. You can add or request friends to follow.",
              softWrap: true,
              style: kmediumfontlight,
            ),
          ),
          Divider(),
          ExpandablePanel(
            header: Text("Is there by Iimit for posting in Ratezilla?",
                style: kmediumfont),
            collapsed: Container(),
            expanded: Text(
              "No",
              softWrap: true,
              style: kmediumfontlight,
            ),
          ),
          Divider(),
          ExpandablePanel(
            header: Text("What’s the duration of post evaluation by admin?",
                style: kmediumfont),
            collapsed: Container(),
            expanded: Text(
              "Every post will be evaluated once in 3 weeks and consolidated rating will be published. All users who give accurate ratings will be rewarded",
              softWrap: true,
              style: kmediumfontlight,
            ),
          ),
        ],
      ),
    );
  }
}
