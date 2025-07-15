import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/firestore_repository.dart';
import '../../data/models/interview.dart';

part 'add_interview_event.dart';
part 'add_interview_state.dart';

class AddInterviewBloc extends Bloc<AddInterviewEvent, AddInterviewState> {
  final FirestoreRepository firestoreRepository;
  AddInterviewBloc(this.firestoreRepository) : super(AddInterviewInitial()) {
    on<AddInterview>((event, emit) async {
      emit(AddInterviewLoading());
      try {
        await firestoreRepository.addInterview(event.interview);
        emit(AddInterviewSuccess());
      } catch (e) {
        emit(AddInterviewFailure());
      }
    });
  }
}
