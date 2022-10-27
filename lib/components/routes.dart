import 'package:flutter/material.dart';
import 'package:music_player/screens/playlist.dart';
import 'package:music_player/screens/reprodutor.dart';

//Playlist
_showPlaylist(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => Playlist(),
    ),
  );
}

_showPlayer(BuildContext context) {
  Navigator.of(context).push(

    MaterialPageRoute(
      builder: (context) => Reprodutor(),
    ),
  );
}