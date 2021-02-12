import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dompet_apps/models/category-model.dart';
import 'package:dompet_apps/models/transaction-model.dart';
import 'package:dompet_apps/repositories/database/apps-database.dart';
import 'package:meta/meta.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc() : super(ReportInitial());

  @override
  Stream<ReportState> mapEventToState(
    ReportEvent event,
  ) async* {
    if (event is ReportInit) {
      yield* _reportInit(event.params);
    }
    if (event is GetReport) {
      yield* _getReport();
    }
    if (event is DeleteReport) {
      yield* _deleteReport(event.id);
    }
    if (event is DeleteReportByDate) {
      yield* _deleteReportByDate(event.date);
    }
    if (event is GetReportByDate) {
      yield* _getReportByDate(event.date);
    }
    if (event is UpdateReport) {
      yield* _updateReport(event.transactionModel);
    }
    if (event is GetReportPemasukan) {
      yield* _getReportPemasukan();
    }
    if (event is GetReportPengeluaran) {
      yield* _getReportPengeluaran();
    }
  }

  Stream<ReportState> _reportInit(String params) async* {
    try {
      if (params == 'mingguan') {
        yield ReportMingguan();
      } else if (params == 'bulanan') {
        yield ReportBulanan();
      } else if (params == 'tahunan') {
        yield ReportTahunan();
      }
    } catch (e) {
      yield ReportError(errorMessage: e.toString());
    }
  }

  Stream<ReportState> _getReport() async* {
    AppsDatabase db = AppsDatabase();
    yield ReportWaiting();
    try {
      var transactionGroup = await db.getTranOrderByDate();
      var transactionModel = await db.getTransaction();
      var sumPemasukan = await db.getSum('Pemasukan');
      var sumPengeluaran = await db.getSum('Pengeluaran');
      yield ReportGetAll(
          transactionModel: transactionModel,
          transactionGroup: transactionGroup,
          sumPemasukan: sumPemasukan,
          sumPengeluaran: sumPengeluaran);
    } catch (e) {
      ReportError(errorMessage: e.toString());
    }
  }

  Stream<ReportState> _deleteReport(int id) async* {
    AppsDatabase db = AppsDatabase();
    yield ReportWaiting();
    try {
      await db.deleteTransaction(id);
      yield ReportDelete();
    } catch (e) {
      ReportError(errorMessage: e.toString());
    }
  }

  Stream<ReportState> _deleteReportByDate(String date) async* {
    AppsDatabase db = AppsDatabase();
    yield ReportWaiting();
    try {
      await db.deleteTransByDate(date);
      yield ReportDeleteByDate();
    } catch (e) {
      ReportError(errorMessage: e.toString());
    }
  }

  Stream<ReportState> _getReportByDate(String date) async* {
    AppsDatabase db = AppsDatabase();
    yield ReportDetailWaiting();
    try {
      List<CategoryModel> category = await db.getCategory();
      var data = await db.getTransByDate(date);
      yield ReportGetByDate(data: data, category: category);
    } catch (e) {
      ReportError(errorMessage: e.toString());
    }
  }

  Stream<ReportState> _updateReport(data) async* {
    AppsDatabase db = AppsDatabase();
    yield ReportDetailWaiting();
    try {
      await db.updateReport(data);
      yield UpdateSuccess();
    } catch (e) {
      ReportError(errorMessage: e.toString());
    }
  }

  Stream<ReportState> _getReportPemasukan() async* {
    AppsDatabase db = AppsDatabase();
    yield ReportWaiting();
    try {
      var response = await db.getPemasukan();
      yield GetPemasukan(data: response);
    } catch (e) {
      ReportError(errorMessage: e.toString());
    }
  }

  Stream<ReportState> _getReportPengeluaran() async* {
    AppsDatabase db = AppsDatabase();
    yield ReportWaiting();
    try {
      var response = await db.getPengeluaran();
      yield GetPengeluaran(data: response);
    } catch (e) {
      ReportError(errorMessage: e.toString());
    }
  }
}
