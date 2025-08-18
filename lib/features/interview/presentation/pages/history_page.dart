import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/app/navigation/app_router.dart';
import 'package:interview_master/core/helpers/dialog_helpers/dialog_helper.dart';
import 'package:interview_master/core/theme/app_pallete.dart';
import 'package:interview_master/features/interview/data/models/interview_info.dart';
import 'package:interview_master/features/interview/presentation/widgets/custom_button.dart';
import 'package:interview_master/features/interview/presentation/widgets/custom_interviews_list.dart';
import '../../../../app/dependencies/di_container.dart';
import '../../../../app/global_services/user/blocs/get_user_bloc/get_user_bloc.dart';
import '../../../../core/constants/directions.dart';
import '../../../../core/helpers/toast_helpers/toast_helper.dart';
import '../blocs/show_interviews_bloc/show_interviews_bloc.dart';
import '../widgets/custom_dropdown_menu.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String direction = '';
  String difficultly = '';

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
      ),
    );
  }

  void _changeDirection(String value) {
    setState(() {
      direction = value;
    });
  }

  void _changeDifficultly(String value) {
    setState(() {
      difficultly = value;
    });
  }
}

class _HistoryList extends StatelessWidget {
  final String difficultly;
  final String direction;
  final ValueChanged<String> changeDirection;
  final ValueChanged<String> changeDifficultly;

  const _HistoryList({
    required this.direction,
    required this.difficultly,
    required this.changeDirection,
    required this.changeDifficultly,
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

  const _FilterButton({
    required this.difficultly,
    required this.direction,
    required this.changeDirection,
    required this.changeDifficultly,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      onTap: () => DialogHelper.showFilterDialog(
        context,
        _FilterDialog(
          difficultly: difficultly,
          direction: direction,
          changeDirection: changeDirection,
          changeDifficultly: changeDifficultly,
        ),
      ),
      decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
    );
  }
}

class _FilterDialog extends StatelessWidget {
  final String difficultly;
  final String direction;
  final ValueChanged<String> changeDirection;
  final ValueChanged<String> changeDifficultly;

  const _FilterDialog({
    required this.difficultly,
    required this.direction,
    required this.changeDirection,
    required this.changeDifficultly,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          _DirectionDropdownButton(
            changeDirection: changeDirection,
            direction: direction,
          ),
          _DifficultlyDropdownButton(
            difficultly: difficultly,
            changeDifficultly: changeDifficultly,
          ),
          _FinishButton(),
        ],
      ),
    );
  }
}

class _DirectionDropdownButton extends StatelessWidget {
  final ValueChanged<String> changeDirection;
  final String direction;

  const _DirectionDropdownButton({
    required this.changeDirection,
    required this.direction,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdownMenu(
      data: InitialData.directions,
      change: changeDirection,
      hintText: 'Все направления',
    );
  }
}

class _DifficultlyDropdownButton extends StatelessWidget {
  final String difficultly;
  final ValueChanged<String> changeDifficultly;

  const _DifficultlyDropdownButton({
    required this.difficultly,
    required this.changeDifficultly,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdownMenu(
      data: InitialData.difficulties,
      change: changeDifficultly,
      hintText: 'Все Cложности',
    );
  }
}

class _FinishButton extends StatelessWidget {
  const _FinishButton();

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Применить',
      selectedColor: AppPalette.primary,
      onPressed: () => AppRouter.pop(),
      percentsWidth: 0.6,
    );
  }
}
