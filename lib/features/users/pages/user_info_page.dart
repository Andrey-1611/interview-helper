import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/core/constants/questions/icons.dart';
import 'package:interview_master/core/utils/filter_user_cubit/filter_cubit.dart';
import 'package:interview_master/features/users/use_cases/get_user_use_case.dart';
import '../../../data/models/user/user_data.dart';
import '../blocs/get_user_bloc/get_user_bloc.dart';

class UserInfoPage extends StatefulWidget {
  final UserData? user;

  const UserInfoPage({super.key, this.user});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final _filterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetUserBloc(GetIt.I<GetUserUseCase>())
            ..add(GetUser(userData: widget.user)),
      child: BlocBuilder<GetUserBloc, GetUserState>(
        builder: (context, state) {
          if (state is GetUserSuccess) {
            return _UserInfoPageView(
              user: state.user,
              filterController: _filterController,
            );
          }
          return CustomLoadingIndicator();
        },
      ),
    );
  }
}

class _UserInfoPageView extends StatelessWidget {
  final TextEditingController filterController;
  final UserData user;

  const _UserInfoPageView({required this.user, required this.filterController});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FilterUserCubit>().state;
    final data = UserData.getStatsInfo(
      UserData.filterUser(state.direction, state.difficulty, user),
    );
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _StatsCard(text: data[index], icon: icons[index]);
        },
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
