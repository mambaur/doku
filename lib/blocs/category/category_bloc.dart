import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dompet_apps/models/category-model.dart';
import 'package:dompet_apps/repositories/database/apps-database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial());

  @override
  Stream<CategoryState> mapEventToState(
    CategoryEvent event,
  ) async* {
    if (event is GetListCategory){
      yield* _getListCategory();
    }
    if (event is AddCategory){
      yield* _addCategory(event.categoryModel);
    }
    if (event is DeleteCategory){
      yield* _deleteCategory(event.id);
    }
    if (event is UpdateCategory){
      yield* _updateCategory(event.id, event.categoryModel);
    }
  }

  Stream<CategoryState> _getListCategory() async* {
    AppsDatabase db = AppsDatabase();

    yield CategoryListWaiting();
    try {
      List<CategoryModel> data = await db.getCategory();
      yield CategoryList(listCategory: data);
    } catch (e) {
      yield CategoryError(errorMessage: e.toString());
    }
  }

  Stream<CategoryState> _addCategory(CategoryModel categoryModel) async* {
    AppsDatabase db = AppsDatabase();

    yield CategoryListWaiting();
    try {
      await db.insertCategory(categoryModel);
      Fluttertoast.showToast(
          msg: 'Kategori berhasil ditambahkan',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.grey[700],
          fontSize: 12);
      yield AddLoadCategory();
    } catch (e) {
      yield CategoryError(errorMessage: e.toString());
    }
  }
  
  Stream<CategoryState> _deleteCategory(int id) async* {
    AppsDatabase db = AppsDatabase();

    yield CategoryListWaiting();
    try {
      await db.deleteCategory(id);
      Fluttertoast.showToast(
          msg: 'Kategori berhasil dihapus',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.grey[700],
          fontSize: 12);
      yield AddLoadCategory();
    } catch (e) {
      yield CategoryError(errorMessage: e.toString());
    }
  }
  
  Stream<CategoryState> _updateCategory(int id, CategoryModel categoryModel) async* {
    AppsDatabase db = AppsDatabase();

    yield CategoryListWaiting();
    try {
      await db.updateCategory(categoryModel, id);
      Fluttertoast.showToast(
          msg: 'Kategori berhasil diubah',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.grey[700],
          fontSize: 12);
      yield AddLoadCategory();
    } catch (e) {
      yield CategoryError(errorMessage: e.toString());
    }
  }
}
