import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/screens/reprodutor.dart';
import 'components/theme.dart';


void main() {
  WidgetsFlutterBinding?.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(BytebankApp());

}



class BytebankApp extends StatelessWidget {


  @override

  Widget build(BuildContext context) {

    return MaterialApp(
      theme: bytebankTheme,
      home: Reprodutor(),
    );
  }
}
