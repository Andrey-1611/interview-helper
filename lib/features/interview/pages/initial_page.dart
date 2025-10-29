import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';
import 'package:interview_master/core/constants/data.dart';
import 'package:interview_master/core/utils/network_info.dart';
import 'package:interview_master/core/utils/stopwatch_info.dart';
import 'package:interview_master/core/theme/app_pallete.dart';
import 'package:interview_master/core/utils/toast_helper.dart';
import 'package:interview_master/features/interview/blocs/interview_bloc/interview_bloc.dart';
import 'package:interview_master/features/interview/blocs/interview_form_cubit/interview_form_cubit.dart';
import 'package:interview_master/features/users/blocs/users_bloc/users_bloc.dart';
import '../../../../app/router/app_router_names.dart';
import '../../../data/repositories/ai/ai.dart';
import '../../../app/widgets/custom_dropdown_menu.dart';
import '../../../app/widgets/custom_button.dart';
import '../../../data/repositories/local/local.dart';
import '../../../data/repositories/remote/remote.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => InterviewBloc(
            GetIt.I<AIRepository>(),
            GetIt.I<RemoteRepository>(),
            GetIt.I<LocalRepository>(),
            GetIt.I<NetworkInfo>(),
            GetIt.I<StopwatchInfo>(),
          ),
        ),
        BlocProvider(
          create: (context) => UsersBloc(
            GetIt.I<RemoteRepository>(),
            GetIt.I<LocalRepository>(),
            GetIt.I<NetworkInfo>(),
          )..add(GetUser()),
        ),
        BlocProvider(create: (context) => InterviewFormCubit()),
      ],
      child: _InitialPageView(),
    );
  }
}

class _InitialPageView extends StatelessWidget {
  const _InitialPageView();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final form = context.watch<InterviewFormCubit>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Собеседование'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.2),
              CustomDropdownMenu(
                value: form.state.direction,
                data: InitialData.directions,
                change: form.changeDirection,
                hintText: 'Выберите направление',
              ),
              SizedBox(height: size.height * 0.03),
              CustomDropdownMenu(
                value: form.state.difficulty,
                data: InitialData.difficulties,
                change: form.changeDifficulty,
                hintText: 'Выберите сложность',
              ),
              SizedBox(height: size.height * 0.03),
              _InterviewButton(),
              SizedBox(height: size.height * 0.08),
              _LastInterviewsList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _InterviewButton extends StatelessWidget {
  const _InterviewButton();

  @override
  Widget build(BuildContext context) {
    final form = context.read<InterviewFormCubit>();
    return BlocListener<InterviewBloc, InterviewState>(
      listener: (context, state) {
        if (state is InterviewAttemptsFailure) {
          ToastHelper.attemptsError();
        } else if (state is InterviewNetworkFailure) {
          ToastHelper.networkError();
        } else if (state is InterviewFailure) {
          ToastHelper.unknownError();
        } else if (state is InterviewStartSuccess) {
          context.pushReplacement(
            AppRouterNames.interview,
            extra: InterviewInfo(
              direction: form.state.direction!,
              difficulty: form.state.difficulty!,
              userInputs: [],
            ),
          );
        }
      },
      child: CustomButton(
        text: 'Начать',
        selectedColor: AppPalette.primary,
        onPressed: () {
          if (form.state.direction != null && form.state.difficulty != null) {
            return context.read<InterviewBloc>().add(StartInterview());
          }
          ToastHelper.interviewFormError();
        },
      ),
    );
  }
}

class _LastInterviewsList extends StatelessWidget {
  const _LastInterviewsList();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (state is UserSuccess) {
          return SizedBox(
            height: size.height * 0.14,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.user.interviews.length,
              itemBuilder: (context, index) {
                final interview = state.user.interviews[index];
                return GestureDetector(
                  onTap: () => context.read<InterviewFormCubit>().changeAll(
                    interview.direction,
                    interview.difficulty,
                  ),
                  child: SizedBox(
                    width: size.height * 0.14,
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(interview.direction),
                          Text(interview.difficulty),
                        ],
                      ),
                    ),
                  ),
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
