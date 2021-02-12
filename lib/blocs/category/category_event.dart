part of 'category_bloc.dart';

@immutable
abstract class CategoryEvent {}

class GetListCategory extends CategoryEvent{}

class AddCategory extends CategoryEvent{
  final CategoryModel categoryModel;
  AddCategory({this.categoryModel});
}

class UpdateCategory extends CategoryEvent{
  final CategoryModel categoryModel;
  final int id;
  UpdateCategory({this.categoryModel, this.id});
}

class DeleteCategory extends CategoryEvent{
  final int id;
  DeleteCategory({this.id});
}