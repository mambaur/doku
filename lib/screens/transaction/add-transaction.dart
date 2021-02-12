import 'package:dompet_apps/home-screen.dart';
import 'package:dompet_apps/screens/transaction/add-pemasukan.dart';
import 'package:dompet_apps/screens/transaction/add-pengeluaran.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTransaction extends StatefulWidget {
  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  int tap = 0;

  _backPress() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
      onWillPop: () => _backPress(),
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              height: 60,
              child: Row(
                children: <Widget>[
                  Container(
                    width: 60,
                    height: 60,
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () => _backPress(),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Text(
                    'Tambah Transaksi',
                    style: GoogleFonts.nunito(
                        color: Colors.grey[700],
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 60),
              child: Row(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Container(
                      color: tap == 0 ? Colors.green : Colors.grey[200],
                      height: 50,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              tap = 0;
                            });
                          },
                          splashColor: Colors.grey[800],
                          child: Center(
                            child: Text('Pemasukan',
                                style: GoogleFonts.nunito(
                                    color: tap == 0
                                        ? Colors.white
                                        : Colors.grey[800],
                                    fontSize: 15)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      color: tap != 0 ? Colors.orange : Colors.grey[200],
                      height: 50,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              tap = 1;
                            });
                          },
                          splashColor: Colors.grey[800],
                          child: Center(
                            child: Text('Pengeluaran',
                                style: GoogleFonts.nunito(
                                    color: tap != 0
                                        ? Colors.white
                                        : Colors.grey[800],
                                    fontSize: 15)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 110),
                child: tap == 0 ? AddPemasukan() : AddPengeluaran())
          ],
        ),
      ),
    ));
  }
}
