import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/data_sources/firebase_firestore_data_sources/firebase_firestore_data_source_interface.dart';
import '../../data/models/interview.dart';

part 'show_interviews_event.dart';
part 'show_interviews_state.dart';

class ShowInterviewsBloc extends Bloc<ShowInterviewsEvent, ShowInterviewsState> {
  final FirebaseFirestoreDataSourceInterface localDataSourceInterface;
  ShowInterviewsBloc(this.localDataSourceInterface) : super(ShowInterviewsInitial()) {
    on<ShowInterviews>((event, emit) async {
      emit(ShowInterviewsLoading());
      try {
        final List<Interview> interviews = await localDataSourceInterface.showInterviews();
        interviews.sort((a, b) => b.date.compareTo(a.date));
        emit(ShowInterviewsSuccess(interviews: interviews));
      } catch (e) {
        emit(ShowInterviewsFailure(error: e.toString()));
      }
    });
  }
}
