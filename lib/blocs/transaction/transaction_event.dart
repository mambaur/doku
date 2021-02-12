part of 'transaction_bloc.dart';

@immutable
abstract class TransactionEvent {}

class GetListCategory extends TransactionEvent{
  final String params;
  GetListCategory({this.params});
}

class GetTransaction extends TransactionEvent {}

class InsertTransaction extends TransactionEvent{
  final TransactionModel transactionModel;
  InsertTransaction({this.transactionModel});
}