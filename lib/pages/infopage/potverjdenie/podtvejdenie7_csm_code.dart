import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/mainGraphQl/servises/get_auto_pay_status.dart';
import '../../../utils/mainGraphQl/servises/podtvergdenir_auto_payment.dart';
import '../../../utils/mainGraphQl/servises/podtverjdenie_auto_payment_confirm.dart';
import '../../info_pages.dart';

class Podtvejdenie7SmsCode extends StatefulWidget {
  static const String routeName = '/Podtvejdenie7SmsCode';
  final String? userId;
  Podtvejdenie7SmsCode({Key? key, required this.userId}) : super(key: key);

  @override
  State<Podtvejdenie7SmsCode> createState() => _SostavZakazaState();
}

class _SostavZakazaState extends State<Podtvejdenie7SmsCode> {
  final cartNumberController = TextEditingController();
  final cartDateController = TextEditingController();

  String? userData = '';
  String? userDataCartNumber = '';
  String? userConfirmed = '';

  var token = '';
  loadLocaleStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token')!;
    });
  }

  @override
  void initState() {
    super.initState();
    loadLocaleStorage();
  }

  reSubmitForTimer() {
    getAutoPayStatusLogik(tokenFromLocaleStorage: token, id: widget.userId!)
        .then((value) {
      print('------------------ value ${value}');
      if (value['msg'] == 'success') {
        autoPayment(
                cardNumber: value['data']['cardNumber'],
                cardDate: value['data']['cardDate'],
                tokenFromLocaleStorage: token,
                claimsId: widget.userId)
            .then((value) {});
        // print('------------------ value ${value['data']['confirmed']}');
        // print('------------------ value ${value['data']['cardDate']}');
        // print('------------------ value ${value['data']['cardNumber']}');
        // setState(() {
        //   userData = value['data']['confirmed'];
        //   userDataCartNumber = value['data']['cardNumber'];
        //   userConfirmed = value['data']['confirmed'];
        // });
      }
    });
  }

  late Timer _timer;

  int _start = 30;
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }

          if (_start == 0) {
            _start = 30;
            timer.cancel();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  OtpFieldController otpbox = OtpFieldController();

  var pinCode = '';

  submit() {
    if (pinCode.length != 6) {
      return;
    }
    autoPaymentConfirm(
            claimsId: widget.userId,
            smsCode: pinCode,
            tokenFromLocaleStorage: token)
        .then((value) {});
  }

  var changeColor = false;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    // getAutoPayStatusLogik(tokenFromLocaleStorage: token, id: widget.userId!)
    //     .then((value) {
    //   print('------------------ value ${value}');
    //   if (value['msg'] == 'success') {
    //     print('------------------ value ${value['data']['confirmed']}');
    //     print('------------------ value ${value['data']['cardDate']}');
    //     print('------------------ value ${value['data']['cardNumber']}');
    //     setState(() {
    //       userData = value['data']['confirmed'];
    //       userDataCartNumber = value['data']['cardNumber'];
    //       userConfirmed = value['data']['confirmed'];
    //     });
    //   }
    // });

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color.fromRGBO(255, 251, 254, 1),
          automaticallyImplyLeading: false,
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                    // Navigator.of(context).pushNamed(InfoPage.routeName);
                  },
                ),
                Container(
                  child: const Text(
                    '7. Подтверждение смс кода ',
                    style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'Roboto',
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(80),
                  Center(
                    child: const Text(
                      'Введите код подтверждения, отправленный на телефон',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                        color: Color.fromRGBO(0, 0, 0, 1),
                      ),
                    ),
                  ),
                  Gap(13),
                  Center(
                    child: const Text(
                      'СМС код отправлен на привязанный номер карты',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Roboto',
                        color: Color.fromRGBO(116, 116, 116, 1),
                      ),
                    ),
                  ),
                  // ---------------------------------------------------------------
                  Gap(31),
                  if (_start <= 29)
                    Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Container(
                              child: Text(
                                '${_start}',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(116, 116, 116, 1),
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Container(
                              child: const Text(
                                'Повторить отправку кода',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(116, 116, 116, 1),
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (_start == 30)
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => {startTimer(), reSubmitForTimer()},
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Container(
                                child: Icon(
                                  Icons.refresh_sharp,
                                  color: Color.fromRGBO(25, 103, 210, 1),
                                  size: 20,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Container(
                                child: const Text(
                                  'Повторить отправку кода',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color.fromRGBO(25, 103, 210, 1),
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // ---------------------------------------------------------------
                  Gap(65),

                  OTPTextField(
                    controller: otpbox,
                    length: 6,
                    width: width * 1,
                    fieldWidth: 65,
                    outlineBorderRadius: 5,
                    style: const TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldStyle: FieldStyle.box,
                    onCompleted: (pin) {
                      setState(() {
                        pinCode = pin;
                        if (pin == 6) {
                          changeColor = true;
                        } else {
                          changeColor = false;
                        }
                      });
                    },
                    onChanged: (pin) {
                      setState(() {
                        pinCode = pin;
                        if (pin == 6) {
                          changeColor = true;
                        } else {
                          changeColor = false;
                        }
                      });
                    },
                  ),
                  // ---------------------------------------------------------------
                  if (pinCode.length <= 5)
                    Container(
                      padding: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          Gap(20),
                          Container(
                            padding: EdgeInsets.only(
                                left: 14, right: 14, top: 12, bottom: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color.fromRGBO(253, 239, 239, 1)),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.error,
                                    color: Color.fromRGBO(235, 87, 87, 1),
                                    size: 30,
                                  ),
                                ),
                                Text(
                                  'Ошибка при вводе кода, пожалуйста убедить в правильности ввода',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  const Gap(65),

                  Center(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => {
                        if (pinCode.length >= 6)
                          {
                            otpbox.clear(),
                          }
                      },
                      child: Container(
                        width: 245,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: pinCode.length >= 6
                                ? Color.fromRGBO(33, 150, 83, 1)
                                : Color.fromRGBO(31, 31, 31, 0.12)),
                        child: TextButton(
                          onPressed: () => {
                            if (pinCode.length >= 6)
                              {
                                submit(),
                                otpbox.clear(),
                              }
                          },
                          child: Text(
                            'Подтвердить',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Roboto',
                                color: pinCode.length >= 6
                                    ? Colors.white
                                    : Color.fromRGBO(152, 151, 153, 1)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
