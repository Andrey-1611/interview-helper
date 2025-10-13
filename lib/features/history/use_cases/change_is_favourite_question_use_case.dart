import 'package:injectable/injectable.dart';
import 'package:interview_master/data/repositories/local_repository.dart';

@injectable
class ChangeIsFavouriteQuestionUseCase {
  final LocalRepository _localRepository;

  ChangeIsFavouriteQuestionUseCase(this._localRepository);

  Future<void> call(String id) async {
    await _localRepository.changeIsFavouriteQuestion(id);
  }
}
