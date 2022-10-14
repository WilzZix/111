import 'package:MyID/autorization/pin_code.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthKeyloak extends StatefulWidget {
  static const String routeName = '/auth_keyloak';
  AuthKeyloak({Key? key}) : super(key: key);

  @override
  State<AuthKeyloak> createState() => _AuthKeyloakState();
}

class _AuthKeyloakState extends State<AuthKeyloak> {
  var userAccessToken;
  var userName;

  var userLoginFild;
  var userPasswordFild;

  var user = 'test';
  var pass = 'test';
  var client = 'lendo-tablet';

  var inn = '1';
  void launchURL() async {
    try {
      var url = Uri.parse(
          'https://auth.flexit.uz/auth/realms/lendo/protocol/openid-connect/token');
      var response = await http.post(url, body: {
        'grant_type': 'password',
        'username': userLoginFild,
        'password': userPasswordFild,
        'client_id': client,
      }, headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      });
      var value = response.body;
      var jsonResponse = convert.jsonDecode(response.body);
      userAccessToken = jsonResponse['access_token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', userAccessToken);
      prefs.setString('userLoginFild', userLoginFild);
      prefs.setString('userPasswordFild', userPasswordFild);

      print('userLoginFild --------------- ${userLoginFild}');
      print('userPasswordFild --------------- ${userPasswordFild}');
      print('userAccessToken --------------- ${userAccessToken}');

      Map<String, dynamic> decodedToken = JwtDecoder.decode(userAccessToken);
      setState(() {
        // print('+++++++++++++++++++ decodedToken ${decodedToken["exp"]}');
        userName = decodedToken["preferred_username"];
        // print('------------------ userName ${userName}');
        // if (decodedToken["preferred_username"] != null) {
        //   Navigator.of(context).pushNamed(PasswordView.routeName);
        // }
      });
      if (userName != null) {
        Navigator.of(context).pushNamed(PasswordView.routeName);
      }
      print('------------------ userName ${userName}');
    } catch (e) {
      print(e);
    }
  }

  void addNewTransaktion(String password, String login) {
    setState(() {
      print(password);
      print(login);

      userLoginFild = login;
      userPasswordFild = password;

      launchURL();
    });

    password = '';
    login = '';
  }

  final passwordCont = TextEditingController();
  final userLogin = TextEditingController();

  void submited() {
    final enteredPasswordCont = passwordCont.text;
    final enteredUserLogin = userLogin.text;

    if (enteredPasswordCont.isEmpty || enteredUserLogin.isEmpty) {
      return;
    }
    addNewTransaktion(enteredPasswordCont, enteredUserLogin);
    print('pressed');
    setState(() {
      print(enteredPasswordCont);
      print(enteredUserLogin);
    });
  }

  void logout() {
    setState(() {
      userName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(247, 247, 247, 1),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.05),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              width: MediaQuery.of(context).size.width * 0.6,
              padding: const EdgeInsets.only(
                  top: 26, bottom: 26, left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Center(
                    child: Text(
                      'Авторизация',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Gap(25),
                  Container(
                    width: double.infinity,
                    height: 56,
                    child: TextField(
                      decoration: const InputDecoration(
                        // labelText: 'Логин пользователя',
                        hintText: "Логин",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(25, 25, 25, 0.32),
                              width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(25, 25, 25, 0.62),
                              width: 1.0),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      autofocus: false,
                      controller: userLogin,
                      onSubmitted: (val) => submited(),
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.black,
                          fontSize: 16),
                    ),
                  ),
                  const Gap(30),
                  Container(
                    width: double.infinity,
                    height: 56,
                    child: TextField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: "Пароль",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(25, 25, 25, 0.32),
                              width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(25, 25, 25, 0.62),
                              width: 1.0),
                        ),
                      ),
                      autocorrect: false,
                      autofocus: false,
                      controller: passwordCont,
                      keyboardType: TextInputType.visiblePassword,
                      onSubmitted: (val) => submited(),
                      style: const TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.black,
                          fontSize: 16),
                    ),
                  ),
                  const Gap(25),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: Color.fromRGBO(220, 9, 46, 1),
                    ),
                    width: double.infinity,
                    height: 36,
                    child: ElevatedButton(
                      child: const Text('ВОЙТИ',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              color: Colors.white)),
                      onPressed: () {
                        submited();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(220, 9, 46, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
