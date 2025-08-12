import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../../../../app/widgets/custom_loading_indicator.dart';
import '../../../../core/helpers/toast_helpers/toast_helper.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/interview.dart';
import '../blocs/show_interviews_bloc/show_interviews_bloc.dart';
import 'custom_score_indicator.dart';

class CustomInterviewsList extends StatelessWidget {
  const CustomInterviewsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocConsumer<ShowInterviewsBloc, ShowInterviewsState>(
        listener: (context, state) {
          if (state is ShowInterviewsFailure) {
            ToastHelper.loadingError();
          }
        },
        builder: (context, state) {
          if (state is ShowInterviewsLoading) {
            return CustomLoadingIndicator();
          } else if (state is ShowInterviewsSuccess) {
            if (state.interviews.isEmpty) {
              return Center(
                child: Text(
                  'История пуста',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }
            return ListView.builder(
              itemCount: state.interviews.length,
              itemBuilder: (context, index) {
                final interview = state.interviews[index];
                return _InterviewCard(interview: interview);
              },
            );
          }
          return const SizedBox.shrink();
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
      child: _CustomInterviewCard(
        score: interview.score.toInt(),
        color: interview.isCorrect ? Colors.green : Colors.red,
        titleText: 'Сложность: ${interview.difficulty}',
        firstText: DateFormat('dd/MM/yyyy HH:mm').format(interview.date),
      ),
    );
  }
}

class _CustomInterviewCard extends StatelessWidget {
  final int score;
  final String titleText;
  final String firstText;
  final Color color;

  const _CustomInterviewCard({
    required this.score,
    required this.titleText,
    required this.firstText,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: AppPalette.primary, width: 4.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(20.0),
        leading: ScoreIndicator(score: score, color: color),
        title: Text(titleText, style: Theme.of(context).textTheme.bodyMedium),
        subtitle: Text(firstText, style: Theme.of(context).textTheme.bodySmall),
      ),
    );
  }
}
