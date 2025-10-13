import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:interview_master/core/utils/filter_favourite_cubit.dart';
import 'package:interview_master/features/history/blocs/change_is_favourite_bloc/change_is_favourite_bloc.dart';
import 'package:interview_master/features/history/use_cases/change_is_favourite_interview_use_case.dart';
import '../../../../app/widgets/custom_interview_info.dart';
import '../../../data/models/interview/interview_data.dart';
import '../use_cases/change_is_favourite_question_use_case.dart';

class InterviewInfoPage extends StatelessWidget {
  final InterviewData interview;
  final bool isCurrentUser;

  const InterviewInfoPage({
    super.key,
    required this.interview,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChangeIsFavouriteBloc(
            GetIt.I<ChangeIsFavouriteInterviewUseCase>(),
            GetIt.I<ChangeIsFavouriteQuestionUseCase>(),
          ),
        ),
        BlocProvider(create: (context) => FilterFavouriteCubit()),
      ],
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomInterviewInfo(interview: interview),
        ),
      ),
    );
  }
}
