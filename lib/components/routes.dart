// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:music_player/screens/playlist.dart';
import 'package:music_player/screens/reprodutor.dart';
import 'package:music_player/screens/test.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/playlist':
        return MaterialPageRoute(
          builder: (context) => Playlist(),
        );

      case '/player':
        return MaterialPageRoute(
          builder: (context) => Reprodutor(),
        );

      case '/test':
        return MaterialPageRoute(
          builder: (context) => TestingApp(
            title: 'test',
          ),
        );

      default:
        return MaterialPageRoute(builder: (context) => Playlist());
    }
  }
}
