import 'package:flutter/material.dart';
import 'package:chat_app/models/models.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final users = [
    User(
        online: true,
        email: 'jbaptista.dev@gmail.com',
        name: 'jose',
        uiID: 'oaisoaisoais'),
    User(
        online: true,
        email: 'maria@gmail.com',
        name: 'maria',
        uiID: '2342323xxc'),
    User(
        online: false,
        email: 'baprivas.dev@gmail.com',
        name: 'antonio',
        uiID: '232323232'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.exit_to_app, color: Colors.black87)),
        title: const Text(
          'My name',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Icon(
              Icons.offline_bolt,
              color: Colors.blue[400],
            ),
          )
        ],
      ),
      body: SmartRefresher(
        onRefresh: _loadUsers,
        enablePullDown: true,
        controller: _refreshController,
        header: WaterDropHeader(
          complete: Icon(
            Icons.check,
            color: Colors.blue[400],
          ),
          waterDropColor: Colors.blue,
        ),
        child: _ListViewUsers(users: users),
      ),
    );
  }

  _loadUsers() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    _refreshController.refreshCompleted();
  }
}

class _ListViewUsers extends StatelessWidget {
  const _ListViewUsers({
    required this.users,
  });

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, index) {
          return _Item(user: users[index]);
        },
        separatorBuilder: (_, index) => const Divider(),
        itemCount: users.length);
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(user.name.substring(0, 2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: user.online ? Colors.green[300] : Colors.red[600]),
      ),
    );
  }
}
