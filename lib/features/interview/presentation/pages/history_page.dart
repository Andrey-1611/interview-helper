import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/core/global_services/notifications/services/notifications_service.dart';
import 'package:intl/intl.dart';
import '../../../../app/navigation/app_router_names.dart';
import '../../../../core/global_services/notifications/blocs/send_notification_bloc/send_notification_bloc.dart';
import '../../../../core/global_services/notifications/models/notification.dart';
import '../../../../core/global_services/user/blocs/get_user_bloc/get_user_bloc.dart';
import '../../../../core/global_services/user/services/user_interface.dart';
import '../../blocs/show_interviews_bloc/show_interviews_bloc.dart';
import '../../data/data_sources/firestore_data_source.dart';
import '../../data/models/interview.dart';
import '../widgets/custom_interview_card.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              GetUserBloc(context.read<UserInterface>())..add(GetUser()),
        ),
        BlocProvider(
          create: (context) => ShowInterviewsBloc(
            FirestoreDataSource(firebaseFirestore: FirebaseFirestore.instance),
          ),
        ),
        BlocProvider(
          create: (context) => SendNotificationBloc(NotificationsService()),
        ),
      ],
      child: _HistoryList(),
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GetUserBloc, GetUserState>(
          listener: (context, state) {
            if (state is GetUserSuccess) {
              context.read<ShowInterviewsBloc>().add(
                ShowInterviews(userId: state.userProfile.id ?? ''),
              );
            }
            if (state is GetUserNotAuth || state is GetUserFailure) {
              _errorMove(context);
            }
          },
        ),
        BlocListener<ShowInterviewsBloc, ShowInterviewsState>(
          listener: (context, state) {
            if (state is ShowInterviewsFailure) {
              _errorMove(context);
            }
          },
        ),
      ],
      child: _HistoryListView(),
    );
  }

  void _errorMove(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRouterNames.splash);
    context.read<SendNotificationBloc>().add(
      _sendNotification('Ошибка получения данных', Icon(Icons.error)),
    );
  }

  SendNotification _sendNotification(String text, Icon icon) {
    return SendNotification(
      notification: MyNotification(text: text, icon: icon),
    );
  }
}

class _HistoryListView extends StatelessWidget {
  const _HistoryListView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShowInterviewsBloc, ShowInterviewsState>(
      builder: (context, state) {
        if (state is ShowInterviewsSuccess) {
          if (state.interviews.isEmpty) {
            return const Center(child: Text('История пуста'));
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: state.interviews.length,
              itemBuilder: (context, index) {
                final interview = state.interviews[index];
                return _InterviewCard(interview: interview);
              },
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
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
        Navigator.pushNamed(
          context,
          AppRouterNames.interviewInfo,
          arguments: interview,
        );
      },
      child: CustomInterviewCard(
        score: interview.score.toInt(),
        titleText: 'Сложность: ${_chooseDifficulty(interview.difficulty)}',
        firstText: DateFormat('dd/MM/yyyy HH:mm').format(interview.date),
        titleStyle: Theme.of(context).textTheme.bodyMedium,
        subtitleStyle: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  String _chooseDifficulty(int difficult) {
    String difficultly = '';
    switch (difficult) {
      case 1:
        difficultly = 'Junior';
      case 2:
        difficultly = 'Middle';
      case 3:
        difficultly = 'Senior';
    }
    return difficultly;
  }
}
