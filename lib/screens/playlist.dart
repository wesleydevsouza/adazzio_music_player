import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/constants/styling.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Playlist extends StatefulWidget {
  const Playlist({Key? key}) : super(key: key);

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  //Player
  final AudioPlayer _player = AudioPlayer();
  bool isPlayerViewVisible = false;

  //Playlist
  List<SongModel> songs = [];
  String currentSongTitle = '';
  int currentIndex = 0;
  final OnAudioQuery _audioQuery = OnAudioQuery();

  //Player
  void _changePlayerViewVisibility() {
    setState(() {
      isPlayerViewVisible = !isPlayerViewVisible;
    });
  }

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
  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, item) {      
          if (item.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (item.data!.isEmpty) {
            return const Center(
              child: Text("No Songs Found"),
            );
          }
          // You can use [item.data!] direct or you can create a list of songs as
          // List<SongModel> songs = item.data!;
          //showing the songs
          songs.clear();
          songs = item.data!;
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: AppTheme.GradientBG,
              ),
            ),
            child: ListView.builder(
                itemCount: item.data!.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin:
                        const EdgeInsets.only(top: 12.0, left: 8.0, right: 8.0),
                    padding: const EdgeInsets.only(top: 7.0, bottom: 8.0),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: AppTheme.GradientCard,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4.0,
                          offset: const Offset(6, 6),
                          color: AppTheme.GradientCardShadow.withOpacity(0.9),
                        ),
                      ],
                    ),
                    child: ListTile(
                      textColor: AppTheme.corFonte,
                      title: Text(item.data![index].title),
                      subtitle: Text(item.data![index].fileExtension),
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
                }),
          );
        },
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
