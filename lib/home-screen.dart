import 'package:dompet_apps/repositories/database/apps-database.dart';
import 'package:dompet_apps/screens/categories/category-screen.dart';
import 'package:dompet_apps/screens/pages/pemasukan-screen.dart';
import 'package:dompet_apps/screens/pages/pengeluaran-screen.dart';
import 'package:dompet_apps/screens/reports/report-screen.dart';
import 'package:dompet_apps/screens/settings/setting-screen.dart';
import 'package:dompet_apps/screens/transaction/add-transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

import 'models/report-charts.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formatCurrency = new NumberFormat("#,##0", "id");
  AppsDatabase db = AppsDatabase();
  ReportChart report;
  var pemasukanBalance, pengeluaranBalance, lastTransaction, ketLastTransaction;
  int balance = 0;

  //Ketika user menekan tombol back smartphone
  DateTime currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: 'Tekan lagi untuk keluar',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.grey[700],
          fontSize: 12);
      return Future.value(false);
    }
    return Future.value(true);
  }

  List<ReportChart> dataPemasukan = [];
  List<ReportChart> dataPengeluaran = [];

  getChart() async {
    var getPengeluaran = await db.getReportChartPengeluaran();
    var getPemasukan = await db.getReportChartPemasukan();
    setState(() {
      dataPengeluaran = getPengeluaran;
      dataPemasukan = getPemasukan;
      dataPemasukan.sort((a, b) => a.day.compareTo(b.day));
      dataPengeluaran.sort((a, b) => a.day.compareTo(b.day));
    });
  }

  //Mendapatkan nilai balance
  _getBalance() async {
    var pemasukan = await db.getBalancePemasukan();
    var pengeluaran = await db.getBalancePengeluaran();
    var lastTrans = await db.getBalanceLastTransaction();
    setState(() {
      pemasukan[0]['Total'] == null
          ? pemasukanBalance = 0
          : pemasukanBalance = pemasukan[0]['Total'];
      pengeluaran[0]['Total'] == null
          ? pengeluaranBalance = 0
          : pengeluaranBalance = pengeluaran[0]['Total'];
      lastTrans.length == 0
          ? lastTransaction = 0
          : lastTransaction = lastTrans[0]['balance'];
      lastTrans.length == 0
          ? ketLastTransaction = 'Belum ada transaksi'
          : ketLastTransaction = lastTrans[0]['categoryPart'];
      balance = pemasukanBalance - pengeluaranBalance;
    });
  }

  // Refresh Indicator
  Future<void> refresh() async {
    _getBalance();
    getChart();
  }

  @override
  void initState() {
    _getBalance();
    getChart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerHome(),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              RefreshIndicator(
                displacement: 15,
                onRefresh: () {
                  return refresh();
                },
                child: ListView(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(
                            top: 10, left: 10, bottom: 5, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              flex: 4,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    flex: 2,
                                    child: Container(
                                      width: 50,
                                      child: FlatButton(
                                        onPressed: () => _scaffoldKey
                                            .currentState
                                            .openDrawer(),
                                        child: Icon(Icons.menu,
                                            color: Colors.grey[800]),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 3,
                                    child: Text(
                                      'DOKU',
                                      style: GoogleFonts.nunito(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[800]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 5,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Flexible(
                                    flex: 5,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.green[500],
                                                Colors.green[400],
                                                Colors.green[300],
                                              ]),
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 5,
                                                color: Colors.grey[200],
                                                offset: Offset(0, 5))
                                          ]),
                                      child: Text(
                                        'Rp${formatCurrency.format(balance)}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddTransaction()),
                                        );
                                      },
                                      child: ClipOval(
                                          child: Container(
                                              color: Colors.grey[300],
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              ))),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )),
                    Container(
                      margin: EdgeInsets.only(
                          top: 5, left: 10, right: 10, bottom: 5),
                      padding: EdgeInsets.all(15),
                      height: 195,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 5,
                                color: Colors.grey[200],
                                offset: Offset(0, 5))
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CardBalance(
                            pemasukanBalance: pemasukanBalance,
                            pengeluaranBalance: pengeluaranBalance,
                            formatCurrency: formatCurrency,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Flexible(
                                  flex: 1,
                                  fit: FlexFit.loose,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Transaksi terakhir',
                                          style: GoogleFonts.nunito(
                                              fontSize: 12,
                                              color: Colors.grey[700])),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Container(
                                          width: double.infinity,
                                          height: 30,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: Colors.grey[200])),
                                          child: Text(
                                              lastTransaction != null
                                                  ? 'Rp${formatCurrency.format(lastTransaction is int ? lastTransaction : int.parse(lastTransaction))} ($ketLastTransaction)'
                                                  : 'Belum ada transaksi',
                                              style: GoogleFonts.nunito(
                                                  fontSize: 10,
                                                  color: Colors.grey[800]))),
                                      SizedBox(
                                        height: 7,
                                      )
                                    ],
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                  flex: 1,
                                  fit: FlexFit.loose,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Pengaturan',
                                          style: GoogleFonts.nunito(
                                              fontSize: 12,
                                              color: Colors.grey[700])),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PengaturanScreen()),
                                          );
                                        },
                                        child: Container(
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                  colors: [
                                                    // Colors.grey[300],
                                                    Colors.grey[200],
                                                    Colors.grey[100],
                                                  ]),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(Icons.settings,
                                                    color: Colors.grey[700],
                                                    size: 15),
                                                Text(
                                                  ' Pengaturan',
                                                  style: GoogleFonts.nunito(
                                                      fontSize: 12,
                                                      color: Colors.grey[700]),
                                                ),
                                                Icon(Icons.chevron_right,
                                                    color: Colors.grey[700],
                                                    size: 15)
                                              ],
                                            )),
                                      ),
                                      SizedBox(
                                        height: 7,
                                      )
                                    ],
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Lihat Transaksiku',
                            style: GoogleFonts.nunito(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey[400]),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.chevron_right,
                              color: Colors.grey[300], size: 15),
                        ],
                      ),
                    ),
                    Container(
                        height: 50,
                        child: ListView(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            _FilterLaporan(
                              title: 'Mingguan',
                              widget: LaporanScreen(
                                params: 'mingguan',
                              ),
                            ),
                            _FilterLaporan(
                                title: 'Bulanan',
                                widget: LaporanScreen(params: 'bulanan')),
                            _FilterLaporan(
                                title: 'Tahunan',
                                widget: LaporanScreen(params: 'tahunan')),
                            _FilterLaporan(
                                title: 'Semua',
                                widget: LaporanScreen(params: 'semua')),
                          ],
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Grafik transaksi pemasukan',
                            style: GoogleFonts.nunito(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey[400]),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.chevron_right,
                              color: Colors.grey[300], size: 15),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          top: 5, left: 15, right: 15, bottom: 15),
                      color: Colors.white,
                      child: lastTransaction != 0
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 200,
                                  child: charts.BarChart(
                                    [
                                      charts.Series(
                                        id: 'Pemasukan',
                                        domainFn: (report, _) => report.day,
                                        measureFn: (report, _) => report.value,
                                        colorFn: (report, _) => report.color,
                                        data: dataPemasukan,
                                      ),
                                    ],
                                    animate: true,
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              height: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text('Belum ada transaksi',
                                      style: GoogleFonts.nunito(
                                          color: Colors.grey[400])),
                                  Text(
                                      'Tambah transaksi untuk dapat melihat grafik pemasukan',
                                      style: GoogleFonts.nunito(
                                          color: Colors.grey[300],
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Grafik transaksi pengeluaran',
                            style: GoogleFonts.nunito(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey[400]),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.chevron_right,
                              color: Colors.grey[300], size: 15),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          top: 5, left: 15, right: 15, bottom: 15),
                      color: Colors.white,
                      child: lastTransaction != 0
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 200,
                                  child: charts.BarChart(
                                    [
                                      charts.Series(
                                        id: 'Pengeluaran',
                                        domainFn: (report, _) => report.day,
                                        measureFn: (report, _) => report.value,
                                        colorFn: (report, _) => report.color,
                                        data: dataPengeluaran,
                                      ),
                                    ],
                                    animate: true,
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              height: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text('Belum ada transaksi',
                                      style: GoogleFonts.nunito(
                                          color: Colors.grey[400])),
                                  Text(
                                      'Tambah transaksi untuk dapat melihat grafik pengeluaran',
                                      style: GoogleFonts.nunito(
                                          color: Colors.grey[300],
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 8, left: 10, right: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 5,
                                color: Colors.grey[200],
                                offset: Offset(0, 5))
                          ]),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => PemasukanScreen()),
                            );
                          },
                          splashColor: Colors.grey[600],
                          borderRadius: BorderRadius.circular(10),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            leading: Icon(
                              Icons.book,
                            ),
                            title: Text('Semua Pemasukan',
                                style: GoogleFonts.nunito(
                                    fontSize: 15, color: Colors.grey[700])),
                            trailing: Icon(
                              Icons.chevron_right,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 8, left: 10, right: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 5,
                                color: Colors.grey[200],
                                offset: Offset(0, 5))
                          ]),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => PengeluaranScreen()),
                            );
                          },
                          splashColor: Colors.grey[600],
                          borderRadius: BorderRadius.circular(10),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            leading: Icon(Icons.library_books),
                            title: Text('Semua Pengeluaran',
                                style: GoogleFonts.nunito(
                                    fontSize: 15, color: Colors.grey[700])),
                            trailing: Icon(Icons.chevron_right),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
              Container(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 5,
                                color: Colors.black.withOpacity(0.3),
                                offset: Offset(2, 2))
                          ]),
                      margin: EdgeInsets.only(bottom: 15),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => AddTransaction()),
                            );
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //       builder: (context) => AddTransactionScreen()),
                            // );
                          },
                          splashColor: Colors.grey[100],
                          highlightColor: Colors.black,
                          borderRadius: BorderRadius.circular(25),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 18, vertical: 12),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddTransaction()),
                                    );
                                  },
                                  child: ClipOval(
                                      child: Container(
                                          color: Colors.grey[300],
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.green,
                                          ))),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Tambah Transaksi',
                                  style: GoogleFonts.nunito(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerHome extends StatelessWidget {
  const DrawerHome({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // elevation: 1,
      child: Column(
        children: <Widget>[
          // UserAccountsDrawerHeader(
          //   accountName: Text("xyz"),
          //   accountEmail: Text("xyz@gmail.com"),
          //   currentAccountPicture: CircleAvatar(
          //     backgroundColor: Colors.white,
          //     child: Text("xyz"),
          //   ),
          //   otherAccountsPictures: <Widget>[
          //     Material(
          //         color: Colors.transparent,
          //         child: InkWell(
          //             onTap: () => Navigator.pop(context),
          //             child: Icon(Icons.close, color: Colors.white)))
          //   ],
          // ),
          SafeArea(
            child: Container(
              height: 120,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 15,
                    right: 20,
                    child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Icon(Icons.close, color: Colors.grey[700]))),
                  ),
                  Positioned(
                    top: 35,
                    left: 15,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.account_balance_wallet,
                          color: Colors.grey[700],
                          size: 35,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'DOKU',
                          style: GoogleFonts.nunito(
                              fontSize: 35,
                              fontWeight: FontWeight.w700,
                              color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            height: 0.1,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddTransaction()),
              );
            },
            title: new Text(
              "Tambah Transaksi",
              style: GoogleFonts.nunito(color: Colors.grey[700]),
            ),
            leading: new Icon(Icons.add_circle),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(
            height: 0.1,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CategoryScreen()),
              );
            },
            title: new Text("Kategori",
                style: GoogleFonts.nunito(color: Colors.grey[700])),
            leading: new Icon(Icons.category),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(
            height: 0.1,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PengaturanScreen()),
              );
            },
            title: new Text("Pengaturan",
                style: GoogleFonts.nunito(color: Colors.grey[700])),
            leading: new Icon(Icons.settings),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(
            height: 0.1,
          ),
          ListTile(
            onTap: () {
              _aboutDialog(context);
            },
            title: new Text("Tentang Aplikasi",
                style: GoogleFonts.nunito(color: Colors.grey[700])),
            leading: new Icon(Icons.info),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(
            height: 0.1,
          ),
        ],
      ),
    );
  }

  Future _aboutDialog(context) async {
    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Tentang Aplikasi',
            style: GoogleFonts.nunito(
                color: Colors.grey[700], fontWeight: FontWeight.w700),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Nama Aplikasi : Dompet Saku',
                      style: GoogleFonts.nunito(color: Colors.grey[700]),
                    ),
                    Text(
                      'Author : @bauroziq',
                      style: GoogleFonts.nunito(color: Colors.grey[700]),
                    ),
                    Text(
                      'Versi : 1.0',
                      style: GoogleFonts.nunito(color: Colors.grey[700]),
                    ),
                  ],
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

