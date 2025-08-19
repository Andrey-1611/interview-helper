import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/core/helpers/dialog_helpers/dialog_helper.dart';
import 'package:interview_master/features/interview/data/models/interview_info.dart';
import 'package:interview_master/features/interview/presentation/widgets/custom_filter_dialog.dart';
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
  String direction = '';
  String difficultly = '';

  final TextEditingController _filterController = TextEditingController();

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

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
      child: _HistoryList(
        direction: direction,
        difficultly: difficultly,
        changeDirection: _changeDirection,
        changeDifficultly: _changeDifficultly,
        filterController: _filterController,
      ),
    );
  }

  void _updateFilterText() {
    _filterController.text = InterviewInfo.textInFilter(
      InterviewInfo(direction: direction, difficultly: difficultly),
    );
  }

  void _changeDirection(String value) {
    setState(() {
      direction = value;
      _updateFilterText();
    });
  }

  void _changeDifficultly(String value) {
    setState(() {
      difficultly = value;
      _updateFilterText();
    });
  }
}

class _HistoryList extends StatelessWidget {
  final String difficultly;
  final String direction;
  final ValueChanged<String> changeDirection;
  final ValueChanged<String> changeDifficultly;
  final TextEditingController filterController;

  const _HistoryList({
    required this.direction,
    required this.difficultly,
    required this.changeDirection,
    required this.changeDifficultly,
    required this.filterController,
  });

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
        child: Stack(
          children: [
            CustomInterviewsList(
              interviewInfo: InterviewInfo(
                direction: direction,
                difficultly: difficultly,
              ),
            ),
            _FilterButton(
              difficultly: difficultly,
              direction: direction,
              changeDirection: changeDirection,
              changeDifficultly: changeDifficultly,
              filterController: filterController,
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String difficultly;
  final String direction;
  final ValueChanged<String> changeDirection;
  final ValueChanged<String> changeDifficultly;
  final TextEditingController filterController;

  const _FilterButton({
    required this.difficultly,
    required this.direction,
    required this.changeDirection,
    required this.changeDifficultly,
    required this.filterController,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      controller: filterController,
      onTap: () => DialogHelper.showCustomDialog(
        context,
        CustomFilterDialog(
          difficulty: difficultly,
          direction: direction,
          changeDirection: changeDirection,
          changeDifficultly: changeDifficultly,
        ),
      ),
      decoration: InputDecoration(
        hintText: 'Фильтр',
        prefixIcon: Icon(Icons.search),
        suffixIcon: IconButton(
          onPressed: () {
            changeDirection('');
            changeDifficultly('');
          },
          icon: Icon(Icons.close),
        ),
      ),
    );
  }
}
