import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../app/global/models/user_data.dart';
import '../models/interview.dart';

class FirestoreDataSource {
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

  Future<void> saveUser(UserData user) async {
    try {
      await _usersCollection().doc(user.id).set(user.toJson());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<UserData>> showUsers() async {
    final data = await _usersCollection()
        .orderBy('totalScore', descending: true)
        .get();
    final List<UserData> users = data.docs
        .map((doc) => UserData.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return users;
  }

  Future<void> addInterview(Interview interview, String userId) async {
    try {
      await _interviewsCollection(userId).add(interview.toJson());

      final user = await _usersCollection().doc(userId).get();
      final userData = UserData.fromJson(user.data() as Map<String, dynamic>);

      await _usersCollection()
          .doc(userId)
          .update(UserData.updateData(userData, interview));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<Interview>> showInterviews(String userId) async {
    try {
      final data = await _interviewsCollection(
        userId,
      ).orderBy('date', descending: true).get();
      final List<Interview> interviews = data.docs
          .map((doc) => Interview.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return interviews;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
