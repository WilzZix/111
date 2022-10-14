import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:local_auth/local_auth.dart';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../pages/home_pages.dart';

class PasswordView extends StatefulWidget {
  static const String routeName = '/pinCode';
  @override
  _PasswordViewState createState() => _PasswordViewState();
}

class _PasswordViewState extends State<PasswordView> {
  final auth = LocalAuthentication();
  String authorized = " not authorized";
  bool _canCheckBiometric = false;
  late List<BiometricType> _availableBiometric;

  Future<void> _authenticate() async {
    bool authenticated = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      authenticated = await auth.authenticate(
        localizedReason:
            'Отсканируйте отпечаток пальца, чтобы получить доступ к приложению',
        options: const AuthenticationOptions(
            biometricOnly: true, useErrorDialogs: true, stickyAuth: true),
      );
    } on PlatformException catch (e) {
      print(e);
    }

    setState(() {
      authorized = authenticated
          ? "Авторизация прошла успешно"
          : "Ошибка авторизации, попробуйте снова";
      if (authenticated) {
        prefs.setBool('auth', true);
        Navigator.of(context).pushNamed(HomePagesScreen.routeName);
      }
      print(authorized);
    });
  }

  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;

    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  Future _getAvailableBiometric() async {
    List<BiometricType> availableBiometric = [];

    try {
      availableBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    setState(() {
      _availableBiometric = availableBiometric;
    });
  }

  @override
  void initState() {
    _checkBiometric();
    _getAvailableBiometric();

    super.initState();
  }

  // Finger autentifications
  var selectedindex = 0;
  String code = '';

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      fontFamily: 'Roboto',
      fontSize: 30,
      fontWeight: FontWeight.w500,
      color: Colors.black.withBlue(40),
    );
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

