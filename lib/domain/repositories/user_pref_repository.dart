abstract class UserPrefRepository {
  Future<bool> getIsFirstTimeUser();
  Future<void> setIsFirstTimeUser(bool value);
}