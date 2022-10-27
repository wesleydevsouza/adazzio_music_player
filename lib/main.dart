import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/screens/circular.dart';
import 'package:music_player/screens/playlist.dart';
import 'package:music_player/screens/test.dart';
import 'components/theme.dart';

void main() {
  WidgetsFlutterBinding?.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);
  runApp(BytebankApp());
}

class BytebankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: adazzioTheme,
      home: TestingApp(
        title: 'Juuj',
      ),
    );
  }
}
