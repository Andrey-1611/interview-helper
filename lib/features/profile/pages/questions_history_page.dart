import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/data/models/question.dart';
import 'package:interview_master/data/models/user_data.dart';
import 'package:interview_master/features/profile/blocs/profile_bloc/profile_bloc.dart';
import '../../../../app/widgets/custom_loading_indicator.dart';
import '../../../app/widgets/custom_question_card.dart';
import '../../../app/widgets/custom_network_failure.dart';
import '../../../app/widgets/custom_unknown_failure.dart';
import '../blocs/filter_profile_cubit/filter_profile_cubit.dart';
import '../widgets/custom_empty_filter_history.dart';
import '../widgets/custom_empty_history.dart';

class QuestionsHistoryPage extends StatelessWidget {
  final UserData? user;

  const QuestionsHistoryPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isCurrentUser = user == null;
    final onPressed = context.read<ProfileBloc>().add(
      GetProfile(userId: user?.id),
    );
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileNetworkFailure) {
          return CustomNetworkFailure(onPressed: () => onPressed);
        } else if (state is ProfileFailure) {
          return CustomUnknownFailure(onPressed: () => onPressed);
        } else if (state is ProfileSuccess) {
          if (state.interviews.isEmpty) {
            return CustomEmptyHistory(isCurrentUser: isCurrentUser);
          }
          final filter = context.watch<FilterProfileCubit>();
          final questions = Question.filterQuestions(
            filter.state.direction,
            filter.state.difficulty,
            filter.state.sort,
            filter.state.isFavourite,
            state.interviews,
          );
          if (questions.isEmpty) {
            return CustomEmptyFilterHistory();
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
