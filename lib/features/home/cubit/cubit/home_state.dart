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

final class DeleteProductLoading extends HomeState {}

final class DeleteProductSuccess extends HomeState {}

final class DeleteProductError extends HomeState {}
