import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const Image(
            image: AssetImage('assets/chat-icon-animation-huge.gif'),
            width: 200,
            height: 200,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              title,
              style: const TextStyle(
                  fontSize: 25,
                  color: Color(0xff34a5d2),
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}
