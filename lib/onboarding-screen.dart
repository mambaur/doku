import 'package:dompet_apps/home-screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.green[100],
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Container(
              decoration: BoxDecoration(),
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Flexible(
                        flex: 3,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 4),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.green),
                              child: Text(
                                'Skip',
                                style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 39,
                        child: Container(
                          child: PageView(
                            physics: ClampingScrollPhysics(),
                            controller: _pageController,
                            onPageChanged: (int page) {
                              setState(() {
                                _currentPage = page;
                              });
                            },
                            children: <Widget>[
                              PageContent(
                                title: 'Apa Itu Dompet Saku?',
                                text:
                                    'Dompet saku adalah aplikasi catatan keuangan yang mempermudah anda memanajemen keuangan anda.',
                                imagePath: 'assets/onboarding1.png',
                              ),
                              PageContent(
                                title: 'Mengelola Keuangan Anda!',
                                text:
                                    'Dengan dompet saku, anda bisa mengelola pemasukan dan pengeluaran anda lebih efektif dan efisien.',
                                imagePath: 'assets/onboarding3.png',
                              ),
                              PageContent(
                                title: 'Bikin Kamu Tambah Hemat Loh!',
                                text:
                                    'Kamu dapat melacak pengeluaran setiap hari, sehingga bisa membuat kamu lebih hemat loh.',
                                imagePath: 'assets/onboarding4.png',
                              ),
                            ],
                          ),
                        ),
                      ),
                      _currentPage != _numPages - 1
                          ? Flexible(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: _buildPageIndicator(),
                              ),
                            )
                          : Text(''),
                      _currentPage != _numPages - 1
                          ? Flexible(
                              flex: 2,
                              child: Align(
                                alignment: FractionalOffset.bottomRight,
                                child: FlatButton(
                                  onPressed: () {
                                    _pageController.nextPage(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text('Next',
                                          style: GoogleFonts.nunito(
                                              color: Colors.grey[300],
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20)),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Icon(
                                        Icons.chevron_right,
                                        color: Colors.grey[300],
                                        size: 30.0,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Text(''),
                    ],
                  ))),
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
              height: 50,
              color: Colors.green,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.grey[900],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 5.0, top: 5.0),
                        child: Text(
                          'Mulai Sekarang',
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                ),
              ),
            )
          : Text(''),
    );
  }
}

class PageContent extends StatelessWidget {
  final String imagePath;
  final String title;
  final String text;
  const PageContent({
    Key key,
    this.imagePath,
    this.title,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Flexible(
              flex: 3,
              child: Container(
                  // color: Colors.grey[200],
                  child: Image(
                image: AssetImage(imagePath),
                height: 300.0,
                width: 300.0,
              )),
            ),
            // Center(
            // child: Image(
            //   image: AssetImage(
            //     'assets/gambar1.png'
            //   ),
            //   height: 300.0,
            //   width: 300.0,
            // )
            // ),
            Flexible(
              flex: 1,
              child: Text(
                title,
                style: GoogleFonts.nunito(
                    color: Colors.green,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Flexible(
                flex: 1,
                child: Text(text,
                    style: GoogleFonts.nunito(color: Colors.grey[700]))),
            SizedBox(
              height: 15.0,
            ),
          ],
        ));
  }
}
