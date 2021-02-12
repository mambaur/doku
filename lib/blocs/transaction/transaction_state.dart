part of 'transaction_bloc.dart';

@immutable
abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class TransactionWaiting extends TransactionState {}

class TransactionCategory extends TransactionState {
  final List<CategoryModel> categoryModel;
  TransactionCategory({this.categoryModel});
}

class TransactionInsert extends TransactionState{
  final String message;
  TransactionInsert({this.message});
}

class TransactionGetAll extends TransactionState {
  final List<TransactionModel> transactionModel;
  TransactionGetAll({this.transactionModel});
}

class TransactionError extends TransactionState {
  final String errorMessage;
  TransactionError({this.errorMessage});
}
