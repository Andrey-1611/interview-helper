import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/core/constants/questions/icons.dart';
import 'package:interview_master/features/users/use_cases/get_user_use_case.dart';
import '../../../data/models/user/user_data.dart';
import '../blocs/get_user_bloc/get_user_bloc.dart';

class UserProfilePage extends StatelessWidget {
  final UserData? user;

  const UserProfilePage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetUserBloc(GetIt.I<GetUserUseCase>())..add(GetUser(userData: user)),
      child: BlocBuilder<GetUserBloc, GetUserState>(
        builder: (context, state) {
          if (state is GetUserSuccess) {
            return _UserProfilePageView(user: state.user);
          }
          return CustomLoadingIndicator();
        },
      ),
    );
  }
}

class _UserProfilePageView extends StatefulWidget {
  final UserData user;

  const _UserProfilePageView({required this.user});

  @override
  State<_UserProfilePageView> createState() => _UserProfilePageViewState();
}

class _UserProfilePageViewState extends State<_UserProfilePageView> {
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
