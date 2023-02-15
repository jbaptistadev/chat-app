import 'package:flutter/material.dart';
import 'package:chat_app/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffefffff),
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Logo(title: 'Messenger'),
                _Form(),
                Labels(
                  route: 'register',
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form();

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          Input(
              icon: Icons.mail_outline,
              placeholder: 'Email',
              keyboardType: TextInputType.emailAddress,
              textController: emailController),
          Input(
              icon: Icons.lock_outline,
              placeholder: 'Password',
              isPassword: true,
              textController: passwordController),
          Button(
              onPress: () {
                print(emailController.text);
                print(passwordController.text);
              },
              text: 'Sign in')
        ],
      ),
    );
  }
}
