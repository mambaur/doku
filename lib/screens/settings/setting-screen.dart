import 'package:dompet_apps/screens/categories/category-screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class PengaturanScreen extends StatefulWidget {
  @override
  _PengaturanScreenState createState() => _PengaturanScreenState();
}

class _PengaturanScreenState extends State<PengaturanScreen> {
  showToast() {
    Fluttertoast.showToast(
        msg: 'Fitur akan tersedia segera',
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.grey[700],
        fontSize: 12);
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: <Widget>[
          ListView(
            padding: EdgeInsets.only(top: 80),
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Text('Pengelolaan',
                    style: GoogleFonts.nunito(
                        fontSize: 18,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600)),
              ),
              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      leading: Text('Mata uang',
                          style: GoogleFonts.nunito(
                              fontSize: 15,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w600)),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () => showToast(),
                    ),
                    Divider(
                      height: 0.1,
                      thickness: 0.5,
                    ),
                    ListTile(
                      leading: Text('Kategori',
                          style: GoogleFonts.nunito(
                              fontSize: 15,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600)),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => CategoryScreen()),
                        );
                      },
                    ),
                    Divider(
                      height: 0.1,
                      thickness: 0.5,
                    ),
                    ListTile(
                      leading: Text('Template',
                          style: GoogleFonts.nunito(
                              fontSize: 15,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w600)),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () => showToast(),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Text('Konfigurasi',
                    style: GoogleFonts.nunito(
                        fontSize: 18,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600)),
              ),
              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      leading: Text('Bahasa',
                          style: GoogleFonts.nunito(
                              fontSize: 15,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w600)),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () => showToast(),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Text('Cadangkan',
                    style: GoogleFonts.nunito(
                        fontSize: 18,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600)),
              ),
              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      leading: Text('Googledrive',
                          style: GoogleFonts.nunito(
                              fontSize: 15,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w600)),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () => showToast(),
                    ),
                    Divider(
                      height: 0.1,
                      thickness: 0.5,
                    ),
                    ListTile(
                      leading: Text('DropBox',
                          style: GoogleFonts.nunito(
                              fontSize: 15,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w600)),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () => showToast(),
                    ),
                    Divider(
                      height: 0.1,
                      thickness: 0.5,
                    ),
                    ListTile(
                      leading: Text('Local',
                          style: GoogleFonts.nunito(
                              fontSize: 15,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w600)),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () => showToast(),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Text('Lainnya',
                    style: GoogleFonts.nunito(
                        fontSize: 18,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600)),
              ),
              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // SettingButton(title: 'Rating Apps'),
                    // Divider(
                    //   height: 0.1,
                    //   thickness: 0.5,
                    // ),
                    // SettingButton(title: 'Kebijakan Privasi'),
                    // Divider(
                    //   height: 0.1,
                    //   thickness: 0.5,
                    // ),
                    SettingButton(title: 'Versi 1.0'),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              )
            ],
          ),
          Container(
            height: 80,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: Offset(0, 3),
                  blurRadius: 5)
            ]),
            child: SafeArea(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                        splashColor: Colors.grey[800],
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.arrow_back,
                            size: 22,
                            color: Colors.grey[800],
                          ),
                        )),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text('Pengaturan',
                      style: GoogleFonts.nunito(
                          fontSize: 22,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w600)),
                  Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingButton extends StatelessWidget {
  final String title;
  final Widget widget;

  const SettingButton({Key key, this.title, this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 0,
      splashColor: Colors.grey,
      color: Colors.white,
      onPressed: () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title,
                style: GoogleFonts.nunito(
                    fontSize: 15,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w600)),
            Icon(Icons.chevron_right, color: Colors.grey[700])
          ],
        ),
      ),
    );
  }
}
