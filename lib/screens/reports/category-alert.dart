import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryAlert extends StatefulWidget {
  final ValueSetter<int> value;
  final BuildContext context;

  CategoryAlert({this.value, this.context});
  @override
  _CategoryAlertState createState() => _CategoryAlertState();
}

class _CategoryAlertState extends State<CategoryAlert> {
  @override
  Widget build(context) {
    return AlertDialog(
          content: StatefulBuilder(
            builder: (context, StateSetter setState) {
              return Container(
                child: SingleChildScrollView(
                    child: Text(
                  'Apakah anda yakin ingin menghapus kategori?',
                  style: GoogleFonts.nunito(color: Colors.grey[700]),
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
                  Text('Ya, hapus',
                      style: GoogleFonts.nunito(
                          color: Colors.green, fontWeight: FontWeight.w700)),
                ],
              ),
              onPressed: () {
                widget.value(1);
                Navigator.pop(context);
                // _categoryBloc.add(DeleteCategory(id: id));
              },
            ),
          ],
        );
  }
}

class AlertTest {
  final ValueSetter<int> value;

  AlertTest(this.value);
  
  void showDialog(BuildContext context){
    AlertDialog(
          content: StatefulBuilder(
            builder: (context, StateSetter setState) {
              return Container(
                child: SingleChildScrollView(
                    child: Text(
                  'Apakah anda yakin ingin menghapus kategori?',
                  style: GoogleFonts.nunito(color: Colors.grey[700]),
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
                  Text('Ya, hapus',
                      style: GoogleFonts.nunito(
                          color: Colors.green, fontWeight: FontWeight.w700)),
                ],
              ),
              onPressed: () {
                value(1);
                Navigator.pop(context);
                // _categoryBloc.add(DeleteCategory(id: id));
              },
            ),
          ],
        );
  }

}