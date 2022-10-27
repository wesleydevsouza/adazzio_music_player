import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

class TestingApp extends StatefulWidget {
  const TestingApp({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<TestingApp> createState() => _TestingAppState();
}

class _TestingAppState extends State<TestingApp> {
  // #region Var de Controle
  Color bgColor = Colors.brown;

  bool isShuf = false;
  bool isFav = true;

  final OnAudioQuery _audioQuery = OnAudioQuery();

  // #region Player
  final AudioPlayer _player = AudioPlayer();
  bool isPlayerViewVisible = false;
  // #endregion

  // #region Song List
  List<SongModel> songs = [];
  String currentSongTitle = '';
  int currentIndex = 0;
  // #endregion

  // #endregion

  //define a method to set the player view visibility
  void _changePlayerViewVisibility() {
    setState(() {
      isPlayerViewVisible = !isPlayerViewVisible;
    });
  }

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
    if (isPlayerViewVisible) {
      return Scaffold(
        // backgroundColor: bgColor,
        body: SafeArea(
          child: Container(
            // width: double.infinity,
            // padding: const EdgeInsets.only(top: 56.0, right: 20.0, left: 20.0),
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
              padding: const EdgeInsets.fromLTRB(5, 26, 5, 0),
              child: Column(
                children: <Widget>[
                  // #region Exit Button / Song Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _changePlayerViewVisibility();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          elevation: 0,
                          shape: const CircleBorder(),
                        ),
                        child: InkWell(
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1000),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),

                      // #region Music Title
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
                      // #endregion

                      // #region Fav Button
                      IconButton(
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
                      // #endregion
                    ],
                  ),
                  // #endregion

                  // #region Album Artwork
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: getDecoration(
                          BoxShape.circle, const Offset(2, 2), 2.0, 0.0),
                      margin: const EdgeInsets.only(top: 30, bottom: 30),
                      child: QueryArtworkWidget(
                        id: songs[currentIndex].id,
                        type: ArtworkType.AUDIO,
                        artworkBorder: BorderRadius.circular(200.0),
                      ),
                    ),
                  ),
                  // #endregion

                  // #region Progress
                  Column(
                    children: [
                      // #region Progress
                      StreamBuilder<DurationState>(
                        stream: _durationStateStream,
                        builder: (context, snapshot) {
                          final durationState = snapshot.data;
                          final progress =
                              durationState?.position ?? Duration.zero;
                          final total = durationState?.total ?? Duration.zero;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Flexible(
                                child: Text(
                                  progress.toString().split(".")[0],
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  currentSongTitle,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                flex: 5,
                              ),
                              Flexible(
                                child: Text(
                                  total.toString().split(".")[0],
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      // #endregion
                    ],
                  ),
                  // #endregion

                  // #region Bottons
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Row(
                      textDirection: TextDirection.ltr,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // #region Prev Button
                        ElevatedButton(
                          onPressed: () {
                            if (_player.hasPrevious) {
                              _player.seekToPrevious();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            elevation: 0,
                            shape: const CircleBorder(),
                          ),
                          child: InkWell(
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1000),
                              ),
                              child: const Icon(Icons.skip_previous,
                                  color: Colors.white, size: 70),
                            ),
                          ),
                        ),
                        // #endregion

                        // #region Play/Pause
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
                        // #endregion

                        // #region Next Button
                        ElevatedButton(
                          onPressed: () {
                            if (_player.hasPrevious) {
                              _player.seekToNext();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            elevation: 0,
                            shape: const CircleBorder(),
                          ),
                          child: InkWell(
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1000),
                              ),
                              child: const Icon(Icons.skip_next,
                                  color: Colors.white, size: 70),
                            ),
                          ),
                        ),
                        // #endregion
                      ],
                    ),
                  ),
                  // #endregion

                  // #region Player Visibility and Controlls
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Row(
                      textDirection: TextDirection.ltr,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // #region Shuffle Button
                        ElevatedButton(
                          onPressed: () {
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
                          style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            elevation: 0,
                            shape: const CircleBorder(),
                          ),
                          child: InkWell(
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1000),
                              ),
                              child: const Icon(Icons.shuffle,
                                  color: Colors.white, size: 40),
                            ),
                          ),
                        ),
                        // #endregion

