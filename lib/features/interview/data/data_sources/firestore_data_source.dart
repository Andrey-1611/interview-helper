import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/interview.dart';
import '../../domain/repositories/remote_repository.dart';

class FirestoreDataSource implements RemoteRepository {
  final FirebaseFirestore _firebaseFirestore;

  FirestoreDataSource(this._firebaseFirestore);

  @override
  Future<void> addInterview(Interview interview, String userId) async {
    try {
      await _getInterviewCollection(userId).add(interview.toJson());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Interview>> showInterviews(String userId) async {
    try {
      final data = await _getInterviewCollection(userId).get();
      final myInterviews = data.docs
          .map(
            (interview) =>
                Interview.fromJson(interview.data() as Map<String, dynamic>),
          )
          .toList();
      myInterviews.sort((a, b) => b.date.compareTo(a.date));
      return myInterviews;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  CollectionReference _getInterviewCollection(String userId) {
    return _firebaseFirestore.collection('users/$userId/interviews');
  }
}
