import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:interview_master/data/models/task.dart';
import '../../models/interview_data.dart';
import '../../models/user_data.dart';
import 'remote_repository.dart';

@LazySingleton(as: RemoteRepository)
class RemoteDataSource implements RemoteRepository {
  final FirebaseFirestore _firebaseFirestore;

  RemoteDataSource(this._firebaseFirestore);

  CollectionReference _usersCollection() {
    return _firebaseFirestore.collection('users');
  }

  CollectionReference _interviewsCollection(String userId) {
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('interviews');
  }

  CollectionReference _tasksCollection(String userId) {
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('tasks');
  }

  @override
  Future<void> setUser(UserData user) async {
    await _usersCollection().doc(user.id).set(user.toJson());
  }

  @override
  Future<List<UserData>> getUsers() async {
    final data = await _usersCollection().limit(100).get();
    final users = data.docs
        .map((doc) => UserData.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    users.sort((a, b) => b.totalScore.compareTo(a.totalScore));
    return users;
  }

  @override
  Future<UserData> getUserData(String userId) async {
    final data = await _usersCollection().doc(userId).get();
    return UserData.fromJson(data.data() as Map<String, dynamic>);
  }

  @override
  Future<void> addInterview(
    InterviewData interview,
    UserData updatedUser,
  ) async {
    final batch = _firebaseFirestore.batch();
    final interviewDoc = _interviewsCollection(
      updatedUser.id,
    ).doc(interview.id);
    final userDoc = _usersCollection().doc(updatedUser.id);
    batch.set(interviewDoc, interview.toJson());
    batch.update(userDoc, updatedUser.toJson());
    await batch.commit();
  }

  @override
  Future<List<InterviewData>> getInterviews(String userId) async {
    final data = await _interviewsCollection(
      userId,
    ).orderBy('date', descending: true).get();
    return data.docs
        .map(
          (doc) => InterviewData.fromJson(doc.data() as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<void> updateInterviews(
    String userId,
    List<InterviewData> interviews,
  ) async {
    final batch = _firebaseFirestore.batch();
    interviews.map((interview) {
      final doc = _interviewsCollection(userId).doc(interview.id);
      batch.update(doc, {'isFavourite': interview.isFavourite});
    }).toList();
    await batch.commit();
  }

  @override
  Future<void> updateTasks(String userId, List<Task> tasks) async {
    final batch = _firebaseFirestore.batch();
    tasks.map((task) {
      final doc = _tasksCollection(userId).doc(task.id);
      batch.set(doc, task.toJson());
    }).toList();
    await batch.commit();
  }

  @override
  Future<List<Task>> getTasks(String userId) async {
    final data = await _tasksCollection(
      userId,
    ).orderBy('createdAt', descending: true).get();
    return data.docs
        .map((doc) => Task.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<UserData>> getFriends(List<String> friendsId) async {
    if (friendsId.isEmpty) return [];
    final data = await _usersCollection()
        .where(FieldPath.documentId, whereIn: friendsId)
        .get();
    final users = data.docs
        .map((doc) => UserData.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    users.sort((a, b) => b.totalScore.compareTo(a.totalScore));
    return users;
  }
}
