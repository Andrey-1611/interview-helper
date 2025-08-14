import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/interview/presentation/widgets/custom_interviews_list.dart';
import '../../../../app/dependencies/di_container.dart';
import '../../../../app/global_services/user/blocs/get_user_bloc/get_user_bloc.dart';
import '../../../../core/helpers/toast_helpers/toast_helper.dart';
import '../blocs/show_interviews_bloc/show_interviews_bloc.dart';

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
          create: (context) => GetUserBloc(DIContainer.getUser)..add(GetUser()),
        ),
        BlocProvider(
          create: (context) => ShowInterviewsBloc(DIContainer.showInterviews),
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
    return BlocListener<GetUserBloc, GetUserState>(
      listener: (context, state) {
        if (state is GetUserSuccess) {
          context.read<ShowInterviewsBloc>().add(
            ShowInterviews(userId: state.user.id!),
          );
        } else if (state is GetUserFailure) {
          ToastHelper.unknownError();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomInterviewsList(),
      ),
    );
  }
}
