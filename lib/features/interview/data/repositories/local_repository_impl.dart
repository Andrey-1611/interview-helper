import 'package:interview_master/features/auth/data/models/my_user.dart';
import 'package:interview_master/features/interview/data/data_sources/hive_data_source.dart';
import 'package:interview_master/features/interview/data/models/interview.dart';
import 'package:interview_master/features/interview/domain/repositories/local_repository.dart';

class LocalRepositoryImpl implements LocalRepository {
  final HiveDataSource _hiveDataSource;

  LocalRepositoryImpl(this._hiveDataSource);

  @override
  Future<void> addInterview(Interview interview) async {
    await _hiveDataSource.addInterview(interview);
  }

  @override
  Future<void> loadInterviews(List<Interview> interviews) async {
    await _hiveDataSource.loadInterviews(interviews);
  }

  @override
  Future<List<Interview>> showInterviews() async {
    return await _hiveDataSource.showInterviews();
  }

  @override
  Future<void> loadUser(MyUser user) async {
    await _hiveDataSource.loadUser(user);
  }

  @override
  Future<MyUser?> getUser() async {
    return await _hiveDataSource.getUser();
  }

  @override
  Future<void> deleteUser() async {
   await _hiveDataSource.deleteUser();
  }
}
