import 'package:flutter/material.dart';

import '../constants/styling.dart';

class AddazButton extends StatelessWidget {
  const AddazButton(
      {Key? key,
      required this.onPress,
      required this.icone,
      required this.tamanho})
      : super(key: key);

  final void Function() onPress;
  final IconData icone;
  final double tamanho;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        elevation: 0,
        shape: const CircleBorder(),
      ),
      child: Ink(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: InkWell(
          onTap: onPress,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(
              icone,
              size: tamanho,
              color: AppTheme.corFonte,
            ),
          ),
        ),
      ),
    );
  }
}
