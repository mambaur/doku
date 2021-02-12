import 'package:dompet_apps/blocs/report/report_bloc.dart';
import 'package:dompet_apps/models/category-model.dart';
import 'package:dompet_apps/models/transaction-model.dart';
import 'package:dompet_apps/screens/reports/report-screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ReportDetail extends StatefulWidget {
  final String date;
  final String params;

  const ReportDetail({Key key, this.date, this.params}) : super(key: key);

  @override
  _ReportDetailState createState() =>
      _ReportDetailState(this.date, this.params);
}

class _ReportDetailState extends State<ReportDetail> {
  final formatCurrency = new NumberFormat("#,##0", "id");
  final String date;
  final String params;
  _ReportDetailState(this.date, this.params);

  String titleAppbar = 'Detail Transaksi';
  ReportBloc _reportBloc = ReportBloc();

  // digunakan untuk refresh indicator
  Future<void> refresh() async {
    _reportBloc.add(GetReportByDate(date: date));
  }

  _backPress() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LaporanScreen(
                  params: params,
                )));
  }

  @override
  void initState() {
    initializeDateFormatting();
    DateTime form = DateFormat('yyyy-MM-dd').parse(date);
    titleAppbar = DateFormat.yMMMMEEEEd('id').format(form);

    _reportBloc = BlocProvider.of<ReportBloc>(context);
    _reportBloc.add(GetReportByDate(date: date));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    return BlocListener<ReportBloc, ReportState>(
      cubit: _reportBloc,
      listener: (context, state) {
        if (state is ReportDelete) {
          _messageDialog('delete', 'Transaksi berhasil dihapus!');
          _reportBloc.add(GetReportByDate(date: date));
        }
        if (state is ReportDeleteByDate) {
          _messageDialog('deleteall', 'Transaksi berhasil dihapus!');
        }
        if (state is UpdateSuccess) {
          _messageDialog('delete', 'Transaksi berhasil diubah!');
          _reportBloc.add(GetReportByDate(date: date));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Material(
              color: Colors.transparent,
              child: InkWell(
                  onTap: () => _backPress(),
                  splashColor: Colors.grey[700],
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.grey[700],
                  ))),
          title: Text(titleAppbar,
              style: GoogleFonts.nunito(color: Colors.grey[700])),
          backgroundColor: Colors.white,
        ),
        body: WillPopScope(
          onWillPop: () => _backPress(),
          child: Stack(
            children: <Widget>[
              RefreshIndicator(
                onRefresh: () {
                  return refresh();
                },
                child: BlocBuilder<ReportBloc, ReportState>(
                  cubit: _reportBloc,
                  builder: (context, state) {
                    if (state is ReportWaiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is ReportGetByDate) {
                      return ListView.builder(
                        padding: EdgeInsets.only(top: 10, bottom: 50),
                        itemCount: state.data.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin:
                                EdgeInsets.only(left: 5, right: 5, bottom: 5),
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            decoration:
                                BoxDecoration(color: Colors.white, boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0, 1),
                                  blurRadius: 2)
                            ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  flex: 3,
                                  child: Row(
                                    children: <Widget>[
                                      Flexible(
                                        flex: 1,
                                        child: Icon(
                                          Icons.input,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        flex: 3,
                                        child: Text(
                                          state.data[index]['description'],
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.nunito(
                                              color: Colors.grey[700]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Flexible(
                                        flex: 1,
                                        child: ClipOval(
                                          child: Container(
                                              color: state.data[index]
                                                          ['categoryPart'] ==
                                                      'Pemasukan'
                                                  ? Colors.green
                                                  : Colors.red,
                                              padding: EdgeInsets.all(3),
                                              child: Text('Rp',
                                                  style: GoogleFonts.nunito(
                                                      color: Colors.white,
                                                      fontSize: 8,
                                                      fontWeight:
                                                          FontWeight.w600))),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 3,
                                        child: Text(
                                          '${formatCurrency.format(int.parse(state.data[index]['balance']))}',
                                          style: GoogleFonts.nunito(
                                              color: state.data[index]
                                                          ['categoryPart'] ==
                                                      'Pemasukan'
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () => _editDialog(
                                                context, index, state),
                                            splashColor: Colors.grey[800],
                                            child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5, vertical: 5),
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.grey[400],
                                                  size: 20,
                                                )),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              print(state.data[index]["id"]);
                                              _reportBloc.add(DeleteReport(
                                                  id: state.data[index]["id"]));
                                            },
                                            splashColor: Colors.grey[800],
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 5),
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.grey[400],
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              Container(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Container(
                          color: Colors.grey[400],
                          child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  onTap: () => _backPress(),
                                  splashColor: Colors.black,
                                  child: Container(
                                      height: 45,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(Icons.arrow_back,
                                              color: Colors.white, size: 16),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text('Kembali',
                                              style: GoogleFonts.nunito(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white)),
                                        ],
                                      )))),
                        ),
                      ),
                      SizedBox(
                        height: 45,
                        child: VerticalDivider(
                          width: 0,
                          color: Colors.white,
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          color: Colors.green,
                          child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  onTap: () {
                                    _reportBloc
                                        .add(DeleteReportByDate(date: date));
                                  },
                                  splashColor: Colors.black,
                                  child: Container(
                                      height: 45,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(Icons.delete,
                                              color: Colors.white, size: 16),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text('Hapus semua',
                                              style: GoogleFonts.nunito(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white)),
                                        ],
                                      )))),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future _messageDialog(String key, String message) async {
    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                child: SingleChildScrollView(
                    child: Text(
                  message,
                  style: GoogleFonts.nunito(color: Colors.grey[700]),
                )),
              );
            },
          ),
          actions: <Widget>[
            FlatButton(
              child: Row(
                children: <Widget>[
                  Text('Oke',
                      style: GoogleFonts.nunito(
                          color: Colors.green, fontWeight: FontWeight.w700)),
                ],
              ),
              onPressed: () {
                Navigator.pop(context);
                if (key == 'deleteall') {
                  _backPress();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future _editDialog(context, int index, state) async {
    String categoryName = state.data[index]['categoryName'];
    String balance = state.data[index]['balance'];
    String description = state.data[index]['description'];
    final _keyData = new GlobalKey<FormState>();

    //vallidate input Form edit
    checkFormEditData() {
      final form = _keyData.currentState;
      if (form.validate()) {
        form.save();
        TransactionModel transactionModel = new TransactionModel(
            id: state.data[index]["id"],
            balance: int.parse(balance),
            description: description,
            rolecategory: categoryName);
        _reportBloc.add(UpdateReport(transactionModel: transactionModel));
        print('$categoryName, and $balance, and $description');
        Navigator.pop(context);
      }
    }

    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ubah Transaksi', style: GoogleFonts.nunito()),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                child: SingleChildScrollView(
                    child: Form(
                  key: _keyData,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        onSaved: (e) => balance = e,
                        onChanged: (e) => balance = e,
                        keyboardType: TextInputType.number,
                        validator: (e) {
                          if (e.isEmpty) {
                            return "*Input tidak boleh kosong";
                          }
                        },
                        style: GoogleFonts.nunito(color: Colors.grey[700]),
                        controller: TextEditingController(text: balance),
                        decoration: InputDecoration(labelText: 'Jumlah uang'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButton(
                        onChanged: (e) {
                          setState(() {
                            categoryName = e;
                          });
                        },
                        value: categoryName,
                        isExpanded: true,
                        items: state.category.map<DropdownMenuItem<String>>(
                            (CategoryModel value) {
                          return DropdownMenuItem(
                            value: value.categoryName,
                            child: Text(value.categoryName,
                                style: GoogleFonts.nunito(
                                    color: Colors.grey[700])),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Keterangan :',
                        style: GoogleFonts.nunito(
                            fontSize: 13, color: Colors.grey[400]),
                      ),
                      TextFormField(
                        onSaved: (e) => description = e,
                        onChanged: (e) => description = e,
                        validator: (e) {
                          if (e.isEmpty) {
                            return "*Input tidak boleh kosong";
                          }
                        },
                        style: GoogleFonts.nunito(color: Colors.grey[700]),
                        maxLines: 3,
                        controller: TextEditingController(text: description),
                      ),
                    ],
                  ),
                )),
              );
            },
          ),
          actions: <Widget>[
            FlatButton(
              child: Row(
                children: <Widget>[
                  Text('Batal',
                      style: GoogleFonts.nunito(
                          color: Colors.grey[300],
                          fontWeight: FontWeight.w700)),
                ],
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Row(
                children: <Widget>[
                  Text('Ubah',
                      style: GoogleFonts.nunito(
                          color: Colors.green, fontWeight: FontWeight.w700)),
                ],
              ),
              onPressed: () {
                checkFormEditData();
              },
            ),
          ],
        );
      },
    );
  }
}
