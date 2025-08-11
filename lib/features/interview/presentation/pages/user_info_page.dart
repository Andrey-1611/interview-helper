import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/app/dependencies/di_container.dart';
import 'package:interview_master/app/global_services/user/data/models/user_data.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/core/helpers/toast_helpers/toast_helper.dart';
import 'package:interview_master/features/interview/presentation/blocs/show_interviews_bloc/show_interviews_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../app/navigation/app_router.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../../data/models/interview.dart';
import '../widgets/custom_interview_card.dart';

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
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(user.name, style: Theme.of(context).textTheme.displayMedium),
            Expanded(child: _InterviewsList(interviews: user.interviews)),
          ],
        ),
      ),
    );
  }
}

class _InterviewsList extends StatelessWidget {
  final List<Interview> interviews;

  const _InterviewsList({required this.interviews});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShowInterviewsBloc, ShowInterviewsState>(
      listener: (context, state) {
        if (state is ShowInterviewsFailure) {
          ToastHelper.loadingError();
        }
      },
      builder: (context, state) {
        if (state is ShowInterviewsLoading) {
          return CustomLoadingIndicator();
        } else if (state is ShowInterviewsSuccess) {
          return _InterviewsListView(interviews: state.interviews);
        }
        return SizedBox.shrink();
      },
    );
  }
}

class _InterviewsListView extends StatelessWidget {
  final List<Interview> interviews;

  const _InterviewsListView({required this.interviews});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: interviews.length,
        itemBuilder: (context, index) {
          if (interviews.isNotEmpty) {
            final interview = interviews[index];
            return _InterviewCard(interview: interview);
          }
          return Text('История пуста');
        },
      ),
    );
  }
}

class _InterviewCard extends StatelessWidget {
  final Interview interview;

  const _InterviewCard({required this.interview});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRouter.pushNamed(AppRouterNames.interviewInfo, arguments: interview);
      },
      child: CustomInterviewCard(
        score: interview.score,
        titleText: 'Сложность: ${interview.difficulty}',
        firstText: DateFormat('dd/MM/yyyy HH:mm').format(interview.date),
        titleStyle: Theme.of(context).textTheme.bodyMedium,
        subtitleStyle: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

}
