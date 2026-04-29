import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory/features/auth/data/auth_repo.dart';
import 'package:inventory/features/auth/data/model/user_data.dart';
import 'package:inventory/features/home/data/home_repo.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  UserData? userData;

  Future<void> getUserData(String uid) async {
    emit(GetUserLoading());

    final response = await AuthRepo.getUserData(uid);

    if (response != null) {
      userData = response;
      emit(GetUserSuccess());
    } else {
      emit(GetUserError());
    }
  }

  Future<void> addProduct({
    required String name,
    required String quantity,
    required String minQuantity,
    required String description,
  }) async {
    emit(AddProductLoading());

    try {
      await HomeRepo.addProduct(
        name: name,
        quantity: int.parse(quantity),
        minQuantity: int.parse(minQuantity),
        description: description,
      );

      emit(AddProductSuccess());
    } catch (e) {
      emit(AddProductError());
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getProducts() {
    return HomeRepo.getProduct();
  }

  deleteProduct(String id) async {
    emit(DeleteProductLoading());
    try {
      await HomeRepo.deleteProduct(id);
      emit(DeleteProductSuccess());
    } catch (e) {
      emit(DeleteProductError());
    }
  }

  updateQuantity({required String id, required int newQuantity}) async {
    try {
      await FirebaseFirestore.instance.collection("products").doc(id).update({
        "quantity": newQuantity,
      });
    } catch (e) {
      print("UPDATE ERROR: $e");
    }
  }
}
