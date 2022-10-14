import 'package:MyID/providers/client_data.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/mainGraphQl/servises/get-qr-code.dart';
import '../utils/mainGraphQl/servises/get_auto_pay_status.dart';
import '../utils/mainGraphQl/servises/get_process.dart';
import 'infopage/dannie2.dart';
import 'infopage/detali_zayavki.dart';
import 'infopage/dogovor6.dart';
import 'infopage/grafic8/grafic8.dart';
import 'infopage/grafic8/graph8-message.dart';
import 'infopage/oformlenie/oformlenie5.dart';
import 'infopage/potverjdenie/podtvejdenie7_csm_code.dart';
import 'infopage/potverjdenie/podtverjenie7.dart';
import 'infopage/sostav_zakaza0/sostav_zakaza.dart';

class InfoPage extends StatefulWidget {
  static const String routeName = '/infoPages';
  String userId;
  InfoPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  var tokenFromLocaleStorage = '';
  var userProcess;
  bool isDataLoading = true;

  var userData = '';
  var userDataCartNumber = '';
  String? userConfirmed = '';

  var loader = false;

  loadLocaleStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tokenFromLocaleStorage = prefs.getString('token')!;
    });
  }

  @override
  void initState() {
    super.initState();
    loadLocaleStorage();
    refreshPage();
    refreshClientData();

    setState(() {
      loader = false;
    });

    print('------------------ loader ==================== ${loader}');
  }

  Future getUserProcess() async {
    getClientProcess(
            id: widget.userId, tokenFromLocaleStorage: tokenFromLocaleStorage)
        .then((value) {
      if (value['code'] == 0 && value['data'] != null) {
        setState(() {
          userProcess = value['data'];
          isDataLoading = false;
        });
      }
    });
  }

  Future refreshPage() async {
    while (tokenFromLocaleStorage == '') {
      loadLocaleStorage();
      await Future.delayed(const Duration(seconds: 1));
    }
    setState(() {
      isDataLoading = true;
      loader = false;
    });
    return getUserProcess();
  }

  Future refreshClientData() async {
    while (tokenFromLocaleStorage == '') {
      loadLocaleStorage();
      await Future.delayed(const Duration(seconds: 1));
    }
    ClientData.clearAllClientData();
    ClientData.loadAllClientData(widget.userId, tokenFromLocaleStorage);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 1));
        setState(() {
          // userInfo = null;
          refreshPage();
        });
        return null;
      },
      child: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
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
                      'Назад к списку',
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
          body: loader == true
              ? Center(
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blue,
                    ),
                  ),
                )
              : isDataLoading
                  ? Center(
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blue,
                        ),
                      ),
                    )
                  : Container(
                      child: media.size.width < 440
                          ? ListView(
                              shrinkWrap: true,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      right: 20, left: 20, top: 5),
                                  alignment: Alignment.topRight,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 7, bottom: 7),
                                            height: 36,
                                            width: 120,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color:
                                                  Color.fromRGBO(220, 9, 46, 1),
                                              border: Border.all(
                                                color: Color.fromRGBO(
                                                    220, 9, 46, 1),
                                                width: 1,
                                              ),
                                            ),
                                            child: TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetaliZakaza(
                                                        userId: widget.userId,
                                                      ),
                                                    ))
                                                    .then((val) => val
                                                        ? refreshPage()
                                                        : null);
                                              },
                                              child: const Text(
                                                'Примечание',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Roboto',
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      //----- 0  ------------
                                      if (userProcess['process']['orders'] !=
                                          null)
                                        GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              if (userProcess['process']
                                                  ['orders']['active'])
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          SostavZakaza(
                                                        userId: widget.userId,
                                                      ),
                                                    ))
                                                    .then((val) => val
                                                        ? refreshPage()
                                                        : null);
                                            },
                                            child: media.size.width < 440
                                                ? Container(
                                                    width: double.infinity,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 10,
                                                            right: 20,
                                                            left: 20),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: userProcess[
                                                                        'process']
                                                                    ['orders']
                                                                ['active']
                                                            ? Colors.white
                                                            : Colors
                                                                .grey.shade300),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              // 'Состав заказа',
                                                              '${userProcess['process']['orders']['title'] ?? ''}',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        14,
                                                                        51,
                                                                        86,
                                                                        1),
                                                              ),
                                                            ),
                                                            Text(
                                                              // 'Успешно',
                                                              '${userProcess['process']['orders']['status'] ?? ''}',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: userProcess['process']['orders']['status'] !=
                                                                            null &&
                                                                        userProcess['process']['orders']['status'].toString() ==
                                                                            'Успешно'
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .orange,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 15),
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  height: 60,
                                                                  width: 250,
                                                                  child: Text(
                                                                    // 'Товаров выбрано:',
                                                                    '${userProcess['process']['orders']['message'] ?? ''}',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              34,
                                                                              34,
                                                                              34,
                                                                              70),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                const Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  color: Colors
                                                                      .grey,
                                                                  size: 16,
                                                                ),
                                                              ]),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : Container(
                                                    width: double.infinity,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 10,
                                                            right: 20,
                                                            left: 20),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: userProcess[
                                                                        'process']
                                                                    ['orders']
                                                                ['active']
                                                            ? Colors.white
                                                            : Colors
                                                                .grey.shade300),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              // 'Состав заказа',
                                                              '${userProcess['process']['orders']['title'] ?? ''}',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        14,
                                                                        51,
                                                                        86,
                                                                        1),
                                                              ),
                                                            ),
                                                            Text(
                                                              // 'Успешно',
                                                              '${userProcess['process']['orders']['status'] ?? ''}',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: userProcess['process']['orders']['status'] !=
                                                                            null &&
                                                                        userProcess['process']['orders']['status'].toString() ==
                                                                            'Успешно'
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .orange,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 15),
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  // 'Товаров выбрано:',
                                                                  '${userProcess['process']['orders']['message'] ?? ''}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            34,
                                                                            34,
                                                                            34,
                                                                            70),
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                const Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  color: Colors
                                                                      .grey,
                                                                  size: 16,
                                                                ),
                                                              ]),
                                                        )
                                                      ],
                                                    ),
                                                  )),

                                      //----- 1  ------------
                                      if (userProcess['process']['identity'] !=
                                          null)
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            if (userProcess['process']
                                                    ['identity']['active'] ==
                                                true) {
                                              print('---- Identitry click');
                                              // Navigator.of(context).pushNamed(SostavZakaza.routeName);
                                            }
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            margin:
                                                const EdgeInsets.only(top: 8),
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                                right: 20,
                                                left: 20),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: userProcess['process']
                                                        ['identity']['active']
                                                    ? Colors.white
                                                    : Colors.grey.shade300),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      // '1. Идентификация',
                                                      '${userProcess['process']['identity']['title'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color.fromRGBO(
                                                            14, 51, 86, 1),
                                                      ),
                                                    ),
                                                    Text(
                                                      // 'Успешно',
                                                      '${userProcess['process']['identity']['status'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: userProcess['process']
                                                                            [
                                                                            'identity']
                                                                        [
                                                                        'status'] !=
                                                                    null &&
                                                                userProcess['process']['identity']
                                                                            [
                                                                            'status']
                                                                        .toString() ==
                                                                    'Успешно'
                                                            ? Colors.green
                                                            : Colors.orange,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20, top: 15),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          // Row(
                                                          //   children: [
                                                          Container(
                                                            width: 270,
                                                            height: 50,
                                                            child: Text(
                                                              // 'Имя:',
                                                              '${userProcess['process']['identity']['message'] ?? ''}',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        34,
                                                                        34,
                                                                        34,
                                                                        70),
                                                              ),
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          const Icon(
                                                            Icons
                                                                .arrow_forward_ios,
                                                            color: Colors.grey,
                                                            size: 16,
                                                          ),
                                                        ]),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),

                                      //----- 2  ------------
                                      if (userProcess['process']['info'] !=
                                          null)
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            if (userProcess['process']['info']
                                                ['active'])
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) => Dannie2(
                                                  userId: widget.userId,
                                                ),
                                              ));
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            margin:
                                                const EdgeInsets.only(top: 8),
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                                right: 20,
                                                left: 20),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: userProcess['process']
                                                        ['info']['active']
                                                    ? Colors.white
                                                    : Colors.grey.shade300),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      // '2. Данные',
                                                      '${userProcess['process']['info']['title'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color.fromRGBO(
                                                            14, 51, 86, 1),
                                                      ),
                                                    ),
                                                    Text(
                                                      // 'Успешно',
                                                      '${userProcess['process']['info']['status'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: userProcess['process']
                                                                            [
                                                                            'info']
                                                                        [
                                                                        'status'] !=
                                                                    null &&
                                                                userProcess['process']['info']
                                                                            [
                                                                            'status']
                                                                        .toString() ==
                                                                    'Успешно'
                                                            ? Colors.green
                                                            : Colors.orange,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20, top: 15),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        // Row(
                                                        //   children: [
                                                        Container(
                                                          width: 270,
                                                          height: 50,
                                                          child: Text(
                                                            // 'Номер телефона: ',
                                                            '${userProcess['process']['info']['message'] ?? ''}',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      34,
                                                                      34,
                                                                      34,
                                                                      70),
                                                            ),
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        const Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color: Colors.grey,
                                                          size: 16,
                                                        ),
                                                      ]),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),

                                      //----- 3  ------------
                                      if (userProcess['process']['client'] !=
                                          null)
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            if (userProcess['process']['client']
                                                ['active']) {
                                              print('--- client click');
                                            }
                                            // Navigator.of(context).pushNamed(Dannie2.routeName);
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            margin:
                                                const EdgeInsets.only(top: 8),
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                                right: 20,
                                                left: 20),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: userProcess['process']
                                                        ['client']['active']
                                                    ? Colors.white
                                                    : Colors.grey.shade300),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      // '3. Клиент',
                                                      '${userProcess['process']['client']['title'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color.fromRGBO(
                                                            14, 51, 86, 1),
                                                      ),
                                                    ),
                                                    Text(
                                                      // 'Успешно',
                                                      '${userProcess['process']['client']['status'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: userProcess['process']
                                                                            [
                                                                            'client']
                                                                        [
                                                                        'status'] !=
                                                                    null &&
                                                                userProcess['process']['client']
                                                                            [
                                                                            'status']
                                                                        .toString() ==
                                                                    'Успешно'
                                                            ? Colors.green
                                                            : Colors.orange,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20, top: 15),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          // 'Клиентская карточка создано',
                                                          '${userProcess['process']['client']['message'] ?? ''}',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        const Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color: Colors.grey,
                                                          size: 16,
                                                        ),
                                                      ]),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),

                                      //----- 4  ------------
                                      if (userProcess['process']['scoring'] !=
                                          null)
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            if (userProcess['process']
                                                ['scoring']['active']) {
                                              print('----- Scoring click');
                                            }
                                            // Navigator.of(context).pushNamed(Dannie2.routeName);
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            margin:
                                                const EdgeInsets.only(top: 8),
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                                right: 20,
                                                left: 20),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: userProcess['process']
                                                        ['scoring']['active']
                                                    ? Colors.white
                                                    : Colors.grey.shade300),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      // '4. Скоринг',
                                                      '${userProcess['process']['scoring']['title'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color.fromRGBO(
                                                            14, 51, 86, 1),
                                                      ),
                                                    ),
                                                    Text(
                                                      // 'Успешно',
                                                      '${userProcess['process']['scoring']['status'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: userProcess['process']
                                                                            [
                                                                            'scoring']
                                                                        [
                                                                        'status'] !=
                                                                    null &&
                                                                userProcess['process']['scoring']
                                                                            [
                                                                            'status']
                                                                        .toString() ==
                                                                    'Успешно'
                                                            ? Colors.green
                                                            : Colors.orange,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20, top: 15),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: 250,
                                                          height: 50,
                                                          child: Text(
                                                            // 'Скоринг пройдено',
                                                            '${userProcess['process']['scoring']['message'] ?? ''}',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        const Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color: Colors.grey,
                                                          size: 16,
                                                        ),
                                                      ]),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),

                                      //----- 5  ------------
                                      if (userProcess['process']
                                              ['registration'] !=
                                          null)
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            // Navigator.of(context)
                                            //     .pushNamed(Oformlenie5.routeName);
                                            if (userProcess['process']
                                                ['registration']['active'])
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    Oformlenie5(
                                                  userId: widget.userId,
                                                ),
                                              ));
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            margin:
                                                const EdgeInsets.only(top: 8),
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                                right: 20,
                                                left: 20),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: userProcess['process']
                                                            ['registration']
                                                        ['active']
                                                    ? Colors.white
                                                    : Colors.grey.shade300),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      // '5. Оформление ',
                                                      '${userProcess['process']['registration']['title'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color.fromRGBO(
                                                            14, 51, 86, 1),
                                                      ),
                                                    ),
                                                    Text(
                                                      // 'Успешно',
                                                      '${userProcess['process']['registration']['status'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: userProcess['process']
                                                                            [
                                                                            'registration']
                                                                        [
                                                                        'status'] !=
                                                                    null &&
                                                                userProcess['process']['registration']
                                                                            [
                                                                            'status']
                                                                        .toString() ==
                                                                    'Успешно'
                                                            ? Colors.green
                                                            : Colors.orange,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20, top: 15),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: 270,
                                                          height: 50,
                                                          child: Text(
                                                            // 'Выберите один из параметров 4, 6, 9, 12',
                                                            '${userProcess['process']['registration']['message'] ?? ''}',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        const Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color: Colors.grey,
                                                          size: 16,
                                                        ),
                                                      ]),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),

                                      //----- 6  ------------
                                      if (userProcess['process']['contract'] !=
                                          null)
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            if (userProcess['process']
                                                ['contract']['active'])
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) => Dogovor6(
                                                  userId: widget.userId,
                                                ),
                                              ));
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            margin:
                                                const EdgeInsets.only(top: 8),
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                                right: 20,
                                                left: 20),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: userProcess['process']
                                                        ['contract']['active']
                                                    ? Colors.white
                                                    : Colors.grey.shade300),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      // '6. Договор',
                                                      '${userProcess['process']['contract']['title'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color.fromRGBO(
                                                            14, 51, 86, 1),
                                                      ),
                                                    ),
                                                    Text(
                                                      // 'Успешно',
                                                      '${userProcess['process']['contract']['status'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: userProcess['process']
                                                                            [
                                                                            'contract']
                                                                        [
                                                                        'status'] !=
                                                                    null &&
                                                                userProcess['process']['contract']
                                                                            [
                                                                            'status']
                                                                        .toString() ==
                                                                    'Успешно'
                                                            ? Colors.green
                                                            : Colors.orange,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20, top: 15),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          // 'Дата погашения: ',
                                                          '${userProcess['process']['contract']['message'] ?? ''}',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                Color.fromRGBO(
                                                                    34,
                                                                    34,
                                                                    34,
                                                                    70),
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        const Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color: Colors.grey,
                                                          size: 16,
                                                        ),
                                                      ]),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),

                                      //----- 7  ------------
                                      if (userProcess['process']['confirm'] !=
                                          null)
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            if (userProcess['process']
                                                ['confirm']['active'])
                                              setState(() {
                                                loader = true;
                                              });
                                            getAutoPayStatusLogik(
                                                    tokenFromLocaleStorage:
                                                        tokenFromLocaleStorage,
                                                    id: widget.userId!)
                                                .then((value) {
                                              print(
                                                  '------------------ value ${value}');

                                              // print(
                                              //     '+++++++++++++++++ value ${value['data']['confirmed']}');
                                              // print(
                                              //     '+++++++++++++++++ value ${value['data']['cardDate']}');
                                              // print(
                                              //     '+++++++++++++++++ value ${value['data']['cardNumber']}');

                                              if (value['msg'] == 'not found') {
                                                print('1');
                                                if (userProcess['process']
                                                    ['confirm']['active']) {
                                                  setState(() {
                                                    loader = true;
                                                  });
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            Podverjenie7(
                                                          userId: widget.userId,
                                                          userData: '',
                                                          userDataCartNumber:
                                                              '',
                                                          userConfirmed: '',
                                                          msg: value['msg'],
                                                        ),
                                                      ))
                                                      .then((val) => val
                                                          ? refreshPage()
                                                          : null);
                                                  ;
                                                  setState(() {
                                                    // loader = false;
                                                  });
                                                }
                                              }
                                              if (value['data']['confirmed'] ==
                                                  true) {
                                                print('2');
                                                if (userProcess['process']
                                                    ['confirm']['active']) {
                                                  setState(() {
                                                    loader = true;
                                                  });
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  Podverjenie7(
                                                                    userId: widget
                                                                        .userId,
                                                                    userData: value['data']
                                                                            [
                                                                            'cardDate']
                                                                        .toString(),
                                                                    userDataCartNumber:
                                                                        value['data']['cardNumber']
                                                                            .toString(),
                                                                    userConfirmed:
                                                                        value['data']['confirmed']
                                                                            .toString(),
                                                                    msg: value[
                                                                        'msg'],
                                                                  )))
                                                      .then((val) => val
                                                          ? refreshPage()
                                                          : null);
                                                  ;
                                                  setState(() {
                                                    // loader = false;
                                                  });
                                                }
                                              }
                                              if (value['data']['confirmed'] ==
                                                  false) {
                                                print('3');
                                                if (userProcess['process']
                                                    ['confirm']['active']) {
                                                  setState(() {
                                                    loader = true;
                                                  });
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            Podtvejdenie7SmsCode(
                                                          userId: widget.userId,
                                                        ),
                                                      ))
                                                      .then((val) => val
                                                          ? refreshPage()
                                                          : null);
                                                  ;
                                                  setState(() {
                                                    // loader = false;
                                                  });
                                                }
                                              }
                                            });

                                            // if (userConfirmed == false) {
                                            //   Navigator.of(context).push(MaterialPageRoute(
                                            //     builder: (context) => Podverjenie7(
                                            //       userId: widget.userId,
                                            //     ),
                                            //   ));
                                            // }
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            margin:
                                                const EdgeInsets.only(top: 8),
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                                right: 20,
                                                left: 20),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: userProcess['process']
                                                        ['confirm']['active']
                                                    ? Colors.white
                                                    : Colors.grey.shade300),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      // '7. Подтверждение ',
                                                      '${userProcess['process']['confirm']['title'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color.fromRGBO(
                                                            14, 51, 86, 1),
                                                      ),
                                                    ),
                                                    Text(
                                                      // 'Успешно',
                                                      '${userProcess['process']['confirm']['status'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: userProcess['process']
                                                                            [
                                                                            'confirm']
                                                                        [
                                                                        'status'] !=
                                                                    null &&
                                                                userProcess['process']['confirm']
                                                                            [
                                                                            'status']
                                                                        .toString() ==
                                                                    'Успешно'
                                                            ? Colors.green
                                                            : Colors.orange,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20, top: 15),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          // 'В телефон клиента отправлено СМС',
                                                          '${userProcess['process']['confirm']['message'] ?? ''}',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        const Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color: Colors.grey,
                                                          size: 16,
                                                        ),
                                                      ]),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),

                                      //----- 8  ------------
                                      if (userProcess['process']['schedule'] !=
                                          null)
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            // if (userProcess['process']['schedule']
                                            //     ['active'])
                                            //   Navigator.of(context)
                                            //       .pushNamed(Grafic8.routeName);

                                            if (userProcess['process']
                                                ['schedule']['active'])
                                              setState(() {
                                                loader = true;
                                              });
                                            getQrCode(
                                                    tokenFromLocaleStorage:
                                                        tokenFromLocaleStorage,
                                                    id: widget.userId)
                                                .then((value) {
                                              print(
                                                  '------------------ value ${value}');

                                              // print(
                                              //     '+++++++++++++++++ value ${value['data']['confirmed']}');
                                              // print(
                                              //     '+++++++++++++++++ value ${value['data']['cardDate']}');
                                              print(
                                                  '+++++++++++++++++ data ${value['data']}');

                                              if (userProcess['process']
                                                  ['schedule']['active']) {
                                                setState(() {
                                                  loader = true;
                                                });
                                                if (value['data'] != null) {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            Grafic8(
                                                          userId: widget.userId,
                                                          monthly: value['data']
                                                              ['monthly'],
                                                          overpay: value['data']
                                                              ['overpay'],
                                                          period: value['data']
                                                              ['period'],
                                                          productTotal: value[
                                                                  'data']
                                                              ['productTotal'],
                                                          reportUrl:
                                                              value['data']
                                                                  ['reportUrl'],
                                                          total: value['data']
                                                              ['total'],

                                                          // msg: value['msg'],
                                                        ),
                                                      ))
                                                      .then((val) => val
                                                          ? refreshPage()
                                                          : null);
                                                } else {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            Grafic8Message(
                                                          userId: widget.userId,
                                                          data: value['data'],
                                                          msg: value['msg'],
                                                        ),
                                                      ))
                                                      .then((val) => val
                                                          ? refreshPage()
                                                          : null);
                                                }
                                              }
                                            });
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            margin:
                                                const EdgeInsets.only(top: 8),
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                                right: 20,
                                                left: 20),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: userProcess['process']
                                                        ['schedule']['active']
                                                    ? Colors.white
                                                    : Colors.grey.shade300),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      // '8. График',
                                                      '${userProcess['process']['schedule']['title'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color.fromRGBO(
                                                            14, 51, 86, 1),
                                                      ),
                                                    ),
                                                    Text(
                                                      // 'Успешно',
                                                      '${userProcess['process']['schedule']['status'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: userProcess['process']
                                                                            [
                                                                            'schedule']
                                                                        [
                                                                        'status'] !=
                                                                    null &&
                                                                userProcess['process']['schedule']
                                                                            [
                                                                            'status']
                                                                        .toString() ==
                                                                    'Успешно'
                                                            ? Colors.green
                                                            : Colors.orange,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20, top: 15),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          // 'Номер телефона: ',
                                                          '${userProcess['process']['schedule']['message'] ?? ''}',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                Color.fromRGBO(
                                                                    34,
                                                                    34,
                                                                    34,
                                                                    70),
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        const Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color: Colors.grey,
                                                          size: 16,
                                                        ),
                                                      ]),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),

                                      //----- 9  ------------

                                      // GestureDetector(
                                      //   behavior: HitTestBehavior.opaque,
                                      //   onTap: () {
                                      //     Navigator.of(context)
                                      //         .pushNamed(Dostavka9.routeName);
                                      //   },
                                      //   child: Container(
                                      //     width: double.infinity,
                                      //     margin: const EdgeInsets.only(top: 8),
                                      //     padding: const EdgeInsets.only(
                                      //         top: 10, bottom: 10, right: 20, left: 20),
                                      //     decoration: BoxDecoration(
                                      //       borderRadius: BorderRadius.circular(5),
                                      //       color: Colors.white,
                                      //     ),
                                      //     child: Column(
                                      //       crossAxisAlignment: CrossAxisAlignment.start,
                                      //       children: [
                                      //         Row(
                                      //           mainAxisAlignment:
                                      //               MainAxisAlignment.spaceBetween,
                                      //           children: [
                                      //             Text(
                                      //               // '9. Доставка',
                                      //               '${userProcess['process']['delivery']['title'] ?? ''}',
                                      //               style: TextStyle(
                                      //                 fontFamily: 'Roboto',
                                      //                 fontSize: 20,
                                      //                 fontWeight: FontWeight.w500,
                                      //                 color: Color.fromRGBO(14, 51, 86, 1),
                                      //               ),
                                      //             ),
                                      //             Text(
                                      //               // 'Успешно',
                                      //               '${userProcess['process']['delivery']['status'] ?? ''}',
                                      //               style: TextStyle(
                                      //                 fontFamily: 'Roboto',
                                      //                 fontSize: 16,
                                      //                 fontWeight: FontWeight.w400,
                                      //                 color: userProcess['process']
                                      //                                     ['delivery']
                                      //                                 ['status'] !=
                                      //                             null &&
                                      //                         userProcess['process']
                                      //                                         ['delivery']
                                      //                                     ['status']
                                      //                                 .toString() ==
                                      //                             'Успешно'
                                      //                     ? Colors.green
                                      //                     : Colors.orange,
                                      //               ),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //         Container(
                                      //           padding: const EdgeInsets.only(
                                      //               left: 20, top: 15),
                                      //           child: Row(
                                      //               mainAxisAlignment:
                                      //                   MainAxisAlignment.start,
                                      //               children: [
                                      //                 Text(
                                      //                   // 'Товар готов к отправке по адресу: ',
                                      //                   '${userProcess['process']['delivery']['message'] ?? ''}',
                                      //                   style: TextStyle(
                                      //                     fontFamily: 'Roboto',
                                      //                     fontSize: 16,
                                      //                     fontWeight: FontWeight.w400,
                                      //                     color: Color.fromRGBO(
                                      //                         34, 34, 34, 70),
                                      //                   ),
                                      //                 ),
                                      //                 Spacer(),
                                      //                 const Icon(
                                      //                   Icons.arrow_forward_ios,
                                      //                   color: Colors.grey,
                                      //                   size: 16,
                                      //                 ),
                                      //               ]),
                                      //         )
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                      Center(
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              top: 30, bottom: 30),
                                          child: Text(
                                            // 'Текущее состояние',
                                            '${userProcess['state'] == null ? '' : userProcess['state']}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Roboto',
                                                color: Colors.black),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          : ListView(
                              shrinkWrap: true,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      right: 20, left: 20, top: 5),
                                  alignment: Alignment.topRight,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 7, bottom: 7),
                                            height: 36,
                                            width: 120,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color:
                                                  Color.fromRGBO(220, 9, 46, 1),
                                              border: Border.all(
                                                color: Color.fromRGBO(
                                                    220, 9, 46, 1),
                                                width: 1,
                                              ),
                                            ),
                                            child: TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetaliZakaza(
                                                        userId: widget.userId,
                                                      ),
                                                    ))
                                                    .then((val) => val
                                                        ? refreshPage()
                                                        : null);
                                              },
                                              child: const Text(
                                                'Примечание',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Roboto',
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      //----- 0  ------------
                                      if (userProcess['process']['orders'] !=
                                          null)
                                        GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              if (userProcess['process']
                                                  ['orders']['active'])
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          SostavZakaza(
                                                        userId: widget.userId,
                                                      ),
                                                    ))
                                                    .then((val) => val
                                                        ? refreshPage()
                                                        : null);
                                            },
                                            child: media.size.width < 440
                                                ? Container(
                                                    width: double.infinity,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 10,
                                                            right: 20,
                                                            left: 20),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: userProcess[
                                                                        'process']
                                                                    ['orders']
                                                                ['active']
                                                            ? Colors.white
                                                            : Colors
                                                                .grey.shade300),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              // 'Состав заказа',
                                                              '${userProcess['process']['orders']['title'] ?? ''}',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        14,
                                                                        51,
                                                                        86,
                                                                        1),
                                                              ),
                                                            ),
                                                            Text(
                                                              // 'Успешно',
                                                              '${userProcess['process']['orders']['status'] ?? ''}',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: userProcess['process']['orders']['status'] !=
                                                                            null &&
                                                                        userProcess['process']['orders']['status'].toString() ==
                                                                            'Успешно'
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .orange,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 15),
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  height: 60,
                                                                  width: 250,
                                                                  child: Text(
                                                                    // 'Товаров выбрано:',
                                                                    '${userProcess['process']['orders']['message'] ?? ''}',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              34,
                                                                              34,
                                                                              34,
                                                                              70),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                const Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  color: Colors
                                                                      .grey,
                                                                  size: 16,
                                                                ),
                                                              ]),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : Container(
                                                    width: double.infinity,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 10,
                                                            right: 20,
                                                            left: 20),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: userProcess[
                                                                        'process']
                                                                    ['orders']
                                                                ['active']
                                                            ? Colors.white
                                                            : Colors
                                                                .grey.shade300),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              // 'Состав заказа',
                                                              '${userProcess['process']['orders']['title'] ?? ''}',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        14,
                                                                        51,
                                                                        86,
                                                                        1),
                                                              ),
                                                            ),
                                                            Text(
                                                              // 'Успешно',
                                                              '${userProcess['process']['orders']['status'] ?? ''}',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: userProcess['process']['orders']['status'] !=
                                                                            null &&
                                                                        userProcess['process']['orders']['status'].toString() ==
                                                                            'Успешно'
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .orange,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 15),
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  // 'Товаров выбрано:',
                                                                  '${userProcess['process']['orders']['message'] ?? ''}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            34,
                                                                            34,
                                                                            34,
                                                                            70),
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                const Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  color: Colors
                                                                      .grey,
                                                                  size: 16,
                                                                ),
                                                              ]),
                                                        )
                                                      ],
                                                    ),
                                                  )),

                                      //----- 1  ------------
                                      if (userProcess['process']['identity'] !=
                                          null)
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            if (userProcess['process']
                                                    ['identity']['active'] ==
                                                true) {
                                              print('---- Identitry click');
                                              // Navigator.of(context).pushNamed(SostavZakaza.routeName);
                                            }
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            margin:
                                                const EdgeInsets.only(top: 8),
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                                right: 20,
                                                left: 20),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: userProcess['process']
                                                        ['identity']['active']
                                                    ? Colors.white
                                                    : Colors.grey.shade300),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      // '1. Идентификация',
                                                      '${userProcess['process']['identity']['title'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color.fromRGBO(
                                                            14, 51, 86, 1),
                                                      ),
                                                    ),
                                                    Text(
                                                      // 'Успешно',
                                                      '${userProcess['process']['identity']['status'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: userProcess['process']
                                                                            [
                                                                            'identity']
                                                                        [
                                                                        'status'] !=
                                                                    null &&
                                                                userProcess['process']['identity']
                                                                            [
                                                                            'status']
                                                                        .toString() ==
                                                                    'Успешно'
                                                            ? Colors.green
                                                            : Colors.orange,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20, top: 15),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          // Row(
                                                          //   children: [
                                                          Text(
                                                            // 'Имя:',
                                                            '${userProcess['process']['identity']['message'] ?? ''}',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      34,
                                                                      34,
                                                                      34,
                                                                      70),
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          const Icon(
                                                            Icons
                                                                .arrow_forward_ios,
                                                            color: Colors.grey,
                                                            size: 16,
                                                          ),
                                                        ]),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),

                                      //----- 2  ------------
                                      if (userProcess['process']['info'] !=
                                          null)
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            if (userProcess['process']['info']
                                                ['active'])
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) => Dannie2(
                                                  userId: widget.userId,
                                                ),
                                              ));
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            margin:
                                                const EdgeInsets.only(top: 8),
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                                right: 20,
                                                left: 20),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: userProcess['process']
                                                        ['info']['active']
                                                    ? Colors.white
                                                    : Colors.grey.shade300),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      // '2. Данные',
                                                      '${userProcess['process']['info']['title'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color.fromRGBO(
                                                            14, 51, 86, 1),
                                                      ),
                                                    ),
                                                    Text(
                                                      // 'Успешно',
                                                      '${userProcess['process']['info']['status'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: userProcess['process']
                                                                            [
                                                                            'info']
                                                                        [
                                                                        'status'] !=
                                                                    null &&
                                                                userProcess['process']['info']
                                                                            [
                                                                            'status']
                                                                        .toString() ==
                                                                    'Успешно'
                                                            ? Colors.green
                                                            : Colors.orange,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20, top: 15),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        // Row(
                                                        //   children: [
                                                        Text(
                                                          // 'Номер телефона: ',
                                                          '${userProcess['process']['info']['message'] ?? ''}',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                Color.fromRGBO(
                                                                    34,
                                                                    34,
                                                                    34,
                                                                    70),
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        const Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color: Colors.grey,
                                                          size: 16,
                                                        ),
                                                      ]),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),

                                      //----- 3  ------------
                                      if (userProcess['process']['client'] !=
                                          null)
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            if (userProcess['process']['client']
                                                ['active']) {
                                              print('--- client click');
                                            }
                                            // Navigator.of(context).pushNamed(Dannie2.routeName);
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            margin:
                                                const EdgeInsets.only(top: 8),
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                                right: 20,
                                                left: 20),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: userProcess['process']
                                                        ['client']['active']
                                                    ? Colors.white
                                                    : Colors.grey.shade300),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      // '3. Клиент',
                                                      '${userProcess['process']['client']['title'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color.fromRGBO(
                                                            14, 51, 86, 1),
                                                      ),
                                                    ),
                                                    Text(
                                                      // 'Успешно',
                                                      '${userProcess['process']['client']['status'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: userProcess['process']
                                                                            [
                                                                            'client']
                                                                        [
                                                                        'status'] !=
                                                                    null &&
                                                                userProcess['process']['client']
                                                                            [
                                                                            'status']
                                                                        .toString() ==
                                                                    'Успешно'
                                                            ? Colors.green
                                                            : Colors.orange,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20, top: 15),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          // 'Клиентская карточка создано',
                                                          '${userProcess['process']['client']['message'] ?? ''}',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        const Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color: Colors.grey,
                                                          size: 16,
                                                        ),
                                                      ]),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),

                                      //----- 4  ------------
                                      if (userProcess['process']['scoring'] !=
                                          null)
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            if (userProcess['process']
                                                ['scoring']['active']) {
                                              print('----- Scoring click');
                                            }
                                            // Navigator.of(context).pushNamed(Dannie2.routeName);
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            margin:
                                                const EdgeInsets.only(top: 8),
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                                right: 20,
                                                left: 20),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: userProcess['process']
                                                        ['scoring']['active']
                                                    ? Colors.white
                                                    : Colors.grey.shade300),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      // '4. Скоринг',
                                                      '${userProcess['process']['scoring']['title'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color.fromRGBO(
                                                            14, 51, 86, 1),
                                                      ),
                                                    ),
                                                    Text(
                                                      // 'Успешно',
                                                      '${userProcess['process']['scoring']['status'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: userProcess['process']
                                                                            [
                                                                            'scoring']
                                                                        [
                                                                        'status'] !=
                                                                    null &&
                                                                userProcess['process']['scoring']
                                                                            [
                                                                            'status']
                                                                        .toString() ==
                                                                    'Успешно'
                                                            ? Colors.green
                                                            : Colors.orange,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20, top: 15),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          // 'Скоринг пройдено',
                                                          '${userProcess['process']['scoring']['message'] ?? ''}',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        const Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color: Colors.grey,
                                                          size: 16,
                                                        ),
                                                      ]),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),

                                      //----- 5  ------------
                                      if (userProcess['process']
                                              ['registration'] !=
                                          null)
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            // Navigator.of(context)
                                            //     .pushNamed(Oformlenie5.routeName);
                                            if (userProcess['process']
                                                ['registration']['active'])
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    Oformlenie5(
                                                  userId: widget.userId,
                                                ),
                                              ));
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            margin:
                                                const EdgeInsets.only(top: 8),
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                                right: 20,
                                                left: 20),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: userProcess['process']
                                                            ['registration']
                                                        ['active']
                                                    ? Colors.white
                                                    : Colors.grey.shade300),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      // '5. Оформление ',
                                                      '${userProcess['process']['registration']['title'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color.fromRGBO(
                                                            14, 51, 86, 1),
                                                      ),
                                                    ),
                                                    Text(
                                                      // 'Успешно',
                                                      '${userProcess['process']['registration']['status'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: userProcess['process']
                                                                            [
                                                                            'registration']
                                                                        [
                                                                        'status'] !=
                                                                    null &&
                                                                userProcess['process']['registration']
                                                                            [
                                                                            'status']
                                                                        .toString() ==
                                                                    'Успешно'
                                                            ? Colors.green
                                                            : Colors.orange,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20, top: 15),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          // 'Выберите один из параметров 4, 6, 9, 12',
                                                          '${userProcess['process']['registration']['message'] ?? ''}',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        const Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color: Colors.grey,
                                                          size: 16,
                                                        ),
                                                      ]),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),

                                      //----- 6  ------------
                                      if (userProcess['process']['contract'] !=
                                          null)
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            if (userProcess['process']
                                                ['contract']['active'])
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) => Dogovor6(
                                                  userId: widget.userId,
                                                ),
                                              ));
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            margin:
                                                const EdgeInsets.only(top: 8),
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                                right: 20,
                                                left: 20),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: userProcess['process']
                                                        ['contract']['active']
                                                    ? Colors.white
                                                    : Colors.grey.shade300),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      // '6. Договор',
                                                      '${userProcess['process']['contract']['title'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color.fromRGBO(
                                                            14, 51, 86, 1),
                                                      ),
                                                    ),
                                                    Text(
                                                      // 'Успешно',
                                                      '${userProcess['process']['contract']['status'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: userProcess['process']
                                                                            [
                                                                            'contract']
                                                                        [
                                                                        'status'] !=
                                                                    null &&
                                                                userProcess['process']['contract']
                                                                            [
                                                                            'status']
                                                                        .toString() ==
                                                                    'Успешно'
                                                            ? Colors.green
                                                            : Colors.orange,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20, top: 15),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          // 'Дата погашения: ',
                                                          '${userProcess['process']['contract']['message'] ?? ''}',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                Color.fromRGBO(
                                                                    34,
                                                                    34,
                                                                    34,
                                                                    70),
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        const Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color: Colors.grey,
                                                          size: 16,
                                                        ),
                                                      ]),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),

                                      //----- 7  ------------
                                      if (userProcess['process']['confirm'] !=
                                          null)
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            if (userProcess['process']
                                                ['confirm']['active'])
                                              setState(() {
                                                loader = true;
                                              });
                                            getAutoPayStatusLogik(
                                                    tokenFromLocaleStorage:
                                                        tokenFromLocaleStorage,
                                                    id: widget.userId!)
                                                .then((value) {
                                              print(
                                                  '------------------ value ${value}');

                                              // print(
                                              //     '+++++++++++++++++ value ${value['data']['confirmed']}');
                                              // print(
                                              //     '+++++++++++++++++ value ${value['data']['cardDate']}');
                                              // print(
                                              //     '+++++++++++++++++ value ${value['data']['cardNumber']}');

                                              if (value['msg'] == 'not found') {
                                                print('1');
                                                if (userProcess['process']
                                                    ['confirm']['active']) {
                                                  setState(() {
                                                    loader = true;
                                                  });
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            Podverjenie7(
                                                          userId: widget.userId,
                                                          userData: '',
                                                          userDataCartNumber:
                                                              '',
                                                          userConfirmed: '',
                                                          msg: value['msg'],
                                                        ),
                                                      ))
                                                      .then((val) => val
                                                          ? refreshPage()
                                                          : null);
                                                  ;
                                                  setState(() {
                                                    // loader = false;
                                                  });
                                                }
                                              }
                                              if (value['data']['confirmed'] ==
                                                  true) {
                                                print('2');
                                                if (userProcess['process']
                                                    ['confirm']['active']) {
                                                  setState(() {
                                                    loader = true;
                                                  });
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  Podverjenie7(
                                                                    userId: widget
                                                                        .userId,
                                                                    userData: value['data']
                                                                            [
                                                                            'cardDate']
                                                                        .toString(),
                                                                    userDataCartNumber:
                                                                        value['data']['cardNumber']
                                                                            .toString(),
                                                                    userConfirmed:
                                                                        value['data']['confirmed']
                                                                            .toString(),
                                                                    msg: value[
                                                                        'msg'],
                                                                  )))
                                                      .then((val) => val
                                                          ? refreshPage()
                                                          : null);
                                                  ;
                                                  setState(() {
                                                    // loader = false;
                                                  });
                                                }
                                              }
                                              if (value['data']['confirmed'] ==
                                                  false) {
                                                print('3');
                                                if (userProcess['process']
                                                    ['confirm']['active']) {
                                                  setState(() {
                                                    loader = true;
                                                  });
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            Podtvejdenie7SmsCode(
                                                          userId: widget.userId,
                                                        ),
                                                      ))
                                                      .then((val) => val
                                                          ? refreshPage()
                                                          : null);
                                                  ;
                                                  setState(() {
                                                    // loader = false;
                                                  });
                                                }
                                              }
                                            });

                                            // if (userConfirmed == false) {
                                            //   Navigator.of(context).push(MaterialPageRoute(
                                            //     builder: (context) => Podverjenie7(
                                            //       userId: widget.userId,
                                            //     ),
                                            //   ));
                                            // }
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            margin:
                                                const EdgeInsets.only(top: 8),
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                                right: 20,
                                                left: 20),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: userProcess['process']
                                                        ['confirm']['active']
                                                    ? Colors.white
                                                    : Colors.grey.shade300),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      // '7. Подтверждение ',
                                                      '${userProcess['process']['confirm']['title'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color.fromRGBO(
                                                            14, 51, 86, 1),
                                                      ),
                                                    ),
                                                    Text(
                                                      // 'Успешно',
                                                      '${userProcess['process']['confirm']['status'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: userProcess['process']
                                                                            [
                                                                            'confirm']
                                                                        [
                                                                        'status'] !=
                                                                    null &&
                                                                userProcess['process']['confirm']
                                                                            [
                                                                            'status']
                                                                        .toString() ==
                                                                    'Успешно'
                                                            ? Colors.green
                                                            : Colors.orange,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20, top: 15),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          // 'В телефон клиента отправлено СМС',
                                                          '${userProcess['process']['confirm']['message'] ?? ''}',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        const Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color: Colors.grey,
                                                          size: 16,
                                                        ),
                                                      ]),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),

                                      //----- 8  ------------
                                      if (userProcess['process']['schedule'] !=
                                          null)
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            // if (userProcess['process']['schedule']
                                            //     ['active'])
                                            //   Navigator.of(context)
                                            //       .pushNamed(Grafic8.routeName);

                                            if (userProcess['process']
                                                ['schedule']['active'])
                                              setState(() {
                                                loader = true;
                                              });
                                            getQrCode(
                                                    tokenFromLocaleStorage:
                                                        tokenFromLocaleStorage,
                                                    id: widget.userId)
                                                .then((value) {
                                              print(
                                                  '------------------ value ${value}');

                                              // print(
                                              //     '+++++++++++++++++ value ${value['data']['confirmed']}');
                                              // print(
                                              //     '+++++++++++++++++ value ${value['data']['cardDate']}');
                                              print(
                                                  '+++++++++++++++++ data ${value['data']}');

                                              if (userProcess['process']
                                                  ['schedule']['active']) {
                                                setState(() {
                                                  loader = true;
                                                });
                                                if (value['data'] != null) {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            Grafic8(
                                                          userId: widget.userId,
                                                          monthly: value['data']
                                                              ['monthly'],
                                                          overpay: value['data']
                                                              ['overpay'],
                                                          period: value['data']
                                                              ['period'],
                                                          productTotal: value[
                                                                  'data']
                                                              ['productTotal'],
                                                          reportUrl:
                                                              value['data']
                                                                  ['reportUrl'],
                                                          total: value['data']
                                                              ['total'],

                                                          // msg: value['msg'],
                                                        ),
                                                      ))
                                                      .then((val) => val
                                                          ? refreshPage()
                                                          : null);
                                                } else {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            Grafic8Message(
                                                          userId: widget.userId,
                                                          data: value['data'],
                                                          msg: value['msg'],
                                                        ),
                                                      ))
                                                      .then((val) => val
                                                          ? refreshPage()
                                                          : null);
                                                }
                                              }
                                            });
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            margin:
                                                const EdgeInsets.only(top: 8),
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                                right: 20,
                                                left: 20),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: userProcess['process']
                                                        ['schedule']['active']
                                                    ? Colors.white
                                                    : Colors.grey.shade300),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      // '8. График',
                                                      '${userProcess['process']['schedule']['title'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color.fromRGBO(
                                                            14, 51, 86, 1),
                                                      ),
                                                    ),
                                                    Text(
                                                      // 'Успешно',
                                                      '${userProcess['process']['schedule']['status'] ?? ''}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: userProcess['process']
                                                                            [
                                                                            'schedule']
                                                                        [
                                                                        'status'] !=
                                                                    null &&
                                                                userProcess['process']['schedule']
                                                                            [
                                                                            'status']
                                                                        .toString() ==
                                                                    'Успешно'
                                                            ? Colors.green
                                                            : Colors.orange,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20, top: 15),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          // 'Номер телефона: ',
                                                          '${userProcess['process']['schedule']['message'] ?? ''}',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                Color.fromRGBO(
                                                                    34,
                                                                    34,
                                                                    34,
                                                                    70),
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        const Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color: Colors.grey,
                                                          size: 16,
                                                        ),
                                                      ]),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),

                                      //----- 9  ------------

                                      // GestureDetector(
                                      //   behavior: HitTestBehavior.opaque,
                                      //   onTap: () {
                                      //     Navigator.of(context)
                                      //         .pushNamed(Dostavka9.routeName);
                                      //   },
                                      //   child: Container(
                                      //     width: double.infinity,
                                      //     margin: const EdgeInsets.only(top: 8),
                                      //     padding: const EdgeInsets.only(
                                      //         top: 10, bottom: 10, right: 20, left: 20),
                                      //     decoration: BoxDecoration(
                                      //       borderRadius: BorderRadius.circular(5),
                                      //       color: Colors.white,
                                      //     ),
                                      //     child: Column(
                                      //       crossAxisAlignment: CrossAxisAlignment.start,
                                      //       children: [
                                      //         Row(
                                      //           mainAxisAlignment:
                                      //               MainAxisAlignment.spaceBetween,
                                      //           children: [
                                      //             Text(
                                      //               // '9. Доставка',
                                      //               '${userProcess['process']['delivery']['title'] ?? ''}',
                                      //               style: TextStyle(
                                      //                 fontFamily: 'Roboto',
                                      //                 fontSize: 20,
                                      //                 fontWeight: FontWeight.w500,
                                      //                 color: Color.fromRGBO(14, 51, 86, 1),
                                      //               ),
                                      //             ),
                                      //             Text(
                                      //               // 'Успешно',
                                      //               '${userProcess['process']['delivery']['status'] ?? ''}',
                                      //               style: TextStyle(
                                      //                 fontFamily: 'Roboto',
                                      //                 fontSize: 16,
                                      //                 fontWeight: FontWeight.w400,
                                      //                 color: userProcess['process']
                                      //                                     ['delivery']
                                      //                                 ['status'] !=
                                      //                             null &&
                                      //                         userProcess['process']
                                      //                                         ['delivery']
                                      //                                     ['status']
                                      //                                 .toString() ==
                                      //                             'Успешно'
                                      //                     ? Colors.green
                                      //                     : Colors.orange,
                                      //               ),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //         Container(
                                      //           padding: const EdgeInsets.only(
                                      //               left: 20, top: 15),
                                      //           child: Row(
                                      //               mainAxisAlignment:
                                      //                   MainAxisAlignment.start,
                                      //               children: [
                                      //                 Text(
                                      //                   // 'Товар готов к отправке по адресу: ',
                                      //                   '${userProcess['process']['delivery']['message'] ?? ''}',
                                      //                   style: TextStyle(
                                      //                     fontFamily: 'Roboto',
                                      //                     fontSize: 16,
                                      //                     fontWeight: FontWeight.w400,
                                      //                     color: Color.fromRGBO(
                                      //                         34, 34, 34, 70),
                                      //                   ),
                                      //                 ),
                                      //                 Spacer(),
                                      //                 const Icon(
                                      //                   Icons.arrow_forward_ios,
                                      //                   color: Colors.grey,
                                      //                   size: 16,
                                      //                 ),
                                      //               ]),
                                      //         )
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                      Center(
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              top: 30, bottom: 30),
                                          child: Text(
                                            // 'Текущее состояние',
                                            '${userProcess['state'] == null ? '' : userProcess['state']}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Roboto',
                                                color: Colors.black),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                    ),
        ),
      ),
    );
  }
}
