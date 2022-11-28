import 'package:flutter/material.dart';

class GreatBoldText extends StatelessWidget {
  final String text;

  const GreatBoldText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
      );
}
