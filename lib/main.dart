import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/constants/styling.dart';
import 'package:music_player/screens/circular.dart';
import 'package:music_player/screens/playlist.dart';
import 'package:music_player/screens/reprodutor.dart';
import 'package:music_player/screens/test.dart';
import 'screens/migration.dart';

void main() {
  WidgetsFlutterBinding?.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);
  runApp(AdazzioApp());
}

class AdazzioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.adazzioTheme,
      home: Playlist(),
    );
  }
}
