
import 'package:sep490/domain/repositories/user_pref_repository.dart';

class CheckUserOnboardingUseCase {
  final UserPrefRepository userPrefRepository;
  CheckUserOnboardingUseCase(this.userPrefRepository);
  Future<bool> execute() async {
    return await userPrefRepository.getIsFirstTimeUser();
  }
  Future<void> completeOnboarding() async {
    await userPrefRepository.setIsFirstTimeUser(false);
  }
}
