part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class GetUserSuccess extends HomeState {}

final class GetUserLoading extends HomeState {}

final class GetUserError extends HomeState {}

final class GetProductLoading extends HomeState {}

final class GetProductSuccess extends HomeState {}

final class GetProductError extends HomeState {}

final class AddProductSuccess extends HomeState {}

final class AddProductError extends HomeState {}

final class AddProductLoading extends HomeState {}

class DeleteProductLoading extends HomeState {}

class DeleteProductSuccess extends HomeState {}

class DeleteProductError extends HomeState {}
