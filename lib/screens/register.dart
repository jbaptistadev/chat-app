import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:chat_app/helpers/show_alert.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffefffff),
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Logo(title: 'Register'),
                _Form(),
                Labels(
                  route: 'login',
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
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          Input(
              icon: Icons.mail_outline,
              placeholder: 'Name',
              keyboardType: TextInputType.text,
              textController: nameController),
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

                      final isSuccess =
                          await Provider.of<AuthService>(context, listen: false)
                              .register(
                                  nameController.text,
                                  emailController.text,
                                  passwordController.text);

                      if (isSuccess == true) {
                        Navigator.pushReplacementNamed(context, 'users');
                      } else {
                        showAlert(context, isSuccess.toString(),
                            isSuccess.toString());
                      }
                    },
              text: 'Sign Up')
        ],
      ),
    );
  }
}
