import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rxdart/rxdart.dart';

class Migration extends StatefulWidget {
  const Migration({Key? key}) : super(key: key);

  @override
  State<Migration> createState() => _MigrationState();
}

class _MigrationState extends State<Migration> {
  // #region Var de Controle
  Color bgColor = Color(0xFF110a29);

  //Player
  final AudioPlayer _player = AudioPlayer();
  bool isPlayerViewVisible = true;
  //TODO: RETIRAR ESSE PLAYER
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

  // #region Var de Controle
  bool isFav = true;
  bool isShuf = true;
  bool isLoop = true;
  bool isPlay = true;
  // #endregion

  //Playlist
  List<SongModel> songs = [];
  String currentSongTitle = '';
  String currentArtist = '';
  int currentIndex = 0;
  final OnAudioQuery _audioQuery = OnAudioQuery();

  // #endregion

  //Player
  // #region Visibility Changer
  void _changePlayerViewVisibility() {
    setState(() {
      isPlayerViewVisible = !isPlayerViewVisible;
    });
  }
  // #endregion

  // #region Duration State
  Stream<DurationState> get _durationStateStream =>
      Rx.combineLatest2<Duration, Duration?, DurationState>(
          _player.positionStream,
          _player.durationStream,
          (position, duration) => DurationState(
              position: position, total: duration ?? Duration.zero));
  // #endregion

  // #region User Permision
  @override
  void initState() {
    super.initState();
    requestStoragePermission();

    //Atualiza o index da musica que está reproduzindo
    _player.currentIndexStream.listen((index) {
      if (index != null) {
        _updateCurrentPlainhSongDatails(index);
      }
    });
  }
  // #endregion

  // #region Player Disposer
  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
  // #endregion

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
    if (isPlayerViewVisible) {
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
                        alignment: Alignment.center,
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
                            Text(
                              currentSongTitle,
                              style: GoogleFonts.roboto(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 25.0),
            Text('PLAYLIST',
                style: GoogleFonts.poiretOne(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center),
            SizedBox(height: 20.0),
            FutureBuilder<List<SongModel>>(
              future: _audioQuery.querySongs(
                sortType: null,
                orderType: OrderType.ASC_OR_SMALLER,
                uriType: UriType.EXTERNAL,
                ignoreCase: true,
              ),
              builder: (context, item) {
                //Carregando as músicas
                if (item.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                //Se não encontrar nenhuma música
                if (item.data!.isEmpty) {
                  return const Center(
                    child: Text("No Songs was found"),
                  );
                }

                //adicionando as músicas à lista de músicas
                songs.clear();
                songs = item.data!;
                return Expanded(
                  child: ListView.builder(
                      itemCount: item.data!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(
                              top: 12.0, left: 8.0, right: 8.0),
                          padding: const EdgeInsets.only(top: 7.0, bottom: 8.0),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Color(0xff9e2186), Color(0xff4f0f41)],
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4.0,
                                offset: Offset(6, 6),
                                color: Color(0xffbf2aa2).withOpacity(0.9),
                              ),
                            ],
                          ),
                          child: ListTile(
                            textColor: Colors.white,
                            title: Text(item.data![index].title),
                            subtitle: Text(item.data![index].fileExtension),
                            trailing: const Icon(Icons.more_vert),
                            leading: QueryArtworkWidget(
                              id: item.data![index].id,
                              type: ArtworkType.AUDIO,
                            ),
                            onTap: () async {
                              //mostrar a view do player
                              _changePlayerViewVisibility();

                              toast(context,
                                  "Playing " + item.data![index].title);

                              //String? uri = item.data![index].uri;
                              await _player.setAudioSource(
                                  createPlaylist(item.data!),
                                  initialIndex: index);
                              await _player.play();
                            },
                          ),
                        );
                      }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void toast(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
    ));
  }

  void requestStoragePermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      //ensure build method is called
      setState(() {});
    }
  }

  ConcatenatingAudioSource createPlaylist(List<SongModel> songs) {
    List<AudioSource> sources = [];
    for (var song in songs) {
      sources.add(AudioSource.uri(Uri.parse(song.uri!)));
    }
    return ConcatenatingAudioSource(children: sources);
  }

  void _updateCurrentPlainhSongDatails(int index) {
    setState(() {
      if (songs.isNotEmpty) {}
      currentSongTitle = songs[index].title;
      currentArtist = songs[index].artist!;

      currentIndex = index;
    });
  }

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
}

//duração
class DurationState {
  DurationState({this.position = Duration.zero, this.total = Duration.zero});
  Duration position, total;
}
