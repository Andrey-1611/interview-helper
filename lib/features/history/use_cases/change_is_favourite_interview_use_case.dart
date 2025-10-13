import 'package:injectable/injectable.dart';
import 'package:interview_master/data/repositories/local_repository.dart';

@injectable
class ChangeIsFavouriteInterviewUseCase {
  final LocalRepository _localRepository;

  ChangeIsFavouriteInterviewUseCase(this._localRepository);

  Future<void> call(String id) async {
    await _localRepository.changeIsFavouriteInterview(id);
  }
}
