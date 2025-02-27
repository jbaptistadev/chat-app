import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/services/services.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:chat_app/helpers/show_alert.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffefffff),
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
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
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context, listen: false);
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
              onPress: authService.isAuthenticating
                  ? null
                  : () async {
                      FocusNode().unfocus();

                      final isSuccess = await Provider.of<AuthService>(context,
                              listen: false)
                          .login(emailController.text, passwordController.text);

                      if (isSuccess == true) {
                        socketService.connect();
                        Navigator.pushReplacementNamed(context, 'users');
                      } else {
                        showAlert(context, isSuccess.toString(),
                            isSuccess.toString());
                      }
                    },
              text: 'Sign in')
        ],
      ),
    );
  }
}
