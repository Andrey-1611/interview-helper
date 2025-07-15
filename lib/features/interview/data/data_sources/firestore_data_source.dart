import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/interview.dart';
import '../repositories/firestore_repository.dart';

class FirestoreDataSource
    implements FirestoreRepository {
  final FirebaseFirestore _firebaseFirestore;
  final String userId;
  late CollectionReference interviews;

  FirestoreDataSource(this._firebaseFirestore, {required this.userId}) {
    interviews = _firebaseFirestore.collection('users/$userId/interviews');
  }

  @override
  Future<void> addInterview(Interview interview) async {
    try {
      await interviews.add(interview.toMap());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Interview>> showInterviews() async {
    try {
      final data = await interviews.get();
      final myInterviews = data.docs
          .map(
            (interview) =>
                Interview.fromMap(interview.data() as Map<String, dynamic>),
          )
          .toList();
      return myInterviews;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
