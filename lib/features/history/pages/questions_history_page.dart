import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/app/widgets/custom_question_card.dart';
import 'package:interview_master/core/utils/filter_user_cubit/filter_cubit.dart';
import 'package:interview_master/data/models/interview/question.dart';
import 'package:interview_master/features/history/use_cases/show_interviews_use_case.dart';
import '../../../../app/router/app_router_names.dart';
import '../../../../app/widgets/custom_loading_indicator.dart';
import '../../../../core/helpers/toast_helper.dart';
import '../../users/widgets/custom_network_failure.dart';
import '../blocs/show_interviews_bloc/show_interviews_bloc.dart';

class QuestionsHistoryPage extends StatelessWidget {
  final String? userId;
  final TextEditingController filterController;

  const QuestionsHistoryPage({
    super.key,
    this.userId,
    required this.filterController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ShowInterviewsBloc(GetIt.I<ShowInterviewsUseCase>())
            ..add(ShowInterviews(userId: userId)),
      child: _QuestionsList(filterController: filterController),
    );
  }
}

class _QuestionsList extends StatelessWidget {
  final TextEditingController filterController;

  const _QuestionsList({required this.filterController});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShowInterviewsBloc, ShowInterviewsState>(
      listener: (context, state) {
        if (state is ShowInterviewsFailure) {
          ToastHelper.loadingError();
        }
      },
      builder: (context, state) {
        if (state is ShowInterviewsNetworkFailure) {
          return NetworkFailure();
        } else if (state is ShowInterviewsSuccess) {
          if (state.interviews.isEmpty) return _EmptyHistory();
          final filterState = context.watch<FilterUserCubit>().state;
          final questions = Question.filterQuestions(
            filterState.direction,
            filterState.difficulty,
            filterState.sort,
            state.interviews,
          );
          if (questions.isEmpty) {
            return _EmptyFilterHistory(filterController: filterController);
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return CustomQuestionCard(question: questions[index]);
              },
            ),
          );
        }
        return CustomLoadingIndicator();
      },
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'История пуста',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          TextButton(
            onPressed: () {
              StatefulNavigationShell.of(context).goBranch(0);
              context.push(AppRouterNames.initial);
            },
            child: Text('Пройти собеседование'),
          ),
        ],
      ),
    );
  }
}

class _EmptyFilterHistory extends StatelessWidget {
  final TextEditingController filterController;

  const _EmptyFilterHistory({required this.filterController});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'История пуста',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          TextButton(
            onPressed: () {
              context.read<FilterUserCubit>().resetUser();
              filterController.clear();
            },
            child: Text('Сбросить фильтр'),
          ),
        ],
      ),
    );
  }
}
