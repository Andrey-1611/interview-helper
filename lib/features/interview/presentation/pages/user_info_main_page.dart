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
    return Center(child: Text(widget.user.name));
  }
}
