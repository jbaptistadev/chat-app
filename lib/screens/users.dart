import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:chat_app/services/services.dart';
import 'package:chat_app/models/models.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final user = authService.user;

    socketService.friendsList.removeWhere(
      (element) => element.id == user.id,
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'login');
              Provider.of<AuthService>(context, listen: false).logOut();
              Provider.of<SocketService>(context, listen: false).disconnect();
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.black87)),
        title: Text(
          user.fullName,
          style: const TextStyle(color: Colors.black87),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Icon(
              Icons.offline_bolt,
              color: socketService.serverStatus == ServerStatus.online
                  ? Colors.blue[400]
                  : Colors.redAccent[400],
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
        child: socketService.onlineUsers.isEmpty
            ? _EmptyList()
            : _ListViewUsers(
                friends: socketService.friendsList,
                usersOnline: socketService.onlineUsers),
      ),
    );
  }

  _loadUsers() async {
    await Provider.of<SocketService>(context, listen: false).getFriends();

    _refreshController.refreshCompleted();
  }
}

class _EmptyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffefffff),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.message,
            size: 160,
            color: Color(0xff34a5d2),
          ),
          Text(
            'No users connected',
            style: TextStyle(
                fontSize: 20,
                color: Colors.black45,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}

class _ListViewUsers extends StatelessWidget {
  const _ListViewUsers({
    required this.friends,
    required this.usersOnline,
  });

  final List<Friend> friends;
  final List<Friend> usersOnline;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, index) {
          final friend = friends[index];
          return _Item(
            user: friend,
            online: usersOnline.any((element) => element.id == friend.id),
          );
        },
        separatorBuilder: (_, index) => const Divider(),
        itemCount: friends.length);
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.user, required this.online});

  final Friend user;
  final bool online;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.userFrom = user;
        chatService.userFrom.online = online;
        Navigator.pushNamed(context, 'chat');
      },
      child: ListTile(
        title: Text(user.fullName),
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(user.fullName.substring(0, 2)),
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: online ? Colors.green[300] : Colors.red[600]),
        ),
      ),
    );
  }
}
