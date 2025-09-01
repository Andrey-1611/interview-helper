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
}
