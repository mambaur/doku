import 'package:dompet_apps/blocs/report/report_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PemasukanScreen extends StatefulWidget {
  @override
  _PemasukanScreenState createState() => _PemasukanScreenState();
}

class _PemasukanScreenState extends State<PemasukanScreen> {
  ReportBloc _reportBloc = ReportBloc();
  final formatCurrency = new NumberFormat("#,##0", "id");

  // digunakan untuk refresh indicator
  Future<void> refresh() async {
    _reportBloc.add(GetReportPemasukan());
  }

  @override
  void initState() {
    _reportBloc = BlocProvider.of<ReportBloc>(context);
    _reportBloc.add(GetReportPemasukan());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pemasukan',
          style: GoogleFonts.nunito(color: Colors.grey[700]),
        ),
        backgroundColor: Colors.white,
        leading: FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.grey[700])),
      ),
      body: BlocBuilder<ReportBloc, ReportState>(
        cubit: _reportBloc,
        builder: (context, state) {
          if (state is ReportInitial) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is GetPemasukan) {
            if (state.data.isEmpty) {
              return Center(
                  child: Text('Belum ada transaksi',
                      style: GoogleFonts.nunito(color: Colors.grey[700])));
            }
            return RefreshIndicator(
              onRefresh: () {
                return refresh();
              },
              child: ListView.builder(
                  itemCount: state.data.length,
                  itemBuilder: (context, index) {
                    return Container(
                        margin: EdgeInsets.only(bottom: 3),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 2),
                                blurRadius: 2)
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(state.data[index]['date']),
                                Text(state.data[index]['description']),
                              ],
                            ),
                            Text(
                                'Rp${formatCurrency.format(int.parse(state.data[index]['balance']))}'),
                          ],
                        ));
                  }),
            );
          }
          // if(state is ReportWaiting){
          //   return Center(child: CircularProgressIndicator(),);
          // }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
