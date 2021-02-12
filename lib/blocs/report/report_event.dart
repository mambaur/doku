part of 'report_bloc.dart';

@immutable
abstract class ReportEvent {}

class GetReport extends ReportEvent{}

class GetReportGroup extends ReportEvent{}
class GetReportPemasukan extends ReportEvent{}
class GetReportPengeluaran extends ReportEvent{}

class GetReportByDate extends ReportEvent{
  final String date;
  GetReportByDate({this.date});
}

class ReportInit extends ReportEvent{
  final String params;
  ReportInit({this.params});
}

class UpdateReport extends ReportEvent{
  final TransactionModel transactionModel;
  UpdateReport({this.transactionModel});
}


class DeleteReportByDate extends ReportEvent{
  final String date;
  DeleteReportByDate({this.date});
}

class DeleteReport extends ReportEvent{
  final int id;
  DeleteReport({this.id});
}
