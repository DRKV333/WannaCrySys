import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final bool isLoading;
  final String text;
  final Color? buttonColor;
  final Color? progressIndicatorColor;
  final Function()? onPressed;

  const CircularButton(
      {Key? key,
      required this.isLoading,
      required this.text,
      this.buttonColor,
      this.progressIndicatorColor,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        margin: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          style: buttonColor != null
              ? ElevatedButton.styleFrom(primary: buttonColor)
              : null,
          onPressed: onPressed,
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      color: progressIndicatorColor ?? Colors.black))
              : Text(text),
        ),
      );
}
