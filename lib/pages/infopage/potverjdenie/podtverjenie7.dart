import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../../utils/mainGraphQl/servises/get_auto_pay_status.dart';
import '../../../utils/mainGraphQl/servises/podtvergdenir_auto_payment.dart';
import '../../info_pages.dart';
import 'podtvejdenie7_csm_code.dart';

class Podverjenie7 extends StatefulWidget {
  static const String routeName = '/Podverjenie7';
  final String userId;

  final userData;
  final userDataCartNumber;
  final String? userConfirmed;
  final String? msg;
  // bool? loader;

  Podverjenie7({
    Key? key,
    required this.userId,
    required this.userConfirmed,
    required this.userData,
    required this.userDataCartNumber,
    required this.msg,
    // required this.loader
  }) : super(key: key);

  @override
  State<Podverjenie7> createState() => _SostavZakazaState();
}

class _SostavZakazaState extends State<Podverjenie7> {
  final cartNumberController = TextEditingController();
  final cartDateController = TextEditingController();
  var cartNumber = '';
  var cartDate = '';

//-----------
  // String? userData = '';
  // String? userDataCartNumber = '';
  // String? userConfirmed = '';

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

    // widget.loader = false;
    // asa();

    if (widget.userConfirmed == 'true') {
      if (widget.userDataCartNumber != null) {
        if (cartNumberController.text.isEmpty) {
          cartNumberController.text = (widget.userDataCartNumber! == 'null'
              ? ''
              : widget.userDataCartNumber!)!;
        }
      }

      if (widget.userData != null) {
        if (cartDateController.text.isEmpty) {
          cartDateController.text =
              (widget.userData! == 'null' ? '' : widget.userData!)!;
        }
      }
    }
  }

  submit() {
    final enteredcartNumberController =
        cartNumberController.text.replaceAll('-', ' ').replaceAll(' ', '');
    final enteredcartDateController =
        cartDateController.text.replaceAll('-', ' ').replaceAll(' ', '');

    if (enteredcartNumberController.isEmpty ||
        enteredcartDateController.isEmpty) {
      return;
    }

    autoPayment(
            cardNumber: enteredcartNumberController,
            cardDate: enteredcartDateController,
            tokenFromLocaleStorage: token,
            claimsId: widget.userId)
        .then((value) {});
  }

  var maskFormatterCart = new MaskTextInputFormatter(
      mask: '#### #### #### ####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  var maskFormatterCartDate = new MaskTextInputFormatter(
      mask: '##/##',
      filter: {
        "#": RegExp(r'[0-9]'),
      },
      type: MaskAutoCompletionType.lazy);

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
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final media = MediaQuery.of(context);

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
                    '7. Подтверждение ',
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
        body: media.size.width < 440
            ? ListView(
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
                        Gap(20),
                        const Text(
                          'Ввод данных для подтверждения заказа',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto',
                            color: Color.fromRGBO(0, 0, 0, 1),
                          ),
                        ),
                        Gap(27),
                        Container(
                          width: width * 1,
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: width * 0.35,
                                    height: 56,
                                    margin: EdgeInsets.only(right: 15),
                                    child: TextField(
                                      inputFormatters: [maskFormatterCart],
                                      autofocus: false,
                                      keyboardType: TextInputType.number,
                                      autocorrect: false,
                                      controller: cartNumberController,
                                      // controller: widget.userConfirmed == false
                                      //     ? cartNumberController
                                      //     : TextEditingController(
                                      //         text: widget.userDataCartNumber),
                                      onChanged: (value) => {
                                        setState(() {
                                          cartNumber = value;
                                        })
                                      },
                                      onSubmitted: (val) => print(val),
                                      textInputAction: TextInputAction.next,
                                      style: const TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontSize: 16),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                        focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1.0),
                                        ),
                                        labelText: 'Номер карты',
                                        labelStyle: const TextStyle(
                                            color: Colors.grey, fontSize: 15),
                                        hintText: '8600 0202 9095 4305',
                                        hintStyle: const TextStyle(
                                            color: Colors.grey, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: width * 0.20,
                                    height: 56,
                                    child: TextField(
                                      inputFormatters: [maskFormatterCartDate],
                                      autofocus: false,
                                      keyboardType: TextInputType.datetime,
                                      autocorrect: false,
                                      controller: cartDateController,
                                      onSubmitted: (val) => print(val),
                                      textInputAction: TextInputAction.next,
                                      onChanged: (value) => {
                                        setState(() {
                                          cartDate = value;
                                        })
                                      },
                                      style: const TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontSize: 16),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                        focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1.0),
                                        ),
                                        labelText: 'Срок действия',
                                        labelStyle: const TextStyle(
                                            color: Colors.grey, fontSize: 15),
                                        hintText: '04/25',
                                        hintStyle: const TextStyle(
                                            color: Colors.grey, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                  if (cartNumber
                                              .replaceAll('-', ' ')
                                              .replaceAll(' ', '')
                                              .length ==
                                          16 &&
                                      cartDate.length == 5)
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 10, bottom: 5),
                                      width: 127,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color:
                                              Color.fromRGBO(33, 150, 83, 1)),
                                      child: TextButton(
                                        onPressed: () => {
                                          print(widget.msg),
                                          if (widget.msg != 'success')
                                            {
                                              submit(),
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Podtvejdenie7SmsCode(
                                                    userId:
                                                        widget.userId == null
                                                            ? ''
                                                            : widget.userId,
                                                  ),
                                                ),
                                              ),
                                            }
                                          // submit(),
                                          // Navigator.of(context).push(
                                          //   MaterialPageRoute(
                                          //     builder: (context) =>
                                          //         Podtvejdenie7SmsCode(
                                          //       userId: widget.userId == null
                                          //           ? ''
                                          //           : widget.userId,
                                          //     ),
                                          //   ),
                                          // ),
                                        },
                                        child: const Text(
                                          'Получить код',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Roboto',
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  if (cartNumber
                                              .replaceAll('-', ' ')
                                              .replaceAll(' ', '')
                                              .length !=
                                          16 ||
                                      cartDate.length != 5)
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 10, bottom: 5),
                                      width: 127,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color:
                                              Color.fromRGBO(228, 228, 228, 1)),
                                      child: TextButton(
                                        onPressed: () => {
                                          print(widget.msg),
                                        },
                                        child: Text(
                                          'Получить код',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Roboto',
                                              color: Colors.grey.shade500),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Gap(30),
                        const Text(
                          'Важно! Предупредите клиента, что заполняемые данные пластиковой карты должны быть верными и придет СМС код телефонному номеру который привязано к этой пластиковой карте и клиент должен будет сообщить этот код',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                            color: Color.fromRGBO(130, 130, 130, 1),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            : ListView(
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
                        Gap(20),
                        const Text(
                          'Ввод данных для подтверждения заказа',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto',
                            color: Color.fromRGBO(0, 0, 0, 1),
                          ),
                        ),
                        Gap(27),
                        Container(
                          width: width * 1,
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: width * 0.35,
                                    height: 56,
                                    margin: EdgeInsets.only(right: 15),
                                    child: TextField(
                                      inputFormatters: [maskFormatterCart],
                                      autofocus: false,
                                      keyboardType: TextInputType.number,
                                      autocorrect: false,
                                      controller: cartNumberController,
                                      // controller: widget.userConfirmed == false
                                      //     ? cartNumberController
                                      //     : TextEditingController(
                                      //         text: widget.userDataCartNumber),
                                      onChanged: (value) => {
                                        setState(() {
                                          cartNumber = value;
                                        })
                                      },
                                      onSubmitted: (val) => print(val),
                                      textInputAction: TextInputAction.next,
                                      style: const TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontSize: 16),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                        focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1.0),
                                        ),
                                        labelText: 'Номер карты',
                                        labelStyle: const TextStyle(
                                            color: Colors.grey, fontSize: 15),
                                        hintText: '8600 0202 9095 4305',
                                        hintStyle: const TextStyle(
                                            color: Colors.grey, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: width * 0.20,
                                    height: 56,
                                    child: TextField(
                                      inputFormatters: [maskFormatterCartDate],
                                      autofocus: false,
                                      keyboardType: TextInputType.datetime,
                                      autocorrect: false,
                                      controller: cartDateController,
                                      onSubmitted: (val) => print(val),
                                      textInputAction: TextInputAction.next,
                                      onChanged: (value) => {
                                        setState(() {
                                          cartDate = value;
                                        })
                                      },
                                      style: const TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontSize: 16),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                        focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1.0),
                                        ),
                                        labelText: 'Срок действия',
                                        labelStyle: const TextStyle(
                                            color: Colors.grey, fontSize: 15),
                                        hintText: '04/25',
                                        hintStyle: const TextStyle(
                                            color: Colors.grey, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                  if (cartNumber
                                              .replaceAll('-', ' ')
                                              .replaceAll(' ', '')
                                              .length ==
                                          16 &&
                                      cartDate.length == 5)
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 40, bottom: 5),
                                      width: 157,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color:
                                              Color.fromRGBO(33, 150, 83, 1)),
                                      child: TextButton(
                                        onPressed: () => {
                                          print(widget.msg),
                                          if (widget.msg != 'success')
                                            {
                                              submit(),
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Podtvejdenie7SmsCode(
                                                    userId:
                                                        widget.userId == null
                                                            ? ''
                                                            : widget.userId,
                                                  ),
                                                ),
                                              ),
                                            }
                                          // submit(),
                                          // Navigator.of(context).push(
                                          //   MaterialPageRoute(
                                          //     builder: (context) =>
                                          //         Podtvejdenie7SmsCode(
                                          //       userId: widget.userId == null
                                          //           ? ''
                                          //           : widget.userId,
                                          //     ),
                                          //   ),
                                          // ),
                                        },
                                        child: const Text(
                                          'Получить код',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Roboto',
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  if (cartNumber
                                              .replaceAll('-', ' ')
                                              .replaceAll(' ', '')
                                              .length !=
                                          16 ||
                                      cartDate.length != 5)
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 40, bottom: 5),
                                      width: 157,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color:
                                              Color.fromRGBO(228, 228, 228, 1)),
                                      child: TextButton(
                                        onPressed: () => {
                                          print(widget.msg),
                                        },
                                        child: Text(
                                          'Получить код',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Roboto',
                                              color: Colors.grey.shade500),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Gap(30),
                        const Text(
                          'Важно! Предупредите клиента, что заполняемые данные пластиковой карты должны быть верными и придет СМС код телефонному номеру который привязано к этой пластиковой карте и клиент должен будет сообщить этот код',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                            color: Color.fromRGBO(130, 130, 130, 1),
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
