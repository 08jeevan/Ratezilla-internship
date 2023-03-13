import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:ratezilla_user/global/navbar.dart';
import 'package:ratezilla_user/global/themes.dart';
import 'package:ratezilla_user/screens/audioplayer/providers/play_audio_provider.dart';
import 'package:ratezilla_user/screens/audioplayer/providers/record_audio_provider.dart';
import 'package:ratezilla_user/screens/audioplayer/screens/record_and_play_audio.dart';
import 'package:ratezilla_user/screens/home/login_screen.dart';
import 'package:ratezilla_user/screens/home/more_info.dart';
import 'package:ratezilla_user/screens/home/splash_scree.dart';
import 'package:ratezilla_user/services/firebase_auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:ratezilla_user/helper/videoplayer.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? isviewed;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Onboard Sharedpref
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('onBoard');
  //
  runApp(
    EasyDynamicThemeWidget(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecordAudioProvider()),
        ChangeNotifierProvider(create: (_) => PlayAudioProvider()),
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        title: 'Ratezilla',
        theme: lightThemeData,
        darkTheme: darkThemeDatas,
        themeMode: EasyDynamicTheme.of(context).themeMode,
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        // home: MoreUserInfo(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return isviewed != 0 ? MoreUserInfo() : MyNavBar();
      // return const MoreUserInfo();
    }
    return const LoginScreen();
  }
}
