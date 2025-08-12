import 'package:interview_master/features/interview/data/data_sources/firestore_data_source.dart';
import 'package:interview_master/features/interview/data/models/interview.dart';
import '../../../../app/global_services/user/models/user_data.dart';
import '../../domain/repositories/remote_repository.dart';

class RemoteRepositoryImpl implements RemoteRepository {
  final FirestoreDataSource _firestoreDataSource;

  RemoteRepositoryImpl(this._firestoreDataSource);

  @override
  Future<void> saveUser(UserData user) async {
    _firestoreDataSource.saveUser(user);
  }

  @override
  Future<List<UserData>> showUsers() async {
    return await _firestoreDataSource.showUsers();
  }

  @override
  Future<void> addInterview(Interview interview, String userId) async {
    await _firestoreDataSource.addInterview(interview, userId);
  }

  @override
  Future<List<Interview>> showInterviews(String userId) async {
    return await _firestoreDataSource.showInterviews(userId);
  }

}
