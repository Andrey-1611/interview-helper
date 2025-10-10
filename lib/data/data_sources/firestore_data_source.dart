import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../models/interview/interview_data.dart';
import '../models/user/user_data.dart';
import '../repositories/remote_repository.dart';

@LazySingleton(as: RemoteRepository)
class FirestoreDataSource implements RemoteRepository {
  final FirebaseFirestore _firebaseFirestore;

  FirestoreDataSource(this._firebaseFirestore);

  CollectionReference _usersCollection() {
    return _firebaseFirestore.collection('users');
  }

  CollectionReference _interviewsCollection(String userId) {
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('interviews');
  }

  @override
  Future<void> saveUser(UserData user) async {
    try {
      await _usersCollection().doc(user.id).set(user.toJson());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<UserData>> showUsers() async {
    try {
      final data = await _usersCollection().get();
      final List<UserData> users = data.docs
          .map((doc) => UserData.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      users.sort((a, b) => b.totalScore.compareTo(a.totalScore));
      return users;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<UserData> getUserData(String userId) async {
    try {
      final data = await _usersCollection().doc(userId).get();
      final user = UserData.fromJson(data.data() as Map<String, dynamic>);
      return user;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> addInterview(
    InterviewData interview,
    UserData updatedUser,
  ) async {
    try {
      await _interviewsCollection(
        updatedUser.id,
      ).doc(interview.id).set(interview.toJson());
      await _usersCollection().doc(updatedUser.id).update(updatedUser.toJson());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<InterviewData>> showInterviews(String userId) async {
    try {
      final data = await _interviewsCollection(
        userId,
      ).orderBy('date', descending: true).get();
      final List<InterviewData> interviews = data.docs
          .map(
            (doc) => InterviewData.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
      return interviews;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> updateInterviews(
    String userId,
    List<InterviewData> interviews,
  ) async {
    try {
      for (final interview in interviews) {
        await _interviewsCollection(
          userId,
        ).doc(interview.id).update({'isFavourite': interview.isFavourite});
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
