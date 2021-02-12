import 'package:dompet_apps/blocs/category/category_bloc.dart';
import 'package:dompet_apps/blocs/report/report_bloc.dart';
import 'package:dompet_apps/blocs/transaction/transaction_bloc.dart';
import 'package:dompet_apps/home-screen.dart';
import 'package:dompet_apps/onboarding-screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

int initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  print('initScreen $initScreen');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoryBloc>(
          create: (BuildContext context) => CategoryBloc(),
        ),
        BlocProvider<ReportBloc>(
          create: (BuildContext context) => ReportBloc(),
        ),
        BlocProvider<TransactionBloc>(
          create: (BuildContext context) => TransactionBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Dompet Saku',
        debugShowCheckedModeBanner: false,
        home: SplashScreen(
            seconds: 4,
            navigateAfterSeconds: initScreen == 0 || initScreen == null
                ? OnboardingScreen()
                : HomeScreen(),
            title: Text('DOKU',
                style: GoogleFonts.nunito(
                    fontSize: 40,
                    color: Colors.green,
                    fontWeight: FontWeight.w700)),
            backgroundColor: Colors.white,
            styleTextUnderTheLoader: TextStyle(),
            onClick: () => print("Splash Screen"),
            loaderColor: Colors.grey[200]),
      ),
    );
  }
}
