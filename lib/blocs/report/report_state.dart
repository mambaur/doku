part of 'report_bloc.dart';

@immutable
abstract class ReportState {}

class ReportInitial extends ReportState {}

class ReportWaiting extends ReportState {}

class ReportDetailWaiting extends ReportState {}

class ReportMingguan extends ReportState {}
class ReportBulanan extends ReportState {}
class ReportTahunan extends ReportState {}

class ReportGetAll extends ReportState{
  final dynamic transactionModel;
  final dynamic transactionGroup;
  final dynamic sumPemasukan;
  final dynamic sumPengeluaran;
  ReportGetAll({this.transactionModel, this.transactionGroup, this.sumPemasukan, this.sumPengeluaran});
}

class ReportGetGroupAll extends ReportState{
  final dynamic transactionModel;
  ReportGetGroupAll({this.transactionModel});
}

class InitialInfiniteList extends ReportState{}

class GetPemasukan extends ReportState{
  final dynamic data;
  GetPemasukan({this.data});
}

class GetPengeluaran extends ReportState{
  final dynamic data;
  GetPengeluaran({this.data});
}

class ReportGetByDate extends ReportState{
  final dynamic data;
  final List<CategoryModel> category;
  ReportGetByDate({this.data, this.category});
}

class UpdateSuccess extends ReportState{}
class ReportDelete extends ReportState{}
class ReportDeleteByDate extends ReportState{}

class ReportError extends ReportState{
  final String errorMessage;
  ReportError({this.errorMessage});
}

