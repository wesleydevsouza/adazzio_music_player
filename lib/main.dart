import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/constants/styling.dart';
import 'components/routes.dart';

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
      title: 'Adazzio',
      theme: AppTheme.adazzioTheme,
      initialRoute: '/test',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
