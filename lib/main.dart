import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/constants/styling.dart';
import 'components/routes.dart';

void main() {
  WidgetsFlutterBinding?.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);
  runApp(const AdazzioApp());
}

class AdazzioApp extends StatelessWidget {
  const AdazzioApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adazzio',
      theme: AppTheme.adazzioTheme,
      initialRoute: '/playlist',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
