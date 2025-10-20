import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/core/utils/filter_user_cubit/filter_favourite_cubit.dart';
import 'package:interview_master/core/utils/filter_user_cubit/filter_cubit.dart';
import 'package:interview_master/data/models/interview/question.dart';
import 'package:interview_master/features/history/blocs/history_bloc/history_bloc.dart';
import '../../../../app/widgets/custom_loading_indicator.dart';
import '../../../app/widgets/custom_question_card.dart';
import '../../users/widgets/custom_network_failure.dart';
import '../widgets/custom_empty_filter_history.dart';
import '../widgets/custom_empty_history.dart';

class QuestionsHistoryPage extends StatelessWidget {
  final TextEditingController filterController;
  final bool isCurrentUser;

  const QuestionsHistoryPage({
    super.key,
    required this.filterController,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        if (state is HistoryNetworkFailure) {
          return CustomNetworkFailure();
        } else if (state is HistorySuccess) {
          if (state.interviews.isEmpty) {
            return CustomEmptyHistory(isCurrentUser: isCurrentUser);
          }
          final filterState = context.watch<FilterUserCubit>().state;
          final isFavourite = context.watch<FilterFavouriteCubit>().state;
          final questions = Question.filterQuestions(
            filterState.direction,
            filterState.difficulty,
            filterState.sort,
            isFavourite,
            state.interviews,
          );
          if (questions.isEmpty) {
            return CustomEmptyFilterHistory(filterController: filterController);
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return CustomQuestionCard(
                  question: questions[index],
                  isCurrentUser: isCurrentUser,
                );
              },
            ),
          );
        }
        return CustomLoadingIndicator();
      },
    );
  }
}
