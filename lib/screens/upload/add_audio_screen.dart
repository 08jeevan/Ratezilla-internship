import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioUpload extends StatefulWidget {
  const AudioUpload({super.key});

  @override
  State<AudioUpload> createState() => _AudioUploadState();
}

class _AudioUploadState extends State<AudioUpload> {

  final recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRecorder();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();

    if(status != PermissionStatus.granted){
      throw 'Microphone permission not granted';
    }

    await recorder.openRecorder();
    isRecorderReady = true;
    recorder. setSubscriptionDuration(
  const Duration (milliseconds: 500),
    );
  }

  Future record() async {
    if(!isRecorderReady) return;
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stop() async {
    if(!isRecorderReady) return;
    await recorder.stopRecorder();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          StreamBuilder<RecordingDisposition>(
            stream: recorder.onProgress,
            builder: (context, snapshot){
              final durattion = snapshot.hasData ?
               snapshot.data!.duration : Duration.zero;
               return Text('${durattion.inSeconds} s');
            },
          ),
          ElevatedButton(
            child: Icon(
              recorder.isRecording ? Icons.stop : Icons.mic,
            ),
            onPressed: () async{
              if(recorder.isRecording){
                await stop();
              }else{
                await record();
              }
              setState(() {
                
              });
            },
          )
        ],
      ),
    );
  }
}