import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ratezilla_user/screens/audioplayer/screens/record_and_play_audio.dart';
import 'package:ratezilla_user/screens/upload/add_post_screen.dart';
import 'package:ratezilla_user/screens/upload/add_video_screen.dart';
import 'package:ratezilla_user/utils/colors.dart';

enum Menu { image, video, audio }

ClipPath scrollAppBar(BuildContext context, String uid) {
  return ClipPath(
    clipper: Customshape(),
    child: Container(
      height: 200,
      padding: EdgeInsets.only(bottom: 8.0),
      width: MediaQuery.of(context).size.width,
      color: primaryColor,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 24.0),
              child: Icon(
                Iconsax.add_square,
                color: primaryColor,
              ),
            ),
            const Text(
              "Ratezilla",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(
              child: PopupMenuButton<Menu>(
                icon: const Icon(
                  Iconsax.add_square,
                  color: Colors.white,
                ),
                // Callback that sets the selected popup menu item.

                itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                  PopupMenuItem<Menu>(
                    value: Menu.image,
                    child: Row(
                      children: const [
                        Icon(IconlyLight.image, size: 20.0),
                        SizedBox(width: 12.0),
                        Text("Image"),
                      ],
                    ),
                    onTap: () {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return AddPost(
                                  uid: uid,
                                );
                              },
                            ),
                          );
                          print("..........................");
                          print(uid);
                        },
                      );
                    },
                  ),
                  PopupMenuItem<Menu>(
                    value: Menu.video,
                    child: Row(
                      children: const [
                        Icon(IconlyLight.video, size: 20.0),
                        SizedBox(width: 12.0),
                        Text("Video"),
                      ],
                    ),
                    onTap: () {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return AddVideo(
                                  uid: uid,
                                );
                              },
                            ),
                          );
                          print("........trigger..................");
                          print(uid);
                        },
                      );
                    },
                  ),
                  PopupMenuItem<Menu>(
                    value: Menu.audio,
                    child: Row(
                      children: const [
                        Icon(Icons.audio_file_outlined, size: 20.0),
                        SizedBox(width: 12.0),
                        Text("Audio"),
                      ],
                    ),onTap: () {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return RecordAndPlayScreen(
                                  uid: uid,
                                );

                              },
                            ),
                          );
                          print("........trigger..................");
                          print(uid);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class Customshape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;

    var path = Path();
    path.lineTo(0, height - 50);
    path.quadraticBezierTo(width / 2, height, width, height - 50);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
