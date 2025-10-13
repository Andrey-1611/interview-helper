import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_pallete.dart';
import '../../data/models/interview/question.dart';
import '../../features/history/blocs/change_is_favourite_bloc/change_is_favourite_bloc.dart';
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
    return GestureDetector(
      onTap: () => context.push(AppRouterNames.questionInfo, extra: question),
      child: Card(
        child: ListTile(
          leading: CustomScoreIndicator(score: question.score),
          title: Text('Вопрос ${question.question}'),
          trailing: isCurrentUser
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: IconButton(
                    onPressed: () {
                      context.read<ChangeIsFavouriteBloc>().add(
                        ChangeIsFavouriteQuestion(id: question.id),
                      );
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: question.isFavourite
                          ? AppPalette.error
                          : AppPalette.textSecondary,
                    ),
                  ),
                )
              : Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
