import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/interview.dart';
import 'firestore_data_source_interface.dart';

class FirestoreDataSource implements LocalDataSourceInterface {
  final CollectionReference interviews = FirebaseFirestore.instance.collection(
    'interviews',
  );

  @override
  Future<void> addInterview(Interview interview) async {
    await interviews.add(interview.toMap());
  }

  @override
  Future<List<Interview>> showInterviews() async {
    final data = await interviews.get();
    final questions =
        data.docs
            .map((interview) => Interview.fromMap(interview.data() as Map<String, dynamic>))
            .toList();
    return questions;
  }
}
