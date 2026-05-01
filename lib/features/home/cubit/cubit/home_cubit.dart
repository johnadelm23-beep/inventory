import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory/features/auth/data/auth_repo.dart';
import 'package:inventory/features/auth/data/model/user_data.dart';
import 'package:inventory/features/home/data/home_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  UserData? userData;
  void cleaUser() {
    userData = null;
    emit(HomeInitial());
  }

  Future<void> getUserData() async {
    emit(GetUserLoading());

    final response = await AuthRepo.getUserData();

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
        userName: userData?.name ?? "",
      );

      emit(AddProductSuccess());
    } catch (e) {
      emit(AddProductError());
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getProducts() {
    return HomeRepo.getProduct();
  }

  Future<void> deleteProduct({required String id, required String name}) async {
    emit(DeleteProductLoading());
    try {
      await HomeRepo.deleteProduct(
        id,
        productId: id,
        name: name,
        userName: userData?.name ?? "",
      );
      emit(DeleteProductSuccess());
    } catch (e) {
      emit(DeleteProductError());
    }
  }

  Future<void> updateQuantity({
    required String id,
    required int newQuantity,
    required String name,
    required int oldQuantity,
  }) async {
    try {
      await HomeRepo.updateQuantity(
        id: id,
        quantity: newQuantity,
        name: name,
        userName: userData?.name ?? "Unknown",
        oldQuantity: oldQuantity,
      );
    } catch (e) {
      print("UPDATE ERROR: $e");
    }
  }
}
