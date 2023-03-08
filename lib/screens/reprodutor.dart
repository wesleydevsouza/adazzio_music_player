import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/components/components.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../components/functions.dart';
import '../constants/styling.dart';
import 'package:rxdart/rxdart.dart';

class Reprodutor extends StatefulWidget {
  const Reprodutor({Key? key}) : super(key: key);

  @override
  _ReprodutorState createState() => _ReprodutorState();
}

class _ReprodutorState extends State<Reprodutor> {
  bool isShuf = false;
  bool isFav = true;

  final OnAudioQuery _audioQuery = OnAudioQuery();

  final AudioPlayer _player = AudioPlayer();
  bool isPlayerViewVisible = false;

  List<SongModel> songs = [];
  String currentSongTitle = '';
  int currentIndex = 0;

  //define a method to set the player view visibility
  ///TODO: REMOVER
  // void _changePlayerViewVisibility() {
  //   setState(() {
  //     isPlayerViewVisible = !isPlayerViewVisible;
  //   });
  // }

  //duration state stream
  Stream<DurationState> get _durationStateStream =>
      Rx.combineLatest2<Duration, Duration?, DurationState>(
          _player.positionStream,
          _player.durationStream,
          (position, duration) => DurationState(
              position: position, total: duration ?? Duration.zero));

  //request permission from initStateMethod
  @override
  void initState() {
    super.initState();
    requestStoragePermission();

    //update the current playing song index listener
    _player.currentIndexStream.listen((index) {
      if (index != null) {
        _updateCurrentPlayingSongDetails(index);
      }
    });
  }

  //Player Disposer
  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        left: true,
        right: true,
        bottom: true,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: AppTheme.GradientBG,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 26, 5, 0),
            child: Column(
              children: <Widget>[
                // Song Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AddazButton(
                      icone: Icons.arrow_back,
                      tamanho: 30,
                      onPress: () {
                        //_cha1ngePlayerViewVisibility();
                      },
                    ),

                    // Container(
                    //   child: Flexible(
                    //     child: Text(
                    //       currentSongTitle,
                    //       style: const TextStyle(
                    //         color: Colors.white70,
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 18,
                    //       ),
                    //     ),
                    //     flex: 5,
                    //   ),
                    // ),

                    //Fav Button
                    IconButton(
                      icon: Icon(
                          (isFav == false)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: AppTheme.corDestaque,
                          size: 32),
                      onPressed: () {
                        setState(() {
                          isFav = !isFav;
                        });
                      },
                    ),
                  ],
                ),
                //Album Artwork
                Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(44, 12, 0, 0),
                      child: Container(
                        alignment: Alignment.center,
                        width: AppTheme.largAlbum,
                        height: AppTheme.altAlbum,
                        decoration: AppTheme.getDecoration(
                            BoxShape.circle, const Offset(2, 2), 2.0, 0.0),
                        margin: const EdgeInsets.only(top: 30, bottom: 30),
                        // child: QueryArtworkWidget(
                        //   id: songs[currentIndex].id,
                        //   type: ArtworkType.AUDIO,
                        //   artworkBorder: BorderRadius.circular(200.0),
                        // ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: Image.asset('images/circle.png', scale: 2),
                    ),
                  ],
                ),
                //Progress
                Column(
                  children: [
                    StreamBuilder<DurationState>(
                      stream: _durationStateStream,
                      builder: (context, snapshot) {
                        final durationState = snapshot.data;
                        final progress =
                            durationState?.position ?? Duration.zero;
                        final total = durationState?.total ?? Duration.zero;

                        return Row(
                          textDirection: TextDirection.ltr,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  progress.toString().split(".")[0],
                                  style: const TextStyle(
                                    color: AppTheme.corFonteProgress,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                currentSongTitle,
                                style: Theme.of(context).textTheme.bodyText1,
                                textAlign: TextAlign.center,
                              ),
                              flex: 5,
                            ),
                            Flexible(
                              child: Text(
                                total.toString().split(".")[0],
                                style: const TextStyle(
                                  color: AppTheme.corFonte,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                //Buttons
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    textDirection: TextDirection.ltr,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      //Prev Button
                      AddazButton(
                        icone: Icons.skip_previous,
                        tamanho: 70,
                        onPress: () {
                          if (_player.hasPrevious) {
                            _player.seekToPrevious();
                          }
                        },
                      ),
                      //Play/Pause
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            if (_player.playing) {
                              _player.pause();
                            } else {
                              if (_player.currentIndex != null) {
                                _player.play();
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.corDestaque.withOpacity(0.3),
                                  spreadRadius: 12,
                                  blurRadius: 12,
                                  offset: const Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ],
                              gradient: const LinearGradient(
                                colors: AppTheme.GradientButton,
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: StreamBuilder<bool>(
                              stream: _player.playingStream,
                              builder: (context, snapshot) {
                                bool? playingState = snapshot.data;
                                if (playingState != null && playingState) {
                                  return const Icon(
                                    Icons.pause,
                                    size: 90,
                                    color: Color(0xFF2c0824),
                                  );
                                }
                                return const Icon(
                                  Icons.play_arrow,
                                  size: 90,
                                  color: Color(0xFF2c0824),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      // Next Button
                      AddazButton(
                          icone: Icons.skip_next,
                          tamanho: 70,
                          onPress: () {
                            if (_player.hasPrevious) {
                              _player.seekToNext();
                            }
                          }),
                    ],
                  ),
                ),
                //Player Visibility and Controlls
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    textDirection: TextDirection.ltr,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Shuffle Button
                      AddazButton(
                        icone: Icons.shuffle,
                        tamanho: 40,
                        onPress: () {
                          if (isShuf == false) {
                            isShuf = true;
                            _player.setShuffleModeEnabled(true);
                            toast(context, "Shuffling enabled");
                          } else {
                            isShuf = false;
                            _player.setShuffleModeEnabled(false);
                            toast(context, "Shuffling disabled");
                          }
                        },
                      ),
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            _player.loopMode == LoopMode.one
                                ? _player.setLoopMode(LoopMode.all)
                                : _player.setLoopMode(LoopMode.one);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1000),
                            ),
                            child: StreamBuilder<LoopMode>(
                              stream: _player.loopModeStream,
                              builder: (context, snapshot) {
                                final loopMode = snapshot.data;
                                if (LoopMode.one == loopMode) {
                                  return const Icon(
                                    Icons.repeat_one,
                                    color: AppTheme.corFonte,
                                    size: 40,
                                  );
                                }
                                return const Icon(
                                  Icons.repeat,
                                  color: AppTheme.corFonte,
                                  size: 40,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void requestStoragePermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      setState(() {});
    }
  }

  void _updateCurrentPlayingSongDetails(int index) {
    setState(() {
      if (songs.isNotEmpty) {
        currentSongTitle = songs[index].title;
        currentIndex = index;
      }
    });
  }
}
