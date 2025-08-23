import 'package:flutter/material.dart';
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
          _StatsCard(
            text: widget.user.name,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return _StatsCard(text: data[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const _StatsCard({required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Center(
          child: Text(
            text,
            style: style ?? Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
