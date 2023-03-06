import 'package:flutter/material.dart';

import '../constants/styling.dart';

class AddazButton extends ElevatedButton {
  const AddazButton(this.icone, this.tamanho, this.onPress, {Key? key})
      : super(key: key, child: const InkWell(), onPressed: onPress);

  final void Function()? onPress;

  final IconData icone;
  final double tamanho;

  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        elevation: 0,
        shape: const CircleBorder(),
      ),
      child: InkWell(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1000),
          ),
          child: Icon(icone, size: tamanho),
          color: AppTheme.corFonte,
        ),
      ),
    );
  }
}
