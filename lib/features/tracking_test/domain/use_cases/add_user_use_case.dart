import '../entities/user_entity.dart';
import '../repositories/tracking_repository.dart';

class AddUserUseCase {
  final TrackingRepository repository;

  AddUserUseCase(this.repository);

  Future<void> call(UserEntity user) {
    return repository.addUser(user);
  }
}
