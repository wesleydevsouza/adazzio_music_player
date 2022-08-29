import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Circular extends StatefulWidget {
  const Circular({Key? key}) : super(key: key);

  @override
  State<Circular> createState() => _CircularState();
}

class _CircularState extends State<Circular> {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    super.initState();
    setupPlaylist();
  }

  void setupPlaylist() async {
    await audioPlayer.open(Audio('/music/pop.mp3'), autoStart: false);
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  Widget circularAudioPlayer(RealtimePlayingInfos realtimePlayingInfos,
      double screenWidth) {
    Color primaryColor = Color(0xffff37d8);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 80),
        CircularPercentIndicator(
          radius: screenWidth / 2,
          backgroundColor: primaryColor,
          progressColor: Color(0xff584add),
          percent: realtimePlayingInfos.currentPosition.inSeconds/realtimePlayingInfos.duration.inSeconds,
          center: IconButton(
            iconSize: screenWidth / 8,
            color: primaryColor,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: Icon(realtimePlayingInfos.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
            onPressed: () => audioPlayer.playOrPause(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: audioPlayer.builderRealtimePlayingInfos(
          builder: (context, realtimePlayingInfos) {
            if (realtimePlayingInfos != null) {
              return circularAudioPlayer(
                  realtimePlayingInfos, MediaQuery
                  .of(context)
                  .size
                  .width);
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