                        // #region Repeat Button
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
                                      color: Colors.white,
                                      size: 40,
                                    );
                                  }
                                  return const Icon(
                                    Icons.repeat,
                                    color: Colors.white,
                                    size: 40,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        // #endregion
                      ],
                    ),
                  ),
                  // #endregion
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        //backgroundColor: bgColor,
        elevation: 20,
        backgroundColor: bgColor,
      ),
      backgroundColor: bgColor,
      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, item) {
          // #region Content

          // #region Loading
          if (item.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // #endregion

          // #region No songs found
          if (item.data!.isEmpty) {
            return const Center(
              child: Text("No Songs Found"),
            );
          }
          // #endregion

          // #endregion

          // You can use [item.data!] direct or you can create a list of songs as
          // List<SongModel> songs = item.data!;

          //showing the songs

          // #region Adding songs to the list
          songs.clear();
          songs = item.data!;
          return ListView.builder(
              itemCount: item.data!.length,
              itemBuilder: (context, index) {
                return Container(
                  margin:
                      const EdgeInsets.only(top: 15.0, left: 12.0, right: 16.0),
                  padding: const EdgeInsets.only(top: 30.0, bottom: 30),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4.0,
                        offset: Offset(-4, -4),
                        color: Colors.white24,
                      ),
                      BoxShadow(
                        blurRadius: 4.0,
                        offset: Offset(4, 4),
                        color: Colors.black,
                      ),
                    ],
                  ),
                  child: ListTile(
                    textColor: Colors.white,
                    title: Text(item.data![index].title),
                    subtitle: Text(
                      item.data![index].displayName,
                      style: const TextStyle(
                        color: Colors.white60,
                      ),
                    ),
                    trailing: const Icon(Icons.more_vert),
                    leading: QueryArtworkWidget(
                      id: item.data![index].id,
                      type: ArtworkType.AUDIO,
                    ),
                    onTap: () async {
                      //show the player view
                      _changePlayerViewVisibility();

                      toast(context, "Playing:  " + item.data![index].title);
                      // Try to load audio from a source and catch any errors.
                      //  String? uri = item.data![index].uri;
                      // await _player.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
                      await _player.setAudioSource(createPlaylist(item.data!),
                          initialIndex: index);
                      await _player.play();
                    },
                  ),
                );
              });
          // #endregion
        },
      ),
    );
  }

  // #region Toast Message
  void toast(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
    ));
  }
  // #endregion

  // #region User permission
  void requestStoragePermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      setState(() {});
    }
  }
  // #endregion

  //create playlist
  ConcatenatingAudioSource createPlaylist(List<SongModel> songs) {
    List<AudioSource> sources = [];
    for (var song in songs) {
      sources.add(AudioSource.uri(Uri.parse(song.uri!)));
    }
    return ConcatenatingAudioSource(children: sources);
  }

  // #region Song Title/Index Updater
  void _updateCurrentPlayingSongDetails(int index) {
    setState(() {
      if (songs.isNotEmpty) {
        currentSongTitle = songs[index].title;
        currentIndex = index;
      }
    });
  }
  // #endregion

  BoxDecoration getDecoration(
      BoxShape shape, Offset offset, double blurRadius, double spreadRadius) {
    return BoxDecoration(
      color: bgColor,
      shape: shape,
      boxShadow: [
        BoxShadow(
          offset: -offset,
          color: Colors.white24,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        ),
        BoxShadow(
          offset: offset,
          color: Colors.black,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        )
      ],
    );
  }

  BoxDecoration getRectDecoration(BorderRadius borderRadius, Offset offset,
      double blurRadius, double spreadRadius) {
    return BoxDecoration(
      borderRadius: borderRadius,
      color: bgColor,
      boxShadow: [
        BoxShadow(
          offset: -offset,
          color: Colors.white12,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        ),
        BoxShadow(
          offset: offset,
          color: Colors.black,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        )
      ],
    );
  }
}

// #region Duration
class DurationState {
  DurationState({this.position = Duration.zero, this.total = Duration.zero});
  Duration position, total;
}
// #endregion
