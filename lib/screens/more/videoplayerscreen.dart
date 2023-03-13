import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

final ScrollController scrollController = ScrollController();

class VideoPlayerScreen extends StatefulWidget {
  String playerrul = '';
   VideoPlayerScreen({super.key, required this.playerrul});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  TargetPlatform? _platform;
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  int? bufferDelay;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }


  String srcs =
      "https://firebasestorage.googleapis.com/v0/b/ratezilla-68d5e.appspot.com/o/Posts%2F7sDTwCX3WvVJ0IsGFoYMDkfar4U2%2Fbee02200-8150-11ed-8140-bd000e9550c5?alt=media&token=844975c0-6e25-4612-aa8e-aabd67e7cbd6";

  Future<void> initializePlayer() async {
    videoPlayerController = VideoPlayerController.network(widget.playerrul);
    await Future.wait([
      videoPlayerController.initialize(),
    ]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
      allowPlaybackSpeedChanging: false,
      autoInitialize: false,
      // placeholder: Icon(Icons.video_call_rounded),
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
      additionalOptions: (context) {
        return <OptionItem>[
          OptionItem(
            onTap: toggleVideo,
            iconData: Icons.live_tv_sharp,
            title: '',
          ),
        ];
      },
      hideControlsTimer: const Duration(seconds: 2),
    );
  }

  int currPlayIndex = 0;

  Future<void> toggleVideo() async {
    await videoPlayerController.pause();
    currPlayIndex += 1;
    if (currPlayIndex >= srcs.length) {
      currPlayIndex = 0;
    }
    await initializePlayer();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkModeOn == false ? Colors.transparent :  Colors.transparent,
      appBar: AppBar(
        backgroundColor: isDarkModeOn == false ? Colors.transparent :  Colors.transparent,
      ),
      body: Center(
        child: Container(
          height: 260.0,
          width: MediaQuery.of(context).size.width,
          child: chewieController != null &&
                  chewieController!.videoPlayerController.value.isInitialized
              ? Chewie(
                  controller: chewieController!,
                )
              : Container(
                  height: 100.0,
                  width: 100.0,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
        ),
      ),
    );
  }
}
