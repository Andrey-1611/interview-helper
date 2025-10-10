import 'package:injectable/injectable.dart';
import 'package:interview_master/data/repositories/local_repository.dart';

@injectable
class ChangeIsFavouriteUseCase {
  final LocalRepository _localRepository;

  ChangeIsFavouriteUseCase(this._localRepository);

  Future<void> call(String id) async {
    await _localRepository.changeIsFavourite(id);
  }
}
