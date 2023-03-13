import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:hidable/hidable.dart';
import 'package:ratezilla_user/screens/home/image_screen.dart';
import 'package:ratezilla_user/screens/home/profile_screen.dart';
import 'package:ratezilla_user/screens/home/video_screen.dart';
import 'package:ratezilla_user/screens/upload/add_post_screen.dart';
import 'package:iconsax/iconsax.dart';
import 'package:iconly/iconly.dart';
import 'package:ratezilla_user/screens/upload/add_video_screen.dart';
import 'package:ratezilla_user/utils/colors.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';
import 'package:scroll_bottom_navigation_bar/scroll_bottom_navigation_bar.dart';
import '../screens/home/audio_screen.dart';

enum Menu { image, video, audio }

final ScrollController scrollController = ScrollController();

class MyNavBar extends StatefulWidget {
  const MyNavBar({super.key});
  @override
  State<MyNavBar> createState() => _MyNavBarState();
}

class _MyNavBarState extends State<MyNavBar> {
  

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    ImageScreen(),
    VideoScreen(),
    AudioScreen(),
    ProfileScreen(),
  ];

  String _selectedMenu = '';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      // appBar: ScrollAppBar(
      //   controller: controller,
      //   toolbarHeight: 100,
      //   backgroundColor: isDarkModeOn == false? Colors.white : const Color(0xff303030),
      //   elevation: 0.0,
      //   automaticallyImplyLeading: false,
      //   flexibleSpace: ClipPath(
      //     clipper: Customshape(),
      //     child: Container(
      //       height: 160,
      //       width: MediaQuery.of(context).size.width,
      //       color: primaryColor,
      //       child: Center(
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             const Padding(
      //               padding: EdgeInsets.only(left: 24.0),
      //               child: Icon(
      //                 Iconsax.add_square,
      //                 color: primaryColor,
      //               ),
      //             ),
      //             const Text(
      //               "Ratezilla",
      //               style: TextStyle(
      //                 fontSize: 20,
      //                 color: Colors.white,
      //               ),
      //             ),
      //             _selectedIndex == 3
      //                 ? const Padding(
      //                     padding: EdgeInsets.only(right: 24.0),
      //                     child: Icon(
      //                       Iconsax.add_square,
      //                       color: primaryColor,
      //                     ),
      //                   )
      //                 : SizedBox(
      //                     child: PopupMenuButton<Menu>(
      //                       icon: const Icon(
      //                         Iconsax.add_square,
      //                         color: Colors.white,
      //                       ),
      //                       // Callback that sets the selected popup menu item.
      //                       onSelected: (Menu item) {
      //                         setState(() {
      //                           _selectedMenu = item.name;
      //                           print(_selectedMenu);
      //                           print(_selectedIndex);
      //                         });
      //                       },
      //                       itemBuilder: (BuildContext context) =>
      //                           <PopupMenuEntry<Menu>>[
      //                         PopupMenuItem<Menu>(
      //                           value: Menu.image,
      //                           child: Row(
      //                             children: const [
      //                               Icon(IconlyLight.image, size: 20.0),
      //                               SizedBox(width: 12.0),
      //                               Text("Image"),
      //                             ],
      //                           ),
      //                           onTap: () {
      //                             WidgetsBinding.instance.addPostFrameCallback(
      //                               (_) {
      //                                 Navigator.push(
      //                                   context,
      //                                   MaterialPageRoute(
      //                                     builder: (context) {
      //                                       return AddPost(uid: "",);
      //                                     },
      //                                   ),
      //                                 );
      //                               },
      //                             );
      //                           },
      //                         ),
      //                         PopupMenuItem<Menu>(
      //                           value: Menu.video,
      //                           child: Row(
      //                             children: const [
      //                               Icon(IconlyLight.video, size: 20.0),
      //                               SizedBox(width: 12.0),
      //                               Text("Video"),
      //                             ],
      //                           ),onTap: () {
      //                             WidgetsBinding.instance.addPostFrameCallback(
      //                               (_) {
      //                                 Navigator.push(
      //                                   context,
      //                                   MaterialPageRoute(
      //                                     builder: (context) {
      //                                       return AddVideo();
      //                                     },
      //                                   ),
      //                                 );
      //                               },
      //                             );
      //                           },
      //                         ),
      //                         PopupMenuItem<Menu>(
      //                           value: Menu.audio,
      //                           child: Row(
      //                             children: const [
      //                               Icon(Icons.audio_file_outlined, size: 20.0),
      //                               SizedBox(width: 12.0),
      //                               Text("Audio"),
      //                             ],
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Hidable(
        controller: scrollController,
      child: SizedBox(
        height: 65.0,
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(IconlyLight.image),
              activeIcon: Icon(IconlyBold.image_2),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(IconlyLight.video),
              activeIcon: Icon(IconlyBold.video),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_music_outlined),
              activeIcon: Icon(Icons.my_library_music_rounded),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(IconlyLight.profile),
              activeIcon: Icon(IconlyBold.profile),
              label: '',
            ),
          ],
          currentIndex: _selectedIndex,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedFontSize: 0.0,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
        ),
      ),
      ),
    );
  }
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
