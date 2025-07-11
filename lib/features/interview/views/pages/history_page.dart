import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../app/navigation/app_router.dart';
import '../../blocs/show_interviews_bloc/show_interviews_bloc.dart';
import '../../data/data_sources/firebase_firestore_data_sources/firebase_firestore_data_source.dart';
import '../widgets/custom_interview_card.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              ShowInterviewsBloc(FirebaseFirestoreDataSource())..add(ShowInterviews()),
      child: _HistoryView(),
    );
  }
}

class _HistoryView extends StatelessWidget {
  const _HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShowInterviewsBloc, ShowInterviewsState>(
      builder: (context, state) {
        if (state is ShowInterviewsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ShowInterviewsFailure) {
          return Center(
            child: Text(
              'На сервере ведутся работы \nПожалуйста попробуйте позже',
            ),
          );
        } else if (state is ShowInterviewsSuccess) {
          if (state.interviews.isEmpty) {
            return Center(
              child: Text(
                'История пуста',
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: state.interviews.length,
              itemBuilder: (context, index) {
                final interview = state.interviews[index];
                final difficult = interview.difficulty;
                String difficultly = '';
                switch (difficult) {
                  case 1:
                    difficultly = 'Junior';
                  case 2:
                    difficultly = 'Middle';
                  case 3:
                    difficultly = 'Senior';
                }
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRouterNames.interviewInfo, arguments: interview);
                  },
                  child: CustomInterviewCard(
                    score: interview.score.toInt(),
                    titleText: 'Сложность: $difficultly',
                    firstText: DateFormat(
                      'dd/MM/yyyy HH:mm',
                    ).format(interview.date),
                    titleStyle: Theme.of(context).textTheme.bodyMedium,
                    subtitleStyle: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              },
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
