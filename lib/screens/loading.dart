import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/services/services.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return const Center(
            child: Text('Loading'),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);

    final isLogged = await authService.isLoggedIn();

    final route = isLogged ? 'users' : 'login';

    if (route == 'users') {
      socketService.connect();
    } else {
      socketService.disconnect();
    }

    if (!context.mounted) return;

    Navigator.pushReplacementNamed(context, route);
  }
}
