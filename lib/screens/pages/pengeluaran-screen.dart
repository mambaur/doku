import 'package:dompet_apps/blocs/report/report_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PengeluaranScreen extends StatefulWidget {
  @override
  _PengeluaranScreenState createState() => _PengeluaranScreenState();
}

class _PengeluaranScreenState extends State<PengeluaranScreen> {
  ReportBloc _reportBloc = ReportBloc();
  final formatCurrency = new NumberFormat("#,##0", "id");

  // digunakan untuk refresh indicator
  Future<void> refresh() async {
    _reportBloc.add(GetReportPengeluaran());
  }

  @override
  void initState() {
    _reportBloc = BlocProvider.of<ReportBloc>(context);
    _reportBloc.add(GetReportPengeluaran());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pengeluaran',
          style: GoogleFonts.nunito(color: Colors.grey[700]),
        ),
        backgroundColor: Colors.white,
        leading: FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.grey[700])),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return refresh();
        },
        displacement: 2.5,
        child: BlocBuilder<ReportBloc, ReportState>(
          cubit: _reportBloc,
          builder: (context, state) {
            if (state is GetPengeluaran) {
              if (state.data.isEmpty) {
                return Center(
                    child: Text('Belum ada transaksi',
                        style: GoogleFonts.nunito(color: Colors.grey[700])));
              }
              return ListView.builder(
                  itemCount: state.data.length,
                  itemBuilder: (context, index) {
                    return Container(
                        margin: EdgeInsets.only(bottom: 3),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                  });
            }
            if (state is ReportWaiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
