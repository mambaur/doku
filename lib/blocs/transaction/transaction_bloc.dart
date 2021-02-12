import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dompet_apps/models/category-model.dart';
import 'package:dompet_apps/models/transaction-model.dart';
import 'package:dompet_apps/repositories/database/apps-database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial());

  @override
  Stream<TransactionState> mapEventToState(
    TransactionEvent event,
  ) async* {
    if (event is GetListCategory) {
      yield* _getListCategory(event.params);
    }
    if (event is InsertTransaction) {
      yield* _insertTransaction(event.transactionModel);
    }
    if (event is GetTransaction) {
      yield* _getTransaction();
    }
  }

  Stream<TransactionState> _getListCategory(String params) async* {
    AppsDatabase db = AppsDatabase();
    yield TransactionWaiting();
    try {
      List<CategoryModel> categoryModel = await db.getCategoryPart(params);
      yield TransactionCategory(categoryModel: categoryModel);
    } catch (e) {
      yield TransactionError(errorMessage: e.toString());
    }
  }

  Stream<TransactionState> _insertTransaction(
      TransactionModel transactionModel) async* {
    AppsDatabase db = AppsDatabase();
    yield TransactionWaiting();
    try {
      await db.insertTransaction(transactionModel);
      yield TransactionInsert(message: "Transaksi berhasil ditambahkan");
    } catch (e) {
      yield TransactionError(errorMessage: e.toString());
    }
  }

  Stream<TransactionState> _getTransaction() async* {
    AppsDatabase db = AppsDatabase();
    yield TransactionWaiting();
    try {
      List<TransactionModel> transactionModel = await db.getTransaction();
      yield TransactionGetAll(transactionModel: transactionModel);
    } catch (e) {
      yield TransactionError(errorMessage: e.toString());
    }
  }
}
