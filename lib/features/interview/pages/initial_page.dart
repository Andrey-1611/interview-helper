import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:interview_master/core/utils/services/network_service.dart';
import 'package:interview_master/core/utils/services/stopwatch_service.dart';
import 'package:interview_master/core/utils/helpers/toast_helper.dart';
import 'package:interview_master/data/repositories/settings_repository.dart';
import 'package:interview_master/features/interview/blocs/interview_bloc/interview_bloc.dart';
import 'package:interview_master/features/interview/blocs/interview_form_cubit/interview_form_cubit.dart';
import 'package:interview_master/generated/l10n.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../app/router/app_router_names.dart';
import '../../../app/widgets/custom_dropdown_menu.dart';
import '../../../app/widgets/custom_button.dart';
import '../../../data/enums/difficulty.dart';
import '../../../data/enums/direction.dart';
import '../../../data/enums/language.dart';
import '../../../data/models/interview_info.dart';
import '../../../data/repositories/ai_repository.dart';
import '../../../data/repositories/local_repository.dart';
import '../../../data/repositories/remote_repository.dart';
import '../../profile/blocs/profile_bloc/profile_bloc.dart';

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
            GetIt.I<SettingsRepository>(),
            GetIt.I<NetworkService>(),
            GetIt.I<StopwatchService>(),
            GetIt.I<Talker>(),
          ),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(
            GetIt.I<RemoteRepository>(),
            GetIt.I<LocalRepository>(),
            GetIt.I<NetworkService>(),
            GetIt.I<Talker>(),
          )..add(GetProfile(userId: null)),
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
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(s.interview),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRouterNames.questionsDatabase),
            icon: Icon(Icons.library_books),
          ),
          IconButton(
            onPressed: () => context.push(AppRouterNames.settings),
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.24),
            CustomDropdownMenu<Direction>(
              value: form.state.direction,
              data: Direction.values
                  .map((direction) => (direction, null))
                  .toList(),
              change: (value) => form.changeDirection(value!),
              hintText: s.choose_direction,
            ),
            CustomDropdownMenu<Difficulty>(
              value: form.state.difficulty,
              data: Difficulty.values
                  .map((difficulty) => (difficulty, null))
                  .toList(),
              change: (value) => form.changeDifficulty(value!),
              hintText: s.choose_difficulty,
            ),
            CustomDropdownMenu<Language>(
              value: form.state.language,
              data: Language.values
                  .map((language) => (language, language.localizedName(s)))
                  .toList(),
              change: (value) => form.changeLanguage(value!),
              hintText: s.choose_language,
            ),
            _InterviewButton(),
            const Spacer(),
            SizedBox(height: size.height * 0.14, child: _LastInterviewsList()),
          ],
        ),
      ),
    );
  }
}

class _InterviewButton extends StatelessWidget {
  const _InterviewButton();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final form = context.read<InterviewFormCubit>().state;
    return BlocListener<InterviewBloc, InterviewState>(
      listener: (context, state) {
        if (state is InterviewAttemptsFailure) {
          ToastHelper.attemptsError();
        } else if (state is InterviewNetworkFailure) {
          ToastHelper.networkError();
        } else if (state is InterviewFailure) {
          ToastHelper.unknownError();
        } else if (state is InterviewStartSuccess) {
          context.push(
            AppRouterNames.interview,
            extra: InterviewInfo(
              direction: form.direction!,
              difficulty: form.difficulty!,
              language: form.language!,
            ),
          );
        }
      },
      child: CustomButton(
        text: s.start,
        onPressed: () {
          if (form.direction != null &&
              form.difficulty != null &&
              form.language != null) {
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
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileSuccess) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.interviews.length,
            itemBuilder: (context, index) {
              final interview = state.interviews[index];
              return GestureDetector(
                onTap: () => context.read<InterviewFormCubit>().changeAll(
                  interview.direction,
                  interview.difficulty,
                  interview.language,
                ),
                child: SizedBox(
                  width: size.height * 0.14,
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(interview.direction.name),
                        Text(interview.difficulty.name),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
