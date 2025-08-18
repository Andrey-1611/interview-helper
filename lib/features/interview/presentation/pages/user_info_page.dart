import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/app/dependencies/di_container.dart';
import 'package:interview_master/features/interview/presentation/blocs/show_interviews_bloc/show_interviews_bloc.dart';
import 'package:interview_master/features/interview/presentation/pages/interview_info_page.dart';
import 'package:interview_master/features/interview/presentation/widgets/custom_interviews_list.dart';
import '../../../../app/global_services/user/models/user_data.dart';
import '../../data/models/interview_info.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  late final UserData user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = ModalRoute.of(context)?.settings.arguments as UserData;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ShowInterviewsBloc(DIContainer.showInterviews)
            ..add(ShowInterviews(userId: user.id)),
      child: _UserInfoPageView(user: user),
    );
  }
}

class _UserInfoPageView extends StatelessWidget {
  final UserData user;

  const _UserInfoPageView({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(user.name, style: Theme.of(context).textTheme.displayMedium),
            Expanded(
              child: CustomInterviewsList(
                interviewInfo: InterviewInfo(
                  direction: '',
                  difficultly: '',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