// save on local storage
    List<String> savePinCode = [];

    void savePinCodeToLocalStorage() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      savePinCode.add(code);
      prefs.setStringList('pinCode', savePinCode);
      prefs.setBool('auth', true);
    }

    void showHomePagesScreen() async {
      Navigator.of(context).pushNamed(HomePagesScreen.routeName);
    }

    if (code.length == 4) {
      savePinCodeToLocalStorage();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 100, left: width * 0.17),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('PIN-код',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w500)),
                Gap(10),
                Text('Придумайте PIN-код',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: Color.fromRGBO(0, 0, 0, 0.6),
                        fontWeight: FontWeight.w400)),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                  height: height * 0.75,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Gap(height * 0.08),
                      Container(
                        //
                        child: Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DigitHolder(
                                  width: width,
                                  index: 0,
                                  selectedIndex: selectedindex,
                                  code: code,
                                  key: Key('0'),
                                ),
                                DigitHolder(
                                  width: width,
                                  index: 1,
                                  selectedIndex: selectedindex,
                                  code: code,
                                  key: Key('1'),
                                ),
                                DigitHolder(
                                  width: width,
                                  index: 2,
                                  selectedIndex: selectedindex,
                                  code: code,
                                  key: Key('2'),
                                ),
                                DigitHolder(
                                  width: width,
                                  index: 3,
                                  selectedIndex: selectedindex,
                                  code: code,
                                  key: Key('3'),
                                ),
                              ],
                            )),
                      ),
                      Gap(height * 0.08),
                      Container(
                        width: width,
                        height: height * 0.45,
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Container(
                                  //
                                  child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: height * 0.08,
                                      width: width * 0.18,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                      ),
                                      child: Container(
                                        //
                                        child: FlatButton(
                                            height: double.maxFinite,
                                            onPressed: () {
                                              addDigit(1);
                                              if (code.length == 4) {
                                                savePinCodeToLocalStorage();
                                                Navigator.of(context).pushNamed(
                                                    HomePagesScreen.routeName);
                                              }
                                            },
                                            child: Text('1', style: textStyle)),
                                      ),
                                    ),
                                    Container(
                                      height: height * 0.08,
                                      width: width * 0.18,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                      ),
                                      child: Container(
                                        child: FlatButton(
                                            height: double.maxFinite,
                                            onPressed: () {
                                              addDigit(2);
                                              if (code.length == 4) {
                                                savePinCodeToLocalStorage();
                                                Navigator.of(context).pushNamed(
                                                    HomePagesScreen.routeName);
                                              }
                                            },
                                            child: Text('2', style: textStyle)),
                                      ),
                                    ),
                                    Container(
                                      height: height * 0.08,
                                      width: width * 0.18,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                      ),
                                      child: Container(
                                        child: FlatButton(
                                            height: double.maxFinite,
                                            onPressed: () {
                                              addDigit(3);
                                              if (code.length == 4) {
                                                savePinCodeToLocalStorage();
                                                Navigator.of(context).pushNamed(
                                                    HomePagesScreen.routeName);
                                              }
                                            },
                                            child: Text('3', style: textStyle)),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                              Gap(height * 0.02),
                              Container(
                                  // flex: 2,
                                  child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: height * 0.08,
                                      width: width * 0.18,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                      ),
                                      child: Container(
                                        child: FlatButton(
                                            height: double.maxFinite,
                                            onPressed: () {
                                              addDigit(4);
                                              if (code.length == 4) {
                                                savePinCodeToLocalStorage();
                                                Navigator.of(context).pushNamed(
                                                    HomePagesScreen.routeName);
                                              }
                                            },
                                            child: Text('4', style: textStyle)),
                                      ),
                                    ),
                                    Container(
                                      height: height * 0.08,
                                      width: width * 0.18,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                      ),
                                      child: Container(
                                        child: FlatButton(
                                            height: double.maxFinite,
                                            onPressed: () {
                                              addDigit(5);
                                              if (code.length == 4) {
                                                savePinCodeToLocalStorage();
                                                Navigator.of(context).pushNamed(
                                                    HomePagesScreen.routeName);
                                              }
                                            },
                                            child: Text('5', style: textStyle)),
                                      ),
                                    ),
                                    Container(
                                      height: height * 0.08,
                                      width: width * 0.18,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                      ),
                                      child: Container(
                                        child: FlatButton(
                                            height: double.maxFinite,
                                            onPressed: () {
                                              addDigit(6);
                                              if (code.length == 4) {
                                                savePinCodeToLocalStorage();
                                                Navigator.of(context).pushNamed(
                                                    HomePagesScreen.routeName);
                                              }
                                            },
                                            child: Text('6', style: textStyle)),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                              Gap(height * 0.02),
                              Container(
                                  //
                                  child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: height * 0.08,
                                      width: width * 0.18,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                      ),
                                      child: Container(
                                        child: FlatButton(
                                            height: double.maxFinite,
                                            onPressed: () {
                                              addDigit(7);
                                              if (code.length == 4) {
                                                savePinCodeToLocalStorage();
                                                Navigator.of(context).pushNamed(
                                                    HomePagesScreen.routeName);
                                              }
                                            },
                                            child: Text('7', style: textStyle)),
                                      ),
                                    ),
                                    Container(
                                      height: height * 0.08,
                                      width: width * 0.18,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                      ),
                                      child: Container(
                                        child: FlatButton(
                                            height: double.maxFinite,
                                            onPressed: () {
                                              addDigit(8);
                                              if (code.length == 4) {
                                                savePinCodeToLocalStorage();
                                                Navigator.of(context).pushNamed(
                                                    HomePagesScreen.routeName);
                                              }
                                            },
                                            child: Text('8', style: textStyle)),
                                      ),
                                    ),
                                    Container(
                                      height: height * 0.08,
                                      width: width * 0.18,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                      ),
                                      child: Container(
                                        child: FlatButton(
                                            height: double.maxFinite,
                                            onPressed: () {
                                              addDigit(9);
                                              if (code.length == 4) {
                                                savePinCodeToLocalStorage();
                                                Navigator.of(context).pushNamed(
                                                    HomePagesScreen.routeName);
                                              }
                                            },
                                            child: Text('9', style: textStyle)),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                              Gap(height * 0.02),
                              Container(
                                  //
                                  child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      height: height * 0.08,
                                      width: width * 0.18,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                      ),
                                      child: Container(
                                        child: FlatButton(
                                          height: double.maxFinite,
                                          onPressed: () {},
                                          child: const Text(''),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: height * 0.08,
                                      width: width * 0.18,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                      ),
                                      child: Container(
                                        child: FlatButton(
                                            height: double.maxFinite,
                                            onPressed: () {
                                              addDigit(0);
                                              if (code.length == 4) {
                                                savePinCodeToLocalStorage();
                                                Navigator.of(context).pushNamed(
                                                    HomePagesScreen.routeName);
                                              }
                                            },
                                            child: Text('0', style: textStyle)),
                                      ),
                                    ),
                                    Container(
                                      height: height * 0.08,
                                      width: width * 0.18,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                      ),
                                      child: Container(
                                        child: FlatButton(
                                            height: double.maxFinite,
                                            onPressed: () {
                                              backspace();
                                            },
                                            child: const Icon(
                                                Icons.backspace_outlined,
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1),
                                                size: 27)),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          ),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ],
      ),
    );
  }

  addDigit(int digit) {
    if (code.length > 3) {
      return;
    }
    setState(() {
      code = code + digit.toString();
      print('Code is $code');
      selectedindex = code.length;
    });
  }

  backspace() {
    if (code.length == 0) {
      return;
    }
    setState(() {
      code = code.substring(0, code.length - 1);
      selectedindex = code.length;
    });
  }
}

class DigitHolder extends StatelessWidget {
  final int selectedIndex;
  final int index;
  final String code;
  const DigitHolder({
    required this.selectedIndex,
    required Key key,
    required this.width,
    required this.index,
    required this.code,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: width * 0.2,
      width: width * 0.2,
      child: Container(
        alignment: Alignment.center,
        height: 24,
        width: 24,
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
            color: Color.fromRGBO(229, 229, 229, 1),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: index == selectedIndex
                    ? Colors.grey.shade100
                    : Colors.transparent,
                offset: Offset(0, 0),
                spreadRadius: 1.5,
                blurRadius: 2,
              )
            ]),
        child: code.length > index
            ? Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(220, 9, 46, 1),
                  shape: BoxShape.circle,
                ),
              )
            : Container(),
      ),
    );
  }
}
