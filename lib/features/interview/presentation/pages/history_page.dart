import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../app/navigation/app_router.dart';
import '../../../../core/global_services/user/blocs/get_user_bloc/get_user_bloc.dart';
import '../../../../core/global_services/user/services/user_interface.dart';
import '../../blocs/show_interviews_bloc/show_interviews_bloc.dart';
import '../../data/data_sources/firestore_data_source.dart';
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
      create: (context) =>
          GetUserBloc(context.read<UserInterface>())..add(GetUser()),
      child: BlocConsumer<GetUserBloc, GetUserState>(
        listener: (context, state) {
          if (state is GetUserNotAuth || state is GetUserFailure) {
            Navigator.pushReplacementNamed(context, AppRouterNames.splash);
          }
        },
        builder: (context, state) {
          if (state is GetUserSuccess) {
            final userId = state.userProfile.id ?? '';
            return BlocProvider(
              create: (context) => ShowInterviewsBloc(
                FirestoreDataSource(
                  FirebaseFirestore.instance,
                  userId: userId,
                ),
              )..add(ShowInterviews()),
              child: const _HistoryView(),
            );
          } else if (state is GetUserFailure) {
            return Center(
              child: Text(
                'На сервере ведутся работы \nПожалуйста попробуйте позже',
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _HistoryView extends StatelessWidget {
  const _HistoryView();

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
            return Center(child: Text('История пуста'));
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
                    Navigator.pushNamed(
                      context,
                      AppRouterNames.interviewInfo,
                      arguments: interview,
                    );
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
