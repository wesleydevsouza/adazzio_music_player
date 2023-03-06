// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color corFonte = Colors.white;
  static const Color corFonteProgress = Colors.white70;
  static const Color corSombra = Colors.white24;
  static const Color corSombraEscura = Colors.black;
  static const Color corDestaque = Colors.purpleAccent;

  static const Color corScaffold = Color(0xFF2c0824);
  static const Color corCirculo = Color(0xfff306c4);
  static const Color corProgresso = Color(0xff584add);
  static const Color GradientCardShadow = Color(0xffbf2aa2);
  static const Color bgColor = Color(0xFF110a29);

  static const List<Color> GradientBG = [Color(0xFF110a29), Color(0xFF2f0823)];
  static const List<Color> GradientCard = [
    Color(0xff9e2186),
    Color(0xff4f0f41)
  ];
  static const List<Color> GradientButton = [
    Color(0xff6d38e5),
    Color(0xffb235d7),
    Color(0xffff37d8),
    Color(0xffff37d8)
  ];

  static final TextTheme lightTextTheme = TextTheme(
    headline1: _tituloTopo,
    subtitle1: _subTitulo,
    subtitle2: _subTitulo2,
    bodyText1: _textoGeral,
    // headline2: _titulo2Light,
    // button: _botaoLight,
    // headline4: _textfieldLight,
    // headline3: _texto1Light,
    // bodyText2: _texto2Light,
    // headline5: _botaoDialogLight
  );

  static final ThemeData adazzioTheme = ThemeData(
    scaffoldBackgroundColor: AppTheme.corScaffold,
    textTheme: lightTextTheme,
    errorColor: corFonte,
    canvasColor: corScaffold,
  );

  // ignore: prefer_const_constructors
  static final TextStyle _tituloTopo = GoogleFonts.roboto(
    color: corFonte,
    fontWeight: FontWeight.bold,
    letterSpacing: 2,
    fontSize: 20,
  );

  static final TextStyle _subTitulo = GoogleFonts.poiretOne(
    color: corFonte,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  static final TextStyle _subTitulo2 = GoogleFonts.poiretOne(
    color: corFonte,
    fontWeight: FontWeight.bold,
    fontSize: 20,
    letterSpacing: 2,
  );

  static final TextStyle _textoGeral = GoogleFonts.roboto(
    color: corFonteProgress,
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );

  static double largAlbum = 300;
  static double altAlbum = 300;
  
  

  static BoxDecoration getDecoration(
      BoxShape shape, Offset offset, double blurRadius, double spreadRadius) {
    return BoxDecoration(
      color: AppTheme.bgColor,
      shape: shape,
      boxShadow: [
        BoxShadow(
          offset: -offset,
          color: AppTheme.corSombra,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        ),
        BoxShadow(
          offset: offset,
          color: AppTheme.corSombraEscura,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        )
      ],
    );
  }
}
