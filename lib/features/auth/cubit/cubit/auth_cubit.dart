import 'package:bloc/bloc.dart';
import 'package:inventory/features/auth/data/auth_repo.dart';
import 'package:inventory/features/auth/data/model/user_data.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  UserData? currentUser;

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
        final user = await AuthRepo.getUserData();

        if (user == null) {
          emit(AuthErrorState(message: "لم يتم العثور على المستخدم"));
          return;
        }
        if (user.isBlocked == true) {
          emit(AuthErrorState(message: "هذا الحساب محظور"));
          return;
        }

        currentUser = user;

        emit(AuthSuccessState());
      } else {
        emit(AuthErrorState(message: "بيانات غير صحيحة"));
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoadingState());

    try {
      final response = await AuthRepo.signInWithGoogle();

      if (response) {
        final user = await AuthRepo.getUserData();

        if (user == null) {
          emit(AuthErrorState(message: "فشل جلب بيانات المستخدم"));
          return;
        }

        if (user.isBlocked == true) {
          emit(AuthErrorState(message: "هذا الحساب محظور"));
          return;
        }

        currentUser = user;

        emit(AuthSuccessState());
      } else {
        emit(AuthErrorState(message: "فشل تسجيل الدخول بجوجل"));
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  void logout() {
    currentUser = null;
    emit(AuthInitial());
  }
}
