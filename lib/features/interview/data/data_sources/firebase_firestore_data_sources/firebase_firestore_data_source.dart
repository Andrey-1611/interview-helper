import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/interview.dart';
import 'firebase_firestore_data_source_interface.dart';

class FirebaseFirestoreDataSource implements FirebaseFirestoreDataSourceInterface {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final String _userId;
  late final Future<void> _init;

  FirebaseFirestoreDataSource() {
    _init = _initUserId();
  }

  Future<void> _initUserId() async{
    final db = await SharedPreferences.getInstance();
    String? userId = db.getString('userId');
    if (userId == null) {
      userId = '${DateTime.now().millisecondsSinceEpoch}';
      await db.setString('userId', userId);
    }
    _userId = userId;
  }

  Future<CollectionReference<Object?>> get _userInterviews async {
    await _init;
    return _firestore.collection('users/$_userId/interviews');
  }


  @override
  Future<void> addInterview(Interview interview) async {
    final interviews = await _userInterviews;
    await interviews.add(interview.toMap());
  }

  @override
  Future<List<Interview>> showInterviews() async {
    final interviews = await _userInterviews;
    final data = await interviews.get();
    final questions =
        data.docs
            .map((interview) => Interview.fromMap(interview.data() as Map<String, dynamic>))
            .toList();
    return questions;
  }
}
