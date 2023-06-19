// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:posq/appsmobile.dart';
import 'package:posq/firebase_options.dart';
import 'package:posq/login.dart';
import 'package:posq/mainapps.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';
import 'package:google_fonts/google_fonts.dart';

bool shouldUseFirebaseEmulator = false;

late final FirebaseApp app;
late final FirebaseAuth auth;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp(
    onGenerateRoute: RouteGenerator.generateRoute,
  ));
}

class MyApp extends StatelessWidget {
  // final bool newinstall;
  MyApp({
    Key? key,
    required Route Function(RouteSettings settings) onGenerateRoute,
    /*required this.newinstall*/
  }) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: 'POS Demo',
      builder: EasyLoading.init(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          // <-- SEE HERE
          iconTheme: IconThemeData(color: Colors.black),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.questrialTextTheme(textTheme).copyWith(),
        primarySwatch: Colors.orange,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => /*Mainapps()*/ Login(),
        '/RetailMain': (context) => ClassRetailMainMobile(
              fromsaved: false,
              outletinfo: Outlet(outletcd: '', outletname: ''),
              pscd: '',
              qty: 0,
            ),
        '/Dashboard': (context) => Mainapps(),
      },
    );

    //   home: const Mainapps(
    //     title: 'POS DEMO', /*newinstall:newinstall*/
    //   ),
    // );
  }
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // jika ingin mengirim argument
    // final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => ClassRetailMainMobile(
                  fromsaved: false,
                  outletinfo: Outlet(outletcd: '', outletname: ''),
                  pscd: '',
                  qty: 0,
                ));
      case '/RetailMain':
        return MaterialPageRoute(
            builder: (_) => ClassRetailMainMobile(
                  fromsaved: false,
                  outletinfo: Outlet(outletcd: '', outletname: ''),
                  pscd: '',
                  qty: 0,
                ));
      // return MaterialPageRoute(builder: (_) => AboutPage(args));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return AppsMobile(
        penjualanratarata: [],
        chartdata: [],
        monthlysales: [],
        todaysale: [],
      );
    });
  }
}
