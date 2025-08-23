import 'package:flutter/material.dart';
import 'package:interview_master/core/constants/questions/icons.dart';
import '../../../../app/global/models/user_data.dart';

class UserInfoMainPage extends StatefulWidget {
  final UserData user;

  const UserInfoMainPage({super.key, required this.user});

  @override
  State<UserInfoMainPage> createState() => _UserInfoMainPageState();
}

class _UserInfoMainPageState extends State<UserInfoMainPage> {
  @override
  Widget build(BuildContext context) {
    final data = UserData.getStatsInfo(widget.user);
    return Center(
      child: Column(
        children: [
          _NameCard(name: widget.user.name),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return _StatsCard(text: data[index], icon: icons[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NameCard extends StatelessWidget {
  final String name;

  const _NameCard({required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Card(
        child: ListTile(
          title: Center(
            child: Text(name, style: Theme.of(context).textTheme.displayLarge),
          ),
        ),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final String text;
  final IconData icon;

  const _StatsCard({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        child: ListTile(
          leading: Icon(icon),
          title: Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ),
    );
  }
}
