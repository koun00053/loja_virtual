import 'package:dagugi_acessorios/src/pages/auth/repository/auth_repository.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  RxBool isLoading = false.obs;

  final authRepository = AuthRepository();

  Future<void> signIn({required String email, required String password}) async {
    isLoading.value = true;
    await authRepository.signIn(email: email, password: password);
    isLoading.value = false;
  }
}
