import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

class Reprodutor extends StatefulWidget {
  const Reprodutor({Key? key}) : super(key: key);

  @override
  _ReprodutorState createState() => _ReprodutorState();
}

class _ReprodutorState extends State<Reprodutor> {
// #region Var de Controle
  //Cor BG
  //Color bgCor = Colors.cyanAccent;

  // #region Var de Controle
  bool isFav = true;
  bool isShuf = true;
  bool isLoop = true;
  bool isPlay = true;

  // #endregion

  //Player
  final AudioPlayer _player = AudioPlayer();
  bool isPlayerViewVisible = false;
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

  //Playlist
  List<SongModel> songs = [];
  String currentSongTitle = '';
  int currentIndex = 0;
  final OnAudioQuery _audioQuery = OnAudioQuery();

  // #endregion

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

  Widget circularAudioPlayer(
      RealtimePlayingInfos realtimePlayingInfos, double screenWidth) {
    Color primaryColor = Color(0xfff306c4);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularPercentIndicator(
          radius: screenWidth / 2.2,
          backgroundColor: primaryColor,
          progressColor: Color(0xff584add),
          percent: realtimePlayingInfos.currentPosition.inSeconds /
              realtimePlayingInfos.duration.inSeconds,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        //Background
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFF110a29),
                Color(0xFF2f0823),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const Spacer(flex: 2),
                //Barra superior
                Row(
                  textDirection: TextDirection.ltr,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        elevation: 0,
                        shape: const CircleBorder(),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000),
                        ),
                        child: const Icon(Icons.arrow_back,
                            color: Colors.white, size: 30),
                      ),
                    ),
                    Text('PLAYING NOW',
                        style: GoogleFonts.poiretOne(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center),
                    IconButton(
                      //icon: Icon(Icons.favorite_border, color: Colors.purpleAccent, size: 32),
                      icon: Icon(
                          (isFav == false)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.purpleAccent,
                          size: 32),
                      onPressed: () {
                        setState(() {
                          isFav = !isFav;
                        });
                      },
                    ),
                  ],
                ),
                const Spacer(flex: 3),
                //Album Cover
                Stack(
                  clipBehavior: Clip.none,
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: audioPlayer.builderRealtimePlayingInfos(
                        builder: (context, realtimePlayingInfos) {
                          if (realtimePlayingInfos != null) {
                            return circularAudioPlayer(realtimePlayingInfos,
                                MediaQuery.of(context).size.width);
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                    Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(1000),
                        child: Image.asset('images/cover.jpg', scale: 2),
                      ),
                    ),
                    Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(1000),
                        child: Image.asset('images/circle.png', scale: 2),
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 3),
                //Meio
                Container(
                  child: Row(
                    textDirection: TextDirection.ltr,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isShuf = !isShuf;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          elevation: 0,
                          shape: const CircleBorder(),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1000),
                          ),
                          child: Icon(
                              (isShuf == true) ? Icons.shuffle : Icons.loop,
                              color: Colors.white,
                              size: 40),
                        ),
                      ),
                      Column(
                        children: [
                          Text('POP/STARS',
                              style: GoogleFonts.roboto(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center),
                          Text('K/DA',
                              style: GoogleFonts.poiretOne(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center),
                        ],
                      ),
                      //BOTÃO REPEAT
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoop = !isLoop;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          elevation: 0,
                          shape: const CircleBorder(),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1000),
                          ),
                          child: Icon(
                              (isLoop == true)
                                  ? Icons.repeat
                                  : Icons.repeat_one,
                              color: Colors.white,
                              size: 40),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
                Container(
                  child: Row(
                    textDirection: TextDirection.ltr,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //BOTÃO SKIP BACK
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          elevation: 0,
                          shape: const CircleBorder(),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1000),
                          ),
                          child: const Icon(Icons.skip_previous,
                              color: Colors.white, size: 70),
                        ),
                      ),
                      //BOTÃO PLAY
                      SizedBox(
                        height: 130,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_player.playing) {
                              _player.pause();
                            } else {
                              if (_player.currentIndex != null) {
                                _player.play();
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            elevation: 0,
                            shape: const CircleBorder(),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purpleAccent.withOpacity(0.3),
                                  spreadRadius: 12,
                                  blurRadius: 12,
                                  offset: const Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ],
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xff6d38e5),
                                  Color(0xffb235d7),
                                  Color(0xffff37d8),
                                  Color(0xffff37d8)
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                              borderRadius: BorderRadius.circular(1000),
                            ),
                            child: Icon(
                                (isPlay == true)
                                    ? Icons.play_arrow
                                    : Icons.pause,
                                color: Color(0xFF2c0824),
                                size: 90),
                          ),
                        ),
                      ),
                      //BOTÃO SKIP NEXT
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          elevation: 0,
                          shape: const CircleBorder(),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1000),
                          ),
                          child: const Icon(Icons.skip_next,
                              color: Colors.white, size: 70),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
