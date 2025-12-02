import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/features/profile/blocs/profile_bloc/profile_bloc.dart';
import '../../data/models/question.dart';
import '../router/app_router_names.dart';
import 'custom_score_indicator.dart';

class CustomQuestionCard extends StatelessWidget {
  final Question question;
  final bool isCurrentUser;

  const CustomQuestionCard({
    super.key,
    required this.question,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => context.push(AppRouterNames.questionInfo, extra: question),
      child: Card(
        child: ListTile(
          leading: CustomScoreIndicator(score: question.score),
          title: Text(question.question),
          trailing: isCurrentUser
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: IconButton(
                    onPressed: () {
                      context.read<ProfileBloc>().add(
                        ChangeIsFavouriteQuestion(questionId: question.id),
                      );
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: question.isFavourite
                          ? theme.colorScheme.error
                          : theme.hintColor,
                    ),
                  ),
                )
              : Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
