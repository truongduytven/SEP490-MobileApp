import 'package:sep490/data/services/local_storage_service.dart';
import 'package:sep490/domain/repositories/user_pref_repository.dart';

class UserPrefRepositoryImpl implements UserPrefRepository {
  final LocalStorageService localStorageService;

  UserPrefRepositoryImpl(this.localStorageService);

  @override
  Future<bool> getIsFirstTimeUser() {
    return localStorageService.getIsFirstTimeUser();
  }

  @override
  Future<void> setIsFirstTimeUser(bool value) {
    return localStorageService.setIsFirstTimeUser(value);
  }
}
