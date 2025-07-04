import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/interview.dart';
import 'firestore_data_source_interface.dart';

class FirestoreDataSource implements LocalDataSourceInterface {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final String _userId;

  FirestoreDataSource() {
    _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
  }

  CollectionReference get _userInterviews {
    return _firestore.collection('users/$_userId/interviews');
  }


  @override
  Future<void> addInterview(Interview interview) async {
    await _userInterviews.add(interview.toMap());
  }

  @override
  Future<List<Interview>> showInterviews() async {
    final data = await _userInterviews.get();
    final questions =
        data.docs
            .map((interview) => Interview.fromMap(interview.data() as Map<String, dynamic>))
            .toList();
    return questions;
  }
}
