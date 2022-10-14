import 'dart:collection';
import 'dart:convert';

import 'package:MyID/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/mainGraphQl/servises/edit_client_info.dart';
import '../../utils/mainGraphQl/servises/get_user_info.dart';

class Dannie2 extends StatefulWidget {
  static const String routeName = '/dannie2';
  String userId;
  Dannie2({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<Dannie2> createState() => _Dannie2State();
}

class _Dannie2State extends State<Dannie2> {
  final formKey = GlobalKey<FormState>();
  var responseFromEditClientsInfo;
  int count = 0;
  var phoneArrayItems = '';
  var phoneArrayItems2 = '';
  var token = '';
  bool isDataLoading = true;
  UserInfo? userInfo;
  List? countryParams;
  List? regionParams;
  List? districtParams;
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
    refreshUserInfo();
    count = 0;
    openFilds = false;
  }

  bool openFilds = true;
  final items = ['item1', 'item2', 'item3'];
  String? liveCountri;
  String? areaLive;
  String? liveCountri2;
  TextEditingController phoneController = TextEditingController();

  // final phoneController2 = TextEditingController();
  // final emailController = TextEditingController();
  final cartNumberController = TextEditingController();
  final cartDateController = TextEditingController();
  final cartAddresController = TextEditingController();
  Map<String, Map?> countriesMap = HashMap();
  Map<String, Map?> regionsMap = HashMap();
  Map<String, Map?> districtsMap = HashMap();
  List<String> countriesList = [];
  List<String> regionsList = [];
  List<String> districtsList = [];
  String? currentCountry;
  String? currentRegion;
  String? currentDistrict;

  var maskFormatterPhone = new MaskTextInputFormatter(
    mask: '+998 ## ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

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

  Future loadUserInfo() async {
    getUserInfo(id: widget.userId, tokenFromLocaleStorage: token).then((value) {
      print('*** Result: $value');
      setState(() {
        final userData = value['getClientInfo']['data'];

        final country = json.decode(userData?['country'] ?? "{}");
        final district = json.decode(userData?['district'] ?? "{}");
        final region = json.decode(userData?['region'] ?? "{}");
        userInfo = UserInfo(
          id: userData?['id'].toString(),
          profileId: userData?['profileId'].toString(),
          phoneFirst: userData?['phoneFirst'].toString(),
          phoneSecond: userData?['phoneSecond'].toString(),
          email: userData?['email'].toString(),
          cardDate: userData?['cardDate'].toString(),
          cardNumber: userData?['cardNumber'].toString(),
          adress: userData?['address'].toString(),
          uy: userData?['uy'].toString(),
          country: Country(
            id: country?['id'].toString(),
            code: country?['code'].toString(),
            alpha2Code: country?['alpha2Code'].toString(),
            alpha3Code: country?['alpha3Code'].toString(),
            name: country?['name'].toString(),
            currency: country?['currency'].toString(),
            localSign: country?['localSign'].toString(),
            dateActiv: country?['dateActiv'].toString(),
            dateDeact: country?['dateDeact'].toString(),
            condition: country?['condition'].toString(),
            uzc: country?['uzc'].toString(),
            uzl: country?['uzl'].toString(),
            rus: country?['rus'].toString(),
          ),
          district: District(
            id: district?['id'].toString(),
            code: district?['code'].toString(),
            name: district?['name'].toString(),
            region: district?['region'].toString(),
            dateActiv: district?['dateActiv'].toString(),
            dateDeact: district?['dateDeact'].toString(),
            condition: district?['condition'].toString(),
            uzc: district?['uzc'].toString(),
            uzl: district?['uzl'].toString(),
            rus: district?['rus'].toString(),
          ),
          region: Region(
            id: region?['id'].toString(),
            code: region?['code'].toString(),
            name: region?['name'].toString(),
            order: region?['order'].toString(),
            dateActiv: region?['dateActiv'].toString(),
            dateDeact: region?['dateDeact'].toString(),
            condition: region?['condition'].toString(),
            uzc: region?['uzc'].toString(),
            uzl: region?['uzl'].toString(),
            rus: region?['rus'].toString(),
          ),
        );

        countryParams = value['getClientInfoRefs']['data']['COUNTRY'];
        regionParams = value['getClientInfoRefs']['data']['REGION'];
        districtParams = value['getClientInfoRefs']['data']['DISTRICT'];

        if (phoneController.text.isEmpty) {
          phoneController.text =
              (userInfo!.phoneFirst! == 'null' ? '' : userInfo!.phoneFirst)!;
        }
        // if (phoneController2.text.isEmpty) {
        //   phoneController2.text =
        //       (userInfo!.phoneSecond! == 'null' ? '' : userInfo!.phoneSecond)!;
        // }
        // if (emailController.text.isEmpty) {
        //   emailController.text =
        //       (userInfo!.email! == 'null' ? '' : userInfo!.email)!;
        // }
        if (cartNumberController.text.isEmpty) {
          cartNumberController.text =
              (userInfo!.cardNumber! == 'null' ? '' : userInfo!.cardNumber)!;
        }
        if (cartDateController.text.isEmpty) {
          cartDateController.text =
              (userInfo!.cardDate! == 'null' ? '' : userInfo!.cardDate)!;
        }
        if (cartAddresController.text.isEmpty) {
          cartAddresController.text =
              (userInfo!.adress! == 'null' ? '' : userInfo!.adress)!;
        }

        countriesList.clear();
        regionsList.clear();
        districtsList.clear();
        for (Map item in countryParams!) {
          countriesList.add(item['name']);
          countriesMap.putIfAbsent(item['name'], () => item);
          if (currentCountry == null &&
              item['id'].toString() == userInfo!.country?.id) {
            currentCountry = item['name'];
          }
        }
        for (Map item in regionParams!) {
          regionsList.add(item['name']);
          regionsMap.putIfAbsent(item['name'], () => item);
          if (currentRegion == null &&
              item['id'].toString() == userInfo!.region?.id) {
            currentRegion = item['name'];
          }
        }
        for (Map item in districtParams!) {
          districtsList.add(item['name']);
          districtsMap.putIfAbsent(item['name'], () => item);
          if (currentDistrict == null &&
              item['id'].toString() == userInfo!.district?.id) {
            currentDistrict = item['name'];
          }
        }
        isDataLoading = false;
      });
    });
  }

  Future refreshUserInfo() async {
    while (token == '') {
      loadLocaleStorage();
      await Future.delayed(const Duration(seconds: 1));
    }
    setState(() {
      isDataLoading = true;
    });
    loadUserInfo();
  }

  Future submited() async {
    final enteredPhoneController =
        phoneController.text.replaceAll('-', ' ').replaceAll(' ', '');
    // final enteredPhoneController2 =
    //     phoneController2.text.replaceAll('-', ' ').replaceAll(' ', '');
    // final enteredEmailController = emailController.text;
    final enteredCartNumberController =
        cartNumberController.text.replaceAll(' ', '');
    final enteredCartDateController = cartDateController.text;
    final enteredCartAddresController = cartAddresController.text;
    bool error = false;
    String errorMessage = '';

    print('enteredPhoneController: $enteredPhoneController');
    // print('enteredPhoneController2: $enteredPhoneController2');

    if (enteredPhoneController.isEmpty ||
        // enteredEmailController.isEmpty ||
        enteredCartNumberController.isEmpty ||
        enteredCartDateController.isEmpty ||
        enteredCartAddresController.isEmpty ||
        currentCountry == null ||
        currentRegion == null ||
        currentDistrict == null) {
      error = true;
      errorMessage = 'Пожалуйста, введите все необходимые данные';
    } else if (enteredPhoneController.length > 15) {
      error = true;
      errorMessage = 'Номер телефона должен быть меньше 15 символов';
      // } else if (!enteredEmailController.contains('@')) {
      //   error = true;
      //   errorMessage = 'Электронная почта не подходит';
    } else if (enteredCartNumberController.length != 16) {
      error = true;
      errorMessage = 'Номер карты неверный';
    } else if (enteredCartDateController.length != 5) {
      error = true;
      errorMessage = 'Срок действия карты указан неправильно';
    }

    if (error) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Результат запроса'),
          content: Text(
            errorMessage,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
                color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    while (token == '') {
      loadLocaleStorage();
      await Future.delayed(const Duration(seconds: 1));
    }

    List<String> parts;
    String? countryFormat = countriesMap[currentCountry]
        .toString()
        .replaceAll('{', '{"')
        .replaceAll('}', '"}')
        .replaceAll(': ', '": "')
        .replaceAll(', ', '", "')
        .replaceAll('"null"', 'null');
    parts = countryFormat.split(', ');
    for (var i = 0; i < parts.length; i++) {
      if (parts[i].contains('"id"') || parts[i].contains('"localSign"')) {
        var temp = parts[i].split(':');
        parts[i] = temp[0] + ':' + temp[1].replaceAll('"', '');
      }
    }
    countryFormat = parts.join(', ');

    String? regionFormat = regionsMap[currentRegion]
        .toString()
        .replaceAll('{', '{"')
        .replaceAll('}', '"}')
        .replaceAll(': ', '": "')
        .replaceAll(', ', '", "')
        .replaceAll('"null"', 'null');
    parts = regionFormat.split(', ');
    for (var i = 0; i < parts.length; i++) {
      if (parts[i].contains('"id"') || parts[i].contains('"order"')) {
        var temp = parts[i].split(':');
        parts[i] = temp[0] + ':' + temp[1].replaceAll('"', '');
      }
    }
    regionFormat = parts.join(', ');

    String? districtFormat = districtsMap[currentDistrict]
        .toString()
        .replaceAll('{', '{"')
        .replaceAll('}', '"}')
        .replaceAll(': ', '": "')
        .replaceAll(', ', '", "')
        .replaceAll('"null"', 'null');
    parts = districtFormat.split(', ');
    for (var i = 0; i < parts.length; i++) {
      if (parts[i].contains('"id"')) {
        var temp = parts[i].split(':');
        parts[i] = temp[0] + ':' + temp[1].replaceAll('"', '');
      }
    }
    districtFormat = parts.join(', ');
    editClientInfo1(
            address: enteredCartAddresController,
            cardDate: enteredCartDateController,
            cartNumber: enteredCartNumberController,
            country: countryFormat,
            district: districtFormat,
            id: userInfo!.id,
            email: 'notUsed@mail.com',
            phoneFirst:
                enteredPhoneController.replaceAll('-', ' ').replaceAll(' ', ''),
            phoneSecond:
                '+000000000000'.replaceAll('-', ' ').replaceAll(' ', ''),
            profileId: userInfo!.profileId,
            region: regionFormat,
            tokenFromLocaleStorage: token)
        .then((value) {
      if (value != null) {
        String resultMessage = 'Данные успешно обновлены';
        if (value['msg'].toString() != 'success') {
          resultMessage = value['msg'].toString();
        }
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Результат запроса'),
            content: Text(
              resultMessage,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Roboto'),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        setState(() {
          responseFromEditClientsInfo = value;
        });
      }
    });
  }

  bool texterrorPhone = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white70,
        automaticallyImplyLeading: false,
        title: Container(
          color: Colors.white70,
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
                  Navigator.of(context).pop();
                },
              ),
              Container(
                child: const Text(
                  '2. Данные',
                  style: TextStyle(
                      fontSize: 22, fontFamily: 'Roboto', color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
      body: isDataLoading
          ? Center(
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.blue,
                ),
              ),
            )
          : ListView(
              shrinkWrap: true,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Container(
                        // height: 55,

                        width: width * 1,
                        color: Colors.white,
                        padding: const EdgeInsets.only(
                            top: 16, bottom: 26, left: 20, right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: const Text(
                                'Контактные данные',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto'),
                              ),
                            ),
                            Gap(20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: width * 0.43,
                                  child: TextField(
                                    autofocus: false,
                                    autocorrect: true,
                                    inputFormatters: [maskFormatterPhone],
                                    keyboardType: TextInputType.phone,
                                    controller: phoneController,
                                    onChanged: (value) => {
                                      setState(() {
                                        phoneArrayItems = value;
                                        // print(
                                        //     '----------- phoneArrayItems ${phoneArrayItems.replaceAll('-', ' ').replaceAll(' ', '')}');
                                      })
                                    },
                                    onSubmitted: (val) => {
                                      setState(() {
                                        phoneController.text = val;
                                      }),
                                    },
                                    textInputAction: TextInputAction.next,
                                    style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontSize: 16),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                      focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1.0),
                                      ),

                                      //
                                      errorText: texterrorPhone
                                          ? "Введите как на примере - +998991234567"
                                          : null,
                                      labelText: 'Мобильный номер*',

                                      labelStyle: TextStyle(
                                        fontFamily: 'Roboto',
                                        color: Colors.grey,
                                        fontSize: 15,
                                      ),

                                      hintText: '+998',
                                      hintStyle: const TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                  ),
                                ),
                                // Container(
                                //   width: width * 0.43,
                                //   child: Container(
                                //     child: TextField(
                                //       keyboardType: TextInputType.emailAddress,
                                //       autocorrect: false,
                                //       controller: emailController,
                                //       onSubmitted: (val) => print(val),
                                //       textInputAction: TextInputAction.next,
                                //       autofocus: false,
                                //       style: const TextStyle(
                                //           fontFamily: 'Roboto',
                                //           color: Color.fromRGBO(0, 0, 0, 1),
                                //           fontSize: 16),
                                //       decoration: InputDecoration(
                                //         contentPadding: EdgeInsets.symmetric(
                                //             horizontal: 20),
                                //         border: OutlineInputBorder(
                                //             borderRadius:
                                //                 BorderRadius.circular(5),
                                //             borderSide: BorderSide(
                                //                 color: Colors.black)),
                                //         focusedBorder: const OutlineInputBorder(
                                //           borderRadius: BorderRadius.all(
                                //               Radius.circular(5)),
                                //           borderSide: BorderSide(
                                //               color: Colors.grey, width: 1.0),
                                //         ),
                                //         hintText: 'Почта',
                                //         hintStyle: const TextStyle(
                                //             color: Colors.grey, fontSize: 15),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            Gap(0),
                            // Container(
                            //   width: width * 0.43,
                            //   child: TextField(
                            //     inputFormatters: [maskFormatterPhone],
                            //     keyboardType: TextInputType.phone,
                            //     autocorrect: false,
                            //     controller: phoneController2,
                            //     onSubmitted: (val) => print(val),
                            //     textInputAction: TextInputAction.next,
                            //     autofocus: false,
                            //     style: const TextStyle(
                            //         fontFamily: 'Roboto',
                            //         color: Color.fromRGBO(0, 0, 0, 1),
                            //         fontSize: 16),
                            //     decoration: InputDecoration(
                            //       contentPadding:
                            //           EdgeInsets.symmetric(horizontal: 20),
                            //       border: OutlineInputBorder(
                            //           borderRadius: BorderRadius.circular(5),
                            //           borderSide:
                            //               BorderSide(color: Colors.black)),
                            //       focusedBorder: const OutlineInputBorder(
                            //         borderRadius:
                            //             BorderRadius.all(Radius.circular(5)),
                            //         borderSide: BorderSide(
                            //             color: Colors.grey, width: 1.0),
                            //       ),

                            //       //
                            //       labelText: 'Мобильный номер 2*',
                            //       labelStyle: TextStyle(
                            //         fontFamily: 'Roboto',
                            //         color: Colors.grey,
                            //         fontSize: 15,
                            //       ),

                            //       hintText: '+998',
                            //       hintStyle: const TextStyle(
                            //           color: Colors.black, fontSize: 15),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      Gap(10),
//------------------------------------------------------------
                      Container(
                        width: width * 1,
                        color: Colors.white,
                        padding: const EdgeInsets.only(
                            top: 16, bottom: 16, left: 20, right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: const Text(
                                'Данные пластиковой карточки',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto'),
                              ),
                            ),
                            Gap(20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: width * 0.35,
                                  margin: EdgeInsets.only(right: 15),
                                  child: TextField(
                                    inputFormatters: [maskFormatterCart],
                                    autofocus: false,
                                    keyboardType: TextInputType.number,
                                    autocorrect: false,
                                    controller: cartNumberController,
                                    onSubmitted: (val) => print(val),
                                    textInputAction: TextInputAction.next,
                                    style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontSize: 16),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide:
                                              BorderSide(color: Colors.black)),
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
                                  child: TextField(
                                    inputFormatters: [maskFormatterCartDate],
                                    autofocus: false,
                                    keyboardType: TextInputType.datetime,
                                    autocorrect: false,
                                    controller: cartDateController,
                                    onSubmitted: (val) => print(val),
                                    textInputAction: TextInputAction.next,
                                    style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontSize: 16),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide:
                                              BorderSide(color: Colors.black)),
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

                                //----------------------------------------------------------------------------
                              ],
                            ),
                            Gap(32),
                            Container(
                              child: const Text(
                                'Убедитесь, что добавляете правильные данные.',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Roboto'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(10),
                      Container(
                        width: width * 1,
                        color: Colors.white,
                        padding: const EdgeInsets.only(
                            top: 16, bottom: 16, left: 20, right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: const Text(
                                'Адресные данные',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto'),
                              ),
                            ),
                            Gap(15),
                            Container(
                              width: width * 1,
                              padding: EdgeInsets.only(right: 15, left: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  value: currentCountry,
                                  iconSize: 30,
                                  items: countriesList != null
                                      ? countriesList
                                          .map(buildMenuItems1LiveCountry)
                                          .toList()
                                      : items
                                          .map(buildMenuItems1LiveCountry)
                                          .toList(),
                                  onChanged: (value) => setState(
                                    () {
                                      setState(() {
                                        currentCountry = value as String?;
                                      });
                                    },
                                  ),
                                  // onChanged: currentCountry != null
                                  //     ? null
                                  //     : (value) => setState(
                                  //           () {
                                  //             setState(() {
                                  //               currentCountry =
                                  //                   value as String?;
                                  //             });
                                  //           },
                                  //         ),
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Color.fromRGBO(0, 0, 0, 70),
                                  ),
                                  isExpanded: true,
                                  hint: const Text(
                                    'Страна проживания',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto'),
                                  ),
                                  style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            Gap(15),
                            Container(
                              width: width * 1,
                              padding: EdgeInsets.only(right: 15, left: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  value: currentRegion,
                                  iconSize: 30,
                                  items: regionsList != null
                                      ? regionsList
                                          .map(buildMenuItemsAreaLive)
                                          .toList()
                                      : items
                                          .map(buildMenuItems1LiveCountry)
                                          .toList(),
                                  onChanged: (value) => setState(
                                    () {
                                      setState(() {
                                        currentRegion = value as String?;
                                      });
                                    },
                                  ),

                                  // onChanged: currentRegion != null
                                  //     ? null
                                  //     : (value) => setState(
                                  //           () {
                                  //             setState(() {
                                  //               currentRegion =
                                  //                   value as String?;
                                  //             });
                                  //           },
                                  //         ),
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Color.fromRGBO(0, 0, 0, 70),
                                  ),
                                  isExpanded: true,
                                  hint: const Text(
                                    'Область проживания',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto'),
                                  ),
                                  style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            Gap(15),
                            Container(
                              width: width * 1,
                              padding: EdgeInsets.only(right: 15, left: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  value: currentDistrict,
                                  iconSize: 30,
                                  items: districtsList != null
                                      ? districtsList
                                          .map(buildMenuItems2LiveCountry)
                                          .toList()
                                      : items
                                          .map(buildMenuItems1LiveCountry)
                                          .toList(),
                                  // onChanged: currentDistrict != null
                                  //     ? null
                                  //     : (value) => setState(
                                  //           () {
                                  //             setState(() {
                                  //               currentDistrict =
                                  //                   value as String?;
                                  //             });
                                  //           },
                                  //         ),
                                  onChanged: (value) => setState(
                                    () {
                                      setState(() {
                                        currentDistrict = value as String?;
                                      });
                                    },
                                  ),
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Color.fromRGBO(0, 0, 0, 70),
                                  ),
                                  isExpanded: true,
                                  hint: const Text(
                                    'Район проживания',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto'),
                                  ),
                                  style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            Gap(15),
                            Container(
                              width: width * 1,
                              child: TextField(
                                autofocus: false,
                                keyboardType: TextInputType.multiline,
                                autocorrect: false,
                                controller: cartAddresController,
                                onSubmitted: (val) => print(val),
                                style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontSize: 16),
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 20),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    },
                                    child: Transform.rotate(
                                      angle: 15,
                                      child: const Icon(
                                        Icons.control_point_rounded,
                                        size: 30,
                                        color: Color.fromRGBO(0, 0, 0, 70),
                                      ),
                                    ),
                                  ),
                                  labelText: 'Адрес проживания',
                                  labelStyle: const TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                  hintText: 'Редактируемый INPUT',
                                  hintStyle: const TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                ),
                              ),
                            ),
                            Gap(12),
                            Container(
                              padding: EdgeInsets.only(left: 20),
                              child: const Text(
                                'Supporting text',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Roboto'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(32),

                      if (phoneArrayItems
                                  .replaceAll('-', ' ')
                                  .replaceAll(' ', '')
                                  .length >=
                              13 &&
                          currentCountry != null &&
                          currentRegion != null &&
                          currentDistrict != null)
                        Center(
                          child: Container(
                            width: 119,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(33, 150, 83, 1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: TextButton(
                              onPressed: () {
                                print('Нажата кнопка');
                                submited();
                              },
                              child: const Text(
                                'Сохранить',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Roboto'),
                              ),
                            ),
                          ),
                        ),

                      if (phoneArrayItems
                                  .replaceAll('-', ' ')
                                  .replaceAll(' ', '')
                                  .length <=
                              12 ||
                          currentCountry == null ||
                          currentRegion == null ||
                          currentDistrict == null)
                        Center(
                          child: Container(
                            width: 119,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(228, 228, 228, 1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: TextButton(
                              onPressed: () {
                                print('Нажата кнопка');
                                // submited();
                              },
                              child: const Text(
                                'Сохранить',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Roboto'),
                              ),
                            ),
                          ),
                        ),

                      Gap(15),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

DropdownMenuItem<String> buildMenuItems1LiveCountry(String item) {
  return DropdownMenuItem<String>(
    value: item,
    child: Text(item),
  );
}

DropdownMenuItem<String> buildMenuItemsAreaLive(String item) {
  return DropdownMenuItem<String>(
    value: item,
    child: Text(item),
  );
}

DropdownMenuItem<String> buildMenuItems2LiveCountry(String item) {
  return DropdownMenuItem<String>(
    value: item,
    child: Text(item),
  );
}
