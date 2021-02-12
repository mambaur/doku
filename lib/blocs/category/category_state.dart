part of 'category_bloc.dart';

@immutable
abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryListWaiting extends CategoryState {}

class CategoryList extends CategoryState{
  final List<CategoryModel> listCategory;
  CategoryList({this.listCategory});
}

class CategoryError extends CategoryState{
  final String errorMessage;
  CategoryError({this.errorMessage});
}

class AddLoadCategory extends CategoryState {}

