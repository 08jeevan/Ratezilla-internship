import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ratezilla_user/services/firebase_crud.dart';
import 'package:ratezilla_user/utils/colors.dart';
import 'package:ratezilla_user/utils/fonts.dart';

class PlayerScreen extends StatefulWidget {
  final String documentId, imgurl, audiourl, postid, uid, username;
  final List likepost;
  const PlayerScreen({
    Key? key,
    required this.documentId,
    required this.imgurl,
    required this.audiourl,
    required this.postid,
    required this.uid,
    required this.username,
    required this.likepost,
  }) : super(key: key);

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late final PageManager _pageManager;

  @override
  void initState() {
    _pageManager = PageManager(
      widget.audiourl,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('Audio_posts');

    return Scaffold(
      // appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          child: FutureBuilder<DocumentSnapshot>(
            future: users.doc(widget.documentId).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return Text("Document does not exist");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          // const Spacer(),

                          SizedBox(
                            height: 80.0,
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35.0),
                              child: Container(
                                height: 300.0,
                                width: MediaQuery.of(context).size.width,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: widget.imgurl == ""
                                      ? Image.asset(
                                          "assets/images/bgthumb.png",
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          fit: BoxFit.cover,
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          child: Image.network(
                                            widget.imgurl,
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          ValueListenableBuilder<ProgressBarState>(
                            valueListenable: _pageManager.progressNotifier,
                            builder: (_, value, __) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 35.0),
                                child: ProgressBar(
                                  progress: value.current,
                                  buffered: value.buffered,
                                  total: value.total,
                                  onSeek: _pageManager.seek,
                                ),
                              );
                            },
                          ),

                          SizedBox(
                            height: 10.0,
                          ),

                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 35.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ValueListenableBuilder<ButtonState>(
                                  valueListenable: _pageManager.buttonNotifier,
                                  builder: (_, value, __) {
                                    switch (value) {
                                      case ButtonState.loading:
                                        return Container(
                                          height: 100.0,
                                          width: 100.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            color: bgcolor,
                                          ),
                                          child:
                                              const CircularProgressIndicator(),
                                        );
                                      case ButtonState.paused:
                                        return Container(
                                          height: 100.0,
                                          width: 100.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            color: bgcolor,
                                          ),
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.play_arrow,
                                              size: 52.0,
                                            ),
                                            onPressed: _pageManager.play,
                                          ),
                                        );

                                      case ButtonState.playing:
                                        return Container(
                                          height: 100.0,
                                          width: 100.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            color: bgcolor,
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.pause,
                                              size: 52.0,
                                            ),
                                            onPressed: _pageManager.pause,
                                          ),
                                        );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Card(
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            var likes = widget.likepost;
                                                likes.toString().contains(
                                                        widget.uid)
                                                    ? FirestoreHelper()
                                                        .removeFromArray(
                                                            "Audio_posts",
                                                            widget.postid,
                                                            widget.uid,
                                                            widget
                                                                .username)
                                                    : FirestoreHelper()
                                                        .appendToArray(
                                                            "Audio_posts",
                                                            widget.postid,
                                                            widget.uid,
                                                            widget
                                                                .username);
                                                setState(() {});
                                                // likepost.contains(uid)
                                                //     ? FirestoreHelper().removeFromArray(
                                                //         "Image_posts", postid, uid, username)
                                                //     : FirestoreHelper().appendToArray(
                                                //         "Image_posts", postid, uid, username);
                                              },
                                          child: widget.likepost
                                                  .contains((widget.uid))
                                              ? const Icon(
                                                  Icons.thumb_up_alt_rounded,
                                                  size: 28.0,
                                                )
                                              : const Icon(
                                                  Icons.thumb_up_alt_outlined,
                                                  size: 28.0,
                                                ),
                                        ),
                                        SizedBox(width: 12.0),
                                        Text(widget.likepost.length.toString() +
                                            " Like"),
                                      ],
                                    ),
                                    SizedBox(height: 8.0),
                                    data['postdesc'].isEmpty
                                        ? Container()
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      data['username'].isEmpty
                                                          ? ""
                                                          : data['username']
                                                              .toString(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 17,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 8.0),
                                                  Expanded(
                                                    child: Text(
                                                      data['postdesc'].isEmpty
                                                          ? ""
                                                          : data['postdesc']
                                                              .toString(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0.0, 4.0, 0.0, 2.0),
                                      child: SizedBox(
                                        height: 25.0,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Row(
                                          children: [
                                            Text(
                                              data['uploaddate'].isEmpty
                                                  ? ""
                                                  : data['uploaddate']
                                                      .toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return const Center(child: Text("loading"));
            },
          ),
        ),
      ),
    );
  }
}

class PageManager {
  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );
  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);

  late AudioPlayer _audioPlayer;
  PageManager(String audiourl) {
    _init(audiourl.toString());
  }

  void _init(String url) async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer.setUrl(url);

    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        buttonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        buttonNotifier.value = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        buttonNotifier.value = ButtonState.playing;
      } else {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
      }
    });

    _audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    _audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  void play() {
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}

class ProgressBarState {
  ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
  final Duration current;
  final Duration buffered;
  final Duration total;
}

enum ButtonState { paused, playing, loading }
