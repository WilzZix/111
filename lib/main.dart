import 'dart:io';
import 'package:MyID/pages/infopage/grafic8/graph8-message.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'auth_pages/fingerprint_page.dart';
import 'autorization/auth_keyloak.dart';
import 'autorization/second_pin_code_auth.dart';
import 'old_test/my_id.dart';
import 'pages/home_pages.dart';
import 'old_test/ilentification_list.dart';
import 'pages/info_pages.dart';
import 'autorization/pin_code.dart';
import 'pages/infopage/detali_zayavki.dart';
import 'pages/infopage/doctavka9.dart';
import 'pages/infopage/dogovor6.dart';
import 'pages/infopage/grafic8/grafic8.dart';
import 'pages/infopage/oformlenie/oformlenie5.dart';
import 'pages/infopage/potverjdenie/podtvejdenie7_csm_code.dart';
import 'pages/infopage/potverjdenie/podtverjenie7.dart';
import 'pages/infopage/sostav_zakaza0/sostav_zakaza.dart';
import 'pages/infopage/sostav_zakaza0/sostav_zakaza_search.dart';
import 'old_test/test.dart';
import 'pages/infopage/dannie2.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

MaterialColor mycolorBlack = MaterialColor(
  0xFF000000,
  <int, Color>{
    50: Color.fromARGB(255, 0, 0, 0),
    100: Color.fromARGB(255, 0, 0, 0),
    200: Color.fromARGB(255, 0, 0, 0),
    300: Color.fromARGB(255, 0, 0, 0),
    400: Color.fromARGB(255, 0, 0, 0),
    500: Color.fromARGB(255, 0, 0, 0),
    600: Color.fromARGB(255, 0, 0, 0),
    700: Color.fromARGB(255, 0, 0, 0),
    800: Color.fromARGB(255, 0, 0, 0),
    900: Color.fromARGB(255, 0, 0, 0),
  },
);

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lendo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        textTheme: ThemeData.light().textTheme.copyWith(
              subtitle1: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(14, 51, 86, 1)),
              subtitle2: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(34, 34, 34, 1)),
            ),
      ),
      home: SafeArea(minimum: const EdgeInsets.all(0.0), child: View1()),
      routes: {
        HomePagesScreen.routeName: (context) => HomePagesScreen(),
        IdentificationList.routeName: (context) => IdentificationList(),
        PasswordView.routeName: (context) => PasswordView(),
        InfoPage.routeName: (context) => InfoPage(
              userId: '',
            ),
        Test.routeName: (context) => Test(),
        SecondPinCodeAuth.routeName: (context) => SecondPinCodeAuth(),
        AuthKeyloak.routeName: (context) => AuthKeyloak(),
        FingerprintAuth.routeName: (context) => FingerprintAuth(),
        Dannie2.routeName: (context) => Dannie2(
              userId: '',
            ),
        View.routeName: (context) => View(),
        SostavZakaza.routeName: (context) => SostavZakaza(userId: ''),
        SostavZakazaSearch.routeName: (context) =>
            SostavZakazaSearch(userId: ''),
        Oformlenie5.routeName: (context) => Oformlenie5(userId: ''),
        Dogovor6.routeName: (context) => Dogovor6(userId: ''),
        Dostavka9.routeName: (context) => Dostavka9(),
        Podverjenie7.routeName: (context) => Podverjenie7(
              userId: '',
              userData: '',
              userDataCartNumber: '',
              userConfirmed: '',
              msg: '',
            ),
        Grafic8.routeName: (context) => Grafic8(
              userId: '',
              monthly: '',
              overpay: '',
              period: '',
              productTotal: '',
              reportUrl: '',
              total: '',
            ),
        Grafic8Message.routeName: (context) =>
            Grafic8Message(userId: '', data: '', msg: ''),
        Podtvejdenie7SmsCode.routeName: (context) =>
            Podtvejdenie7SmsCode(userId: ''),
        DetaliZakaza.routeName: (context) => DetaliZakaza(
              userId: '',
            ),
      },
    );
  }
}

class View1 extends StatefulWidget {
  const View1({Key? key}) : super(key: key);

  @override
  State<View1> createState() => _View1State();
}

class _View1State extends State<View1> {
  var lastList = [];
  bool autentificate = false;
  var takeToken = '';
  var userLogin = '';
  var userPassword = '';

  loadLocaleStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      lastList = prefs.getStringList('pinCode') as List<String>;
      autentificate = prefs.getBool('auth')!;
      takeToken = prefs.getString('token')!;
      userLogin = prefs.getString('userLoginFild')!;
      userPassword = prefs.getString('userPasswordFild')!;
    });
  }

  void showSecondPinCodeAuth() async {
    await Future.delayed(Duration(seconds: 1));
    if (autentificate == true) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SecondPinCodeAuth()));
    }
  }

  void showAuthKeyloak() async {
    await Future.delayed(Duration(seconds: 1));
    if (autentificate == false) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AuthKeyloak()));
    }
  }

  var client = 'lendo-tablet';
  final now = DateTime.now().millisecondsSinceEpoch;
  @override
  void initState() {
    super.initState();
    loadLocaleStorage();
    showSecondPinCodeAuth();
    showAuthKeyloak();
  }

  @override
  Widget build(BuildContext context) {
    print('------------------ takeToken ${takeToken}');

    print('date ${now}');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.of(context).pushNamed(HomePagesScreen.routeName);
            //   },
            //   child: const Text('Home'),
            // ),
          ],
        ),
      ),
    );
  }
}
