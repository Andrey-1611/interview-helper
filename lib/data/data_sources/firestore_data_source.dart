import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../models/interview.dart';
import '../models/user_data.dart';
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
      final data = await _usersCollection()
          .orderBy('totalScore', descending: true)
          .get();
      final List<UserData> users = data.docs
          .map((doc) => UserData.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
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
  Future<void> addInterview(Interview interview, UserData updatedUser) async {
    try {
      await _interviewsCollection(updatedUser.id).add(interview.toJson());
      await _usersCollection().doc(updatedUser.id).update(updatedUser.toJson());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
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