class CardBalance extends StatelessWidget {
  final dynamic pemasukanBalance;
  final dynamic pengeluaranBalance;
  final formatCurrency;
  const CardBalance(
      {Key key,
      this.pemasukanBalance,
      this.pengeluaranBalance,
      this.formatCurrency})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 1,
          fit: FlexFit.loose,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Total Pemasukan',
                  style: GoogleFonts.nunito(
                      fontSize: 12, color: Colors.grey[700])),
              SizedBox(
                height: 2,
              ),
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.green[500],
                          Colors.green[400],
                          Colors.green[300],
                        ]),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 5,
                          color: Colors.grey[200],
                          offset: Offset(0, 5))
                    ]),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Icon(
                        Icons.payment,
                        size: 80,
                        color: Colors.green,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10, right: 10),
                      alignment: Alignment.bottomRight,
                      child: Text(
                          pemasukanBalance == null
                              ? 'Rp0'
                              : 'Rp${formatCurrency.format(pemasukanBalance).toString()}',
                          style: GoogleFonts.nunito(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w900)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(width: 10),
        Flexible(
          flex: 1,
          fit: FlexFit.loose,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Total pengeluaran',
                  style: GoogleFonts.nunito(
                      fontSize: 12, color: Colors.grey[700])),
              SizedBox(
                height: 2,
              ),
              Container(
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.orange[400],
                          Colors.orange[300],
                          Colors.orange[200],
                        ]),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 5,
                          color: Colors.grey[200],
                          offset: Offset(0, 5))
                    ]),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Icon(
                        Icons.account_balance_wallet,
                        size: 80,
                        color: Colors.orange[400],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10, right: 10),
                      alignment: Alignment.bottomRight,
                      child: Text(
                          pengeluaranBalance == null
                              ? 'Rp0'
                              : 'Rp${formatCurrency.format(pengeluaranBalance).toString()}',
                          style: GoogleFonts.nunito(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w900)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _FilterLaporan extends StatelessWidget {
  final String title;
  final Widget widget;

  const _FilterLaporan({Key key, this.title, this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      height: 50,
      width: 120,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[200], offset: Offset(3, 3), blurRadius: 3)
          ]),
      child: Material(
          color: Colors.transparent,
          child: InkWell(
              splashColor: Colors.grey[600],
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => widget),
                );
              },
              child: Center(
                  child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
              )))),
    );
  }
}
