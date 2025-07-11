import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/data_sources/firebase_firestore_data_sources/firebase_firestore_data_source_interface.dart';
import '../../data/models/interview.dart';

part 'add_interview_event.dart';
part 'add_interview_state.dart';

class AddInterviewBloc extends Bloc<AddInterviewEvent, AddInterviewState> {
  final FirebaseFirestoreDataSourceInterface localDataSourceInterface;
  AddInterviewBloc(this.localDataSourceInterface) : super(AddInterviewInitial()) {
    on<AddInterview>((event, emit) async {
      emit(AddInterviewLoading());
      try {
        await localDataSourceInterface.addInterview(event.interview);
        emit(AddInterviewSuccess());
      } catch (e) {
        emit(AddInterviewFailure());
      }
    });
  }
}
