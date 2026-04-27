import 'package:bloc/bloc.dart';
import 'package:inventory/features/auth/data/auth_repo.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> register({
    required String name,
    required String password,
    required String email,
    required String confirmPassword,
  }) async {
    emit(AuthLoadingState());
    try {
      final response = await AuthRepo.register(
        name: name,
        password: password,
        confirmPassword: confirmPassword,
        email: email,
      );
      if (response) {
        emit(AuthSuccessState());
      } else {
        emit(AuthErrorState(message: "حدث خطأ أثناء التسجيل"));
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> login({required String password, required String email}) async {
    emit(AuthLoadingState());
    try {
      final response = await AuthRepo.login(password: password, email: email);
      if (response) {
        emit(AuthSuccessState());
      } else {
        emit(AuthErrorState(message: "حدث خطأ أثناء التسجيل"));
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }
}
