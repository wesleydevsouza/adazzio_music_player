import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

class Playlist extends StatefulWidget {
  const Playlist({Key? key}) : super(key: key);

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  // #region Var de Controle
  //Cor BG
  //Color bgCor = Colors.cyanAccent;

  //Player
  final AudioPlayer _player = AudioPlayer();
  bool isPlayerViewVisible = false;

  //Playlist
  List<SongModel> songs = [];
  String currentSongTitle = '';
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
        _updateCurrentPlainhSongDataIs(index);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 25.0),
            Text('PLAYING NOW',
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

  void _updateCurrentPlainhSongDataIs(int index) {
    setState(() {
      if (songs.isNotEmpty) {}
      currentSongTitle = songs[index].title;
      currentIndex = index;
    });
  }
}

//duração
class DurationState {
  DurationState({this.position = Duration.zero, this.total = Duration.zero});
  Duration position, total;
}
