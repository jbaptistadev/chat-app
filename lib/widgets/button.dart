import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({super.key, required this.onPress, required this.text});

  final void Function()? onPress;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPress,
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(2),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
        ),
        child: Container(
          width: double.infinity,
          height: 55,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 17),
            ),
          ),
        ));
  }
}
