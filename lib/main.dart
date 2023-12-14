// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:posq/appsmobile.dart';
import 'package:posq/classfungsi/classcolorapps.dart';
import 'package:posq/firebase_options.dart';
import 'package:posq/login.dart';
import 'package:posq/mainapps.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/clasretailmainmobile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:posq/systeminfo.dart';
import 'package:posq/userinfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

bool shouldUseFirebaseEmulator = false;
final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  Future<bool> getRetailMode() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'retailmode';
    final value = prefs.getBool(key) ??
        false; // Replace false with a default value if needed
    retailmodes = value;

    print(value);
    return value;
  }
Future<void> _initConfig() async {
  await _remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(
        seconds: 1), // a fetch will wait up to 10 seconds before timing out
    minimumFetchInterval: const Duration(
        seconds: 10), // fetch parameters will be cached for a maximum of 1 hour
  ));

  await _remoteConfig.fetchAndActivate();
  _remoteConfig.getString('mainserver').isNotEmpty;

  mainserver = _remoteConfig.getString('mainserver');
  print("value remote config : ${_remoteConfig.getString('mainserver')}");
}
late final FirebaseApp app;
late final FirebaseAuth auth;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  versions = packageInfo.version;
  builds = packageInfo.buildNumber;
  await Supabase.initialize(
    url: 'https://nombrqzyjbsjrqpdauac.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5vbWJycXp5amJzanJxcGRhdWFjIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTY0OTcyNTAsImV4cCI6MTk3MjA3MzI1MH0.HaMhfDPzjSTLtYYa05gO1C4CcpHKeBaGQChRgq0w3NM',
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
// dev mode //
//  await _initConfig();

 await getRetailMode();


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
  final supabase = Supabase.instance.client;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: 'Aovipos',
      builder: EasyLoading.init(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: AppColors.primaryColor,
          // <-- SEE HERE
          iconTheme: IconThemeData(color: Colors.white),
        ),
        useMaterial3: true,
        primaryColor: AppColors.primaryColor,
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
        '/Dashboard': (context) => Mainapps(
              fromretailmain: true,
            ),
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
