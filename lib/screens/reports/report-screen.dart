import 'dart:io';
import 'package:dompet_apps/blocs/report/report_bloc.dart';
import 'package:dompet_apps/screens/reports/report-detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dompet_apps/home-screen.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class LaporanScreen extends StatefulWidget {
  final String params;
  const LaporanScreen({Key key, this.params}) : super(key: key);
  @override
  _LaporanScreenState createState() => _LaporanScreenState(params);
}

class _LaporanScreenState extends State<LaporanScreen> {
  final formatCurrency = new NumberFormat("#,##0", "id");
  String params;
  final pdf = pw.Document();
  _LaporanScreenState(this.params);
  ReportBloc _reportBloc = ReportBloc();
  String tapButtonYears = '2020';
  DateFormat yearFormat, monthFormat, dateFormat, dayFormat;

//   Future<Directory> getExternalStorageDirectory() async {
//   final String path = await _platform.getExternalStoragePath();
//   if (path == null) {
//     return null;
//   }
//   return Directory(path);
// }

  Future savePdf() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String documentPath = directory.path;
    print(documentPath);
    File file = File("$documentPath/Dokureport.pdf");
    file.writeAsBytesSync(pdf.save());
  }

  List<String> minggu = [
    'Minggu ke 1',
    'Minggu ke 2',
    'Minggu ke 3',
    'Minggu ke 4'
  ];

  String selectedMonth;
  String selectedYear;
  String selectedWeek;
  int selectedDay;

  //List untuk mingguan
  List<String> bulan = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];
  List<String> tahun = ['2020', '2021', '2022', '2023'];

  // digunakan untuk refresh indicator
  Future<void> refresh() async {
    _reportBloc.add(GetReport());
  }

  //Setting tanggal, bulan, tahun Sekarang
  dateNow() {
    initializeDateFormatting();
    DateTime b = DateTime.now();
    DateFormat year = DateFormat.y('id');
    DateFormat month = DateFormat.MMMM('id');
    DateFormat day = DateFormat.d('id');
    tapButtonYears = year.format(b);
    selectedMonth = month.format(b);
    selectedDay = int.parse(day.format(b));
    selectedYear = tapButtonYears;

    if (selectedDay <= 7) {
      selectedWeek = 'Minggu ke 1';
    } else if (selectedDay >= 8 && selectedDay <= 14) {
      selectedWeek = 'Minggu ke 2';
    } else if (selectedDay >= 15 && selectedDay <= 21) {
      selectedWeek = 'Minggu ke 3';
    } else {
      selectedWeek = 'Minggu ke 4';
    }
  }

  @override
  void initState() {
    dateNow();

    _reportBloc = BlocProvider.of<ReportBloc>(context);
    _reportBloc.add(ReportInit(params: this.params));
    _reportBloc.add(GetReport());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return BlocListener<ReportBloc, ReportState>(
      cubit: _reportBloc,
      listener: (context, state) {
        if (state is ReportDelete) {
          _messageDialog(context);
          _reportBloc.add(GetReport());
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: params == 'semua' ? 70 : 120),
              child: RefreshIndicator(
                displacement: 10,
                onRefresh: () {
                  return refresh();
                },
                child: BlocBuilder<ReportBloc, ReportState>(
                    cubit: _reportBloc,
                    builder: (context, state) {
                      if (state is ReportWaiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is ReportGetAll) {
                        return _listReport(state, params);
                      }
                      return Container();
                    }),
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                height: 75,
                width: double.infinity,
                color: Colors.white,
                child: SafeArea(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 50,
                          child: FlatButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                              );
                            },
                            child:
                                Icon(Icons.arrow_back, color: Colors.grey[700]),
                          ),
                        ),
                        Icon(Icons.library_books, color: Colors.grey[700]),
                        SizedBox(width: 5),
                        _titleAppBar(params),
                      ],
                    ),
                    // PopupMenuButton(
                    //   icon: Container(
                    //       margin: EdgeInsets.only(right: 15),
                    //       height: 75,
                    //       width: 75,
                    //       child: Icon(Icons.filter_list)),
                    //   itemBuilder: (context) => <PopupMenuEntry<String>>[
                    //     PopupMenuItem<String>(
                    //       child: Text('Print'),
                    //       value: 'print',
                    //     ),
                    //     PopupMenuItem<String>(
                    //       child: Text('Share'),
                    //       value: 'share',
                    //     )
                    //   ],
                    //   onSelected: (item) async {
                    //     if (item == 'print') {
                    //       await savePdf();
                    //       print('ini adalah print');
                    //     } else if (item == 'share') {
                    //       print('ini adalah share');
                    //     }
                    //   },
                    // ),
                    // Container(
                    //     height: 75,
                    //     width: 75,
                    //     child: FlatButton(
                    //         onPressed: () {},
                    //         child: Icon(Icons.filter_list))),
                  ],
                ))),
            _menuReport(),
          ],
        ),
      ),
    );
  }

  _titleAppBar(String params) {
    if (params == 'mingguan') {
      return _titleText('Laporan Mingguan');
    } else if (params == 'bulanan') {
      return _titleText('Laporan Bulanan');
    } else if (params == 'tahunan') {
      return _titleText('Laporan Tahunan');
    } else {
      return _titleText('Semua Transaksi');
    }
  }

  Text _titleText(String title) {
    return Text(title,
        style: GoogleFonts.nunito(
            color: Colors.grey[700],
            fontSize: 20,
            fontWeight: FontWeight.w600));
  }

  ListView _listReport(ReportGetAll state, String params) {
    return ListView.builder(
        padding: EdgeInsets.only(top: 15),
        itemCount: state.transactionGroup.length,
        itemBuilder: (context, index) {
          String datelist = state.transactionGroup[index]["date"];

          //convert String to Datetime
          DateTime dateTime = DateFormat('yyyy-MM-dd').parse(datelist);
          yearFormat = DateFormat.y('id');
          dateFormat = DateFormat.yMMMMEEEEd('id');
          monthFormat = DateFormat.MMMM('id');
          dayFormat = DateFormat.d('id');

          String year = yearFormat.format(dateTime);
          String date = dateFormat.format(dateTime);
          String month = monthFormat.format(dateTime);
          String day = dayFormat.format(dateTime);

          if (year == tapButtonYears && params == 'tahunan') {
            return _listReportView(date, state, index, datelist);
          } else if (year == selectedYear &&
              month == selectedMonth &&
              params == 'bulanan') {
            return _listReportView(date, state, index, datelist);
          } else if (params == 'mingguan' &&
              year == selectedYear &&
              month == selectedMonth) {
            if (int.parse(day) <= 7 && selectedWeek == 'Minggu ke 1') {
              return _listReportView(date, state, index, datelist);
            } else if (int.parse(day) >= 8 &&
                int.parse(day) <= 14 &&
                selectedWeek == 'Minggu ke 2') {
              return _listReportView(date, state, index, datelist);
            } else if (int.parse(day) >= 15 &&
                int.parse(day) <= 21 &&
                selectedWeek == 'Minggu ke 3') {
              return _listReportView(date, state, index, datelist);
            } else if (int.parse(day) >= 22 && selectedWeek == 'Minggu ke 4') {
              return _listReportView(date, state, index, datelist);
            }
          } else if (params == 'semua') {
            return _listReportView(date, state, index, datelist);
          }
          return Container();
        });
  }

  Container _listReportView(
      String date, ReportGetAll state, int index, String dateValue) {
    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Header(level: 0, child: pw.Text('Laporan Transaksi')),
            pw.Column(children: <pw.Widget>[
              pw.ListView.builder(
                itemCount: state.transactionModel.length,
                itemBuilder: (context, index) {
                  return pw.Container(
                      child: pw.Row(children: <pw.Widget>[
                    pw.Flexible(
                      flex: 1,
                      child: pw.Text(state.transactionModel[index]['date']),
                    ),
                    pw.Flexible(
                      flex: 4,
                      child:
                          pw.Text(state.transactionModel[index]['description']),
                    ),
                    pw.Flexible(
                      flex: 1,
                      child: pw.Text(
                          state.transactionModel[index]['categoryPart']),
                    ),
                    pw.Flexible(
                      flex: 1,
                      child: pw.Text(state.transactionModel[index]['balance']),
                    ),
                  ]));
                },
              ),
            ]),
          ];
        }));

    return Container(
        margin: EdgeInsets.only(
          bottom: 15,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.date_range,
                      size: 12,
                      color: Colors.grey[500],
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('$date',
                        style: GoogleFonts.nunito(
                            color: Colors.grey[500], fontSize: 12)),
                  ],
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReportDetail(
                                  date: dateValue, params: params)));
                    },
                    splashColor: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.edit,
                            size: 15,
                            color: Colors.grey[700],
                          ),
                          SizedBox(width: 3),
                          Text('Ubah transaksi',
                              style: GoogleFonts.nunito(
                                color: Colors.grey[700],
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            Container(
              child: ListView.builder(
                  controller: ScrollController(keepScrollOffset: false),
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  itemCount: state.transactionModel.length,
                  itemBuilder: (context, i) {
                    if (state.transactionGroup[index]['date'] ==
                        state.transactionModel[i]['date']) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 2),
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(1, 1),
                              blurRadius: 1)
                        ], color: Colors.white),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {},
                            splashColor: Colors.grey,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          state.transactionModel[i]
                                              ['description'],
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.nunito(
                                              color: Colors.grey[700],
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          '${state.transactionModel[i]['categoryPart']}, ${state.transactionModel[i]['categoryName']}',
                                          style: GoogleFonts.nunito(
                                              color: Colors.grey[300],
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: state.transactionModel[i]
                                                      ['categoryPart'] ==
                                                  'Pemasukan'
                                              ? Colors.green
                                              : Colors.red),
                                      child: Text(
                                        'Rp${formatCurrency.format(int.parse(state.transactionModel[i]['balance']))}',
                                        style: GoogleFonts.nunito(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
            ),
            // Center(
            //   child: GestureDetector(
            //     onTap: () {
            //       _reportBloc.add(
            //           DeleteReport(id: state.transactionGroup[index]["id"]));
            //     },
            //     child: Text('Hapus transaksi'),
            //   ),
            // )
          ],
        ));
  }

  _menuReport() {
    if (params == 'mingguan') {
      return _mingguanMenu();
    } else if (params == 'bulanan') {
      return _bulananMenu();
    } else if (params == 'tahunan') {
      return _tahunanMenu();
    } else if (params == 'semua') {
      return Container();
    }
  }

  Container _mingguanMenu() {
    return Container(
        margin: EdgeInsets.only(top: 75),
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0, 5),
              blurRadius: 5)
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            Flexible(
              flex: 1,
              child: DropdownButton(
                style:
                    GoogleFonts.nunito(fontSize: 13, color: Colors.grey[700]),
                isExpanded: true,
                value: selectedWeek,
                items: minggu.map((mingg) {
                  return DropdownMenuItem(
                    value: mingg,
                    child: Text(mingg),
                  );
                }).toList(),
                onChanged: (String value) {
                  setState(() {
                    selectedWeek = value;
                  });
                },
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Flexible(
              flex: 1,
              child: DropdownButton(
                style:
                    GoogleFonts.nunito(fontSize: 13, color: Colors.grey[700]),
                isExpanded: true,
                value: selectedMonth,
                items: bulan.map((bul) {
                  return DropdownMenuItem(
                    value: bul,
                    child: Text(
                      bul,
                      style: GoogleFonts.nunito(fontSize: 13),
                    ),
                  );
                }).toList(),
                onChanged: (String value) {
                  setState(() {
                    selectedMonth = value;
                  });
                },
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Flexible(
              flex: 1,
              child: DropdownButton(
                style:
                    GoogleFonts.nunito(fontSize: 13, color: Colors.grey[700]),
                isExpanded: true,
                value: selectedYear,
                items: tahun.map((thn) {
                  return DropdownMenuItem(
                    value: thn,
                    child: Text(thn),
                  );
                }).toList(),
                onChanged: (String value) {
                  setState(() {
                    selectedYear = value;
                  });
                },
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ));
  }

  Container _tahunanMenu() {
    return Container(
      margin: EdgeInsets.only(top: 75),
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 5),
            blurRadius: 5)
      ]),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 5),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _buttonYears('2020'),
          _buttonYears('2021'),
          _buttonYears('2022'),
          _buttonYears('2023'),
          _buttonYears('2024'),
          _buttonYears('2025'),
        ],
      ),
    );
  }

  Container _bulananMenu() {
    return Container(
      margin: EdgeInsets.only(top: 75),
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 5),
            blurRadius: 5)
      ]),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 15,
          ),
          Flexible(
            flex: 1,
            child: DropdownButton<String>(
              isExpanded: true,
              onChanged: (String value) {
                setState(() {
                  selectedMonth = value;
                });
              },
              value: selectedMonth,
              items: <String>[
                'Januari',
                'Februari',
                'Maret',
                'April',
                'Mei',
                'Juni',
                'Juli',
                'Agustus',
                'September',
                'Oktober',
                'November',
                'Desember'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,
                      style: GoogleFonts.nunito(color: Colors.grey[700])),
                );
              }).toList(),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Flexible(
            flex: 1,
            child: DropdownButton<String>(
              isExpanded: true,
              onChanged: (String value) {
                setState(() {
                  selectedYear = value;
                });
              },
              value: selectedYear,
              items: <String>['2020', '2021', '2022', '2023', '2024']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,
                      style: GoogleFonts.nunito(color: Colors.grey[700])),
                );
              }).toList(),
            ),
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }

  _buttonYears(String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          tapButtonYears = title;

          // //Convert DateTime to String
          // DateTime b = DateTime.now();
          // DateFormat formater = DateFormat('yyyy-MM-dd');
          // String tanggal = formater.format(b);
          // // print(tanggal);

          // //convert String to Datetime
          // DateTime form = DateFormat('yyyy-MM-dd').parse(tanggal);

          // //Convert DateTime to DateFormat
          // DateFormat formater2 = DateFormat.yMMMMEEEEd('id');
          // String a = formater2.format(form);
          // // print(a);

          // //Print just one part
          // DateFormat year = DateFormat.y('id');
          // print(year.format(b));
        });
      },
      child: Container(
          height: 30,
          margin: EdgeInsets.only(top: 5, bottom: 10, left: 5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: tapButtonYears == title ? Colors.green : Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    blurRadius: 5,
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(2, 2))
              ]),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            title,
            style: GoogleFonts.nunito(
                color:
                    tapButtonYears == title ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.w700),
          )),
    );
  }

  Future _messageDialog(context) async {
    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: <Widget>[
              Icon(Icons.check_circle, color: Colors.green, size: 40),
              SizedBox(
                width: 5,
              ),
              Text('Sukses!'),
            ],
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                child: SingleChildScrollView(
                    child: Text(
                  'Transaksi berhasil dihapus',
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
              },
            ),
          ],
        );
      },
    );
  }
}
