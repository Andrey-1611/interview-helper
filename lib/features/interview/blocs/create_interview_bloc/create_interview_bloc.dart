import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_master/features/interview/data/repositories/interview_repository.dart';
import '../../data/models/gemini_response.dart';
import '../../data/models/interview.dart';

part 'create_interview_event.dart';

part 'create_interview_state.dart';

class CreateInterviewBloc
    extends Bloc<CreateInterviewEvent, CreateInterviewState> {
  final InterviewRepository interviewRepository;

  CreateInterviewBloc(this.interviewRepository)
    : super(CreateInterviewInitial()) {
    on<CreateInterview>((event, emit) {
      emit(CreateInterviewLoading());
      try {
        final interview = interviewRepository.createInterview();
        emit(CreateInterviewSuccess(interview: interview));
      } catch (e) {
        emit(CreateInterviewFailure());
      }
    });
  }
}
