import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  const Labels({super.key, required this.route});

  final String route;

  @override
  Widget build(BuildContext context) {
    bool isRegisterRoute = route == 'register';

    return Column(
      children: [
        Text(
          isRegisterRoute
              ? 'Do you not have a account?'
              : 'Do you have a account?',
          style: const TextStyle(
              color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300),
        ),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(
              context, isRegisterRoute ? route : 'login'),
          child: Text(
            isRegisterRoute ? 'create account now!' : 'Login now!',
            style: const TextStyle(
                color: Color(0xff34a5d2), fontWeight: FontWeight.w600),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            'terms and conditions',
            style: TextStyle(fontWeight: FontWeight.w200),
          ),
        )
      ],
    );
  }
}
