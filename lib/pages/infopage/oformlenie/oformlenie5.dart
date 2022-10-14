import 'dart:collection';

import 'package:MyID/providers/client_data.dart';
import 'package:MyID/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/mainGraphQl/servises/get_score_limit.dart';
import '../../../utils/mainGraphQl/servises/get_turm_refs.dart';
import '../../../utils/mainGraphQl/servises/set_score_limit.dart';
import '../sostav_zakaza0/sostav_zakaza.dart';
import 'oformlenie_list.dart';

class Oformlenie5 extends StatefulWidget {
  static const String routeName = '/oformlenie5';
  String userId;
  Oformlenie5({Key? key, required this.userId}) : super(key: key);

  @override
  State<Oformlenie5> createState() => _SostavZakazaState();
}

class _SostavZakazaState extends State<Oformlenie5> {
  List<bool> expanded = [false, false];
  final creditList = ['6 месяцев', '9 месяцев', '12 месяцев', '14 месяцев'];

  List<dynamic> creditListElements = [];
  Map<String, String> pIds = HashMap();
  String? creditPer;
  String? creditSumPer1;

  var tokenFromLocaleStorage = '';
  var size;

  int selectedMonth = 0;
  int? scoreCode = Constants.CODE_DEFAULT;
  String? scoreMsg = '';
  String? scoreMonthly = '0.00';
  String? scoreOverpay = '0.00';
  String? scoreTotalInsSum = '0.00';
  String? scoreSuccessMsg =
      'Оформление рассрочки на выбранный период возможно.';

  loadLocaleStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tokenFromLocaleStorage = prefs.getString('token')!;
    });
  }

  var listEls;

  @override
  void initState() {
    super.initState();
    loadLocaleStorage();
    refreshPage();
    if (ClientData.is0OrdersLoading) {
      refreshOrders();
    }
  }

  Future refreshPage() async {
    while (tokenFromLocaleStorage == '') {
      loadLocaleStorage();
      await Future.delayed(const Duration(seconds: 1));
    }
    getTermRefsQuery(tokenFromLocaleStorage: tokenFromLocaleStorage).then(
      (value) => {
        creditListElements = [],
        if (value['data'] != null)
          {
            setState(() {
              size = value['data'].length;
              for (int i = 0; i < value['data'].length; i++) {
                creditListElements.add(
                  value['data'][i]['name'].toString(),
                );
                pIds.putIfAbsent(value['data'][i]['name'].toString(),
                    () => value['data'][i]['pId'].toString());
              }
              ;
            }),
          }
      },
    );
  }

  Future getScoreLimitForMonth() async {
    getScoreLimit(
            claimsId: widget.userId,
            pId: pIds[creditSumPer1.toString()]!,
            tokenFromLocaleStorage: tokenFromLocaleStorage)
        .then((value) {
      setState(() {
        if (value['code'] == -1) {
          scoreCode = Constants.CODE_FAIL;
          scoreMsg = value['msg'].toString();
        } else {
          if (value['code'] == 0) {
            scoreCode = Constants.CODE_SUCCESS;
          } else {
            scoreCode = Constants.CODE_SUCCESS_MSG;
            scoreSuccessMsg = value['msg'];
          }
          scoreMonthly = value['data']['monthly'].toString();
          scoreOverpay = value['data']['overpay'].toString();
          scoreTotalInsSum = value['data']['totalInsSum'].toString();
        }
      });
    });
  }

  Future performSetScoreLimit() async {
    setScoreLimit(
            claimsId: widget.userId,
            pId: pIds[creditSumPer1.toString()]!,
            tokenFromLocaleStorage: tokenFromLocaleStorage)
        .then((value) {
      var snackdemo = SnackBar(
        content: Text(
          '${value['msg']!.toString()}',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              fontFamily: 'Roboto',
              color: Colors.black),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.only(left: 27, right: 27, top: 20, bottom: 20),
        duration: Duration(seconds: 1),
        width: 400,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackdemo);
    });
  }

  Future refreshOrders() async {
    while (tokenFromLocaleStorage == '') {
      loadLocaleStorage();
      await Future.delayed(const Duration(seconds: 1));
    }
    ClientData.load0Orders(widget.userId, tokenFromLocaleStorage);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final media = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
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
                  '5. Оформление ',
                  style: TextStyle(
                      fontSize: 22, fontFamily: 'Roboto', color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 120,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: scoreCode != Constants.CODE_SUCCESS || creditSumPer1 == null
                ? Color.fromRGBO(228, 228, 228, 1)
                : Color.fromRGBO(33, 150, 83, 1)),
        child: TextButton(
          onPressed: () => {
            // performSetScoreLimit(),
            if (scoreCode == Constants.CODE_SUCCESS && creditSumPer1 != null)
              {
                performSetScoreLimit(),
              }
          },
          child: Text(
            'Оформить',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
                color: creditSumPer1 == '6 месяца' || creditSumPer1 == null
                    ? Colors.grey.shade500
                    : Colors.white),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                      Container(
                        padding: const EdgeInsets.only(
                          top: 24,
                          bottom: 13,
                          left: 24,
                          right: 35,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Всего товаров (${ClientData.count})',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(14, 51, 86, 1),
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                  builder: (context) => SostavZakaza(
                                    userId: widget.userId,
                                  ),
                                ))
                                    .then((value) {
                                  // refreshPage();
                                  setState(() {});
                                });
                              },
                              child: Container(
                                height: 35,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {},
                                      child: Container(
                                        child: const Text(
                                          'Перейти к Состав заказа',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w400,
                                            color:
                                                Color.fromRGBO(220, 9, 46, 1),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (creditPer != '6 месяца' &&
                                        creditSumPer1 != null)
                                      Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Color.fromRGBO(220, 9, 46, 1),
                                          size: 15,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const Gap(16),
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Товары: ',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromRGBO(0, 0, 0, 80),
                                        ),
                                      ),
                                      Text(
                                        '${Constants.formatSumm(ClientData.amount)} сум',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromRGBO(0, 0, 0, 70),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(7),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: const [
                                  //     Text(
                                  //       'Доставка: ',
                                  //       style: TextStyle(
                                  //         fontSize: 16,
                                  //         fontFamily: 'Roboto',
                                  //         fontWeight: FontWeight.w400,
                                  //         color: Color.fromRGBO(0, 0, 0, 80),
                                  //       ),
                                  //     ),
                                  //     Text(
                                  //       '0 сум ',
                                  //       style: TextStyle(
                                  //         fontSize: 16,
                                  //         fontFamily: 'Roboto',
                                  //         fontWeight: FontWeight.w400,
                                  //         color: Color.fromRGBO(0, 0, 0, 70),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  const Gap(13),
                                  const Divider(
                                    color: Color.fromRGBO(193, 193, 193, 1),
                                    thickness: 1,
                                  ),
                                  const Gap(13),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Общая сумма товаров:',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w700,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10, right: 150),
                                    child: Text(
                                      '${Constants.formatSumm(ClientData.total)} сум',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w700,
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(40),

                      //--------------------------------------------------------------------

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Color.fromRGBO(244, 244, 244, 1),
                            width: 1,
                          ),
                        ),
                        child: ExpansionPanelList(
                          expansionCallback: (panelIndex, isExpanded) {
                            setState(() {
                              expanded[panelIndex] = !isExpanded;
                            });
                          },
                          animationDuration: Duration(seconds: 1),
                          children: [
                            ExpansionPanel(
                                headerBuilder: (context, isOpen) {
                                  return const Padding(
                                      padding: EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 19,
                                          bottom: 0),
                                      child: Text(
                                        "Показать все товары",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Roboto',
                                            color: Colors.black),
                                      ));
                                },
                                body: Container(
                                  // padding: EdgeInsets.all(20),
                                  color: Colors.white,
                                  width: width * 1,
                                  child: Column(
                                    children: [
                                      const Divider(
                                        color:
                                            Color.fromRGBO(193, 193, 193, 90),
                                        thickness: 1,
                                      ),
                                      Gap(16),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        width: width * 0.99,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 35,
                                              child: const Text(
                                                '#',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromRGBO(
                                                      220, 9, 46, 1),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: width * 0.73,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    // width: 120,
                                                    child: const Text(
                                                      'Наименование товара',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Color.fromRGBO(
                                                            220, 9, 46, 1),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right: 1),
                                                              width:
                                                                  width * 0.15,
                                                              child: Column(
                                                                children: const [
                                                                  Text(
                                                                    'Сумма',
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
                                                                              220,
                                                                              9,
                                                                              46,
                                                                              1),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {},
                                                                child: Transform
                                                                    .rotate(
                                                                  angle: 15,
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .control_point_rounded,
                                                                    size: 30,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Gap(10),
                                      ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: ClientData.products.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            padding: EdgeInsets.only(
                                                left: 16,
                                                right: 16,
                                                top: 0,
                                                bottom: 0),
                                            child: OformlenieZakaza(
                                              productss:
                                                  ClientData.products[index],
                                              price: ClientData
                                                  .products[index].price,
                                              index: index,
                                              userId: widget.userId,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                isExpanded: expanded[0]),
                          ],
                        ),
                      ),
                      Gap(40),
                      Text(
                        'Выберите один из периодов рассрочки',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto'),
                      ),
                      Gap(35),

                      Container(
                        width: width * 1,
                        padding: EdgeInsets.only(right: 15, left: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: creditSumPer1,
                            iconSize: 30,
                            items: creditListElements.map((value) {
                              return new DropdownMenuItem(
                                value: value.toString(),
                                child: new Text(value.toString()),
                              );
                            }).toList(),
                            onChanged: (value) => setState(
                              () {
                                setState(() {
                                  creditSumPer1 = value as String?;
                                });
                                getScoreLimitForMonth();
                              },
                            ),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Color.fromRGBO(0, 0, 0, 70),
                            ),
                            isExpanded: true,
                            hint: const Text(
                              'Период рассрочки (мес)',
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
                      Gap(45),

                      if (scoreCode == Constants.CODE_FAIL)
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromRGBO(253, 239, 239, 1)),
                          padding: EdgeInsets.only(
                              right: 15, left: 15, bottom: 20, top: 20),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error,
                                color: Color.fromRGBO(220, 9, 46, 1),
                                size: 30,
                              ),
                              Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  width: width * 0.8,
                                  child: Text(
                                    scoreMsg!,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ))
                            ],
                          ),
                        ),

                      if (creditSumPer1 == null)
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromRGBO(254, 250, 238, 1)),
                          padding: EdgeInsets.only(
                              right: 15, left: 15, bottom: 20, top: 20),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error,
                                color: Color.fromRGBO(242, 201, 76, 1),
                                size: 30,
                              ),
                              Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  width: width * 0.7,
                                  child: const Text(
                                    'Период рассрочки не \nвыбран',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ))
                            ],
                          ),
                        ),

                      if ((scoreCode == Constants.CODE_SUCCESS ||
                              scoreCode == Constants.CODE_SUCCESS_MSG) &&
                          creditSumPer1 != null)
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Деталь для выбранного \nпериода',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto'),
                              ),
                              Gap(40),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromRGBO(234, 247, 240, 1)),
                                padding: EdgeInsets.only(
                                    right: 15, left: 15, bottom: 20, top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle_outline_outlined,
                                          color: Colors.green,
                                          size: 30,
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                            scoreSuccessMsg!,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Roboto'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          right: 42,
                                          left: 42,
                                          bottom: 0,
                                          top: 32),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Ежемесячная оплата: ',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Roboto'),
                                          ),
                                          Text(
                                            '${Constants.formatSumm(scoreMonthly!)} сум',
                                            textAlign: TextAlign.end,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Roboto'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          right: 42,
                                          left: 42,
                                          bottom: 0,
                                          top: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Общая сумма рассрочки: ',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Roboto'),
                                          ),
                                          Text(
                                            '${Constants.formatSumm(scoreTotalInsSum!)} сум',
                                            textAlign: TextAlign.end,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Roboto'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          right: 42,
                                          left: 42,
                                          bottom: 0,
                                          top: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Переплата: ',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Roboto'),
                                          ),
                                          Text(
                                            '${Constants.formatSumm(scoreOverpay!)} сум',
                                            textAlign: TextAlign.end,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Roboto',
                                                color: Color.fromRGBO(
                                                    235, 87, 87, 1)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Gap(20),
                              Center(
                                  child: Text(
                                'Расчёты произведены на основе данных предоставленных клиентом и могут отличаться от расчётов \n произведённых в банке.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Roboto',
                                    color: Color.fromRGBO(98, 98, 98, 1)),
                              )),
                            ],
                          ),
                        ),
                      Gap(30),
                    ],
                  ),
                ),
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
                      Container(
                        padding: const EdgeInsets.only(
                          top: 24,
                          bottom: 13,
                          left: 24,
                          right: 35,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Всего товаров (${ClientData.count})',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(14, 51, 86, 1),
                                  ),
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => SostavZakaza(
                                        userId: widget.userId,
                                      ),
                                    ))
                                        .then((value) {
                                      // refreshPage();
                                      setState(() {});
                                    });
                                  },
                                  child: Container(
                                    height: 35,
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {},
                                          child: Container(
                                            child: const Text(
                                              'Перейти к Состав заказа',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromRGBO(
                                                    220, 9, 46, 1),
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (creditPer != '6 месяца' &&
                                            creditSumPer1 != null)
                                          Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              color:
                                                  Color.fromRGBO(220, 9, 46, 1),
                                              size: 15,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Gap(16),
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Товары: ',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromRGBO(0, 0, 0, 80),
                                        ),
                                      ),
                                      Text(
                                        '${Constants.formatSumm(ClientData.amount)} сум',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromRGBO(0, 0, 0, 70),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(7),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: const [
                                  //     Text(
                                  //       'Доставка: ',
                                  //       style: TextStyle(
                                  //         fontSize: 16,
                                  //         fontFamily: 'Roboto',
                                  //         fontWeight: FontWeight.w400,
                                  //         color: Color.fromRGBO(0, 0, 0, 80),
                                  //       ),
                                  //     ),
                                  //     Text(
                                  //       '0 сум ',
                                  //       style: TextStyle(
                                  //         fontSize: 16,
                                  //         fontFamily: 'Roboto',
                                  //         fontWeight: FontWeight.w400,
                                  //         color: Color.fromRGBO(0, 0, 0, 70),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  const Gap(13),
                                  const Divider(
                                    color: Color.fromRGBO(193, 193, 193, 1),
                                    thickness: 1,
                                  ),
                                  const Gap(13),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Общая сумма товаров:',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w700,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                        ),
                                      ),
                                      Text(
                                        '${Constants.formatSumm(ClientData.total)} сум',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w700,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(40),

                      //--------------------------------------------------------------------

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Color.fromRGBO(244, 244, 244, 1),
                            width: 1,
                          ),
                        ),
                        child: ExpansionPanelList(
                          expansionCallback: (panelIndex, isExpanded) {
                            setState(() {
                              expanded[panelIndex] = !isExpanded;
                            });
                          },
                          animationDuration: Duration(seconds: 1),
                          children: [
                            ExpansionPanel(
                                headerBuilder: (context, isOpen) {
                                  return const Padding(
                                      padding: EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 19,
                                          bottom: 0),
                                      child: Text(
                                        "Показать все товары",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Roboto',
                                            color: Colors.black),
                                      ));
                                },
                                body: Container(
                                  // padding: EdgeInsets.all(20),
                                  color: Colors.white,
                                  width: width * 1,
                                  child: Column(
                                    children: [
                                      const Divider(
                                        color:
                                            Color.fromRGBO(193, 193, 193, 90),
                                        thickness: 1,
                                      ),
                                      Gap(16),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        width: width * 0.99,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 35,
                                              child: const Text(
                                                '#',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromRGBO(
                                                      220, 9, 46, 1),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: width * 0.83,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    // width: 120,
                                                    child: const Text(
                                                      'Наименование товара',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Color.fromRGBO(
                                                            220, 9, 46, 1),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          14),
                                                              width:
                                                                  width * 0.15,
                                                              child: Column(
                                                                children: const [
                                                                  Text(
                                                                    'Сумма',
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
                                                                              220,
                                                                              9,
                                                                              46,
                                                                              1),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {},
                                                                child: Transform
                                                                    .rotate(
                                                                  angle: 15,
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .control_point_rounded,
                                                                    size: 30,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Gap(10),
                                      ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: ClientData.products.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            padding: EdgeInsets.only(
                                                left: 16,
                                                right: 16,
                                                top: 0,
                                                bottom: 0),
                                            child: OformlenieZakaza(
                                              productss:
                                                  ClientData.products[index],
                                              price: ClientData
                                                  .products[index].price,
                                              index: index,
                                              userId: widget.userId,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                isExpanded: expanded[0]),
                          ],
                        ),
                      ),
                      Gap(40),
                      Text(
                        'Выберите один из периодов рассрочки',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto'),
                      ),
                      Gap(35),

                      Container(
                        width: width * 1,
                        padding: EdgeInsets.only(right: 15, left: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: creditSumPer1,
                            iconSize: 30,
                            items: creditListElements.map((value) {
                              return new DropdownMenuItem(
                                value: value.toString(),
                                child: new Text(value.toString()),
                              );
                            }).toList(),
                            onChanged: (value) => setState(
                              () {
                                setState(() {
                                  creditSumPer1 = value as String?;
                                });
                                getScoreLimitForMonth();
                              },
                            ),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Color.fromRGBO(0, 0, 0, 70),
                            ),
                            isExpanded: true,
                            hint: const Text(
                              'Период рассрочки (мес)',
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
                      Gap(45),

                      if (scoreCode == Constants.CODE_FAIL)
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromRGBO(253, 239, 239, 1)),
                          padding: EdgeInsets.only(
                              right: 15, left: 15, bottom: 20, top: 20),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error,
                                color: Color.fromRGBO(220, 9, 46, 1),
                                size: 30,
                              ),
                              Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  width: width * 0.8,
                                  child: Text(
                                    scoreMsg!,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ))
                            ],
                          ),
                        ),

                      if (creditSumPer1 == null)
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromRGBO(254, 250, 238, 1)),
                          padding: EdgeInsets.only(
                              right: 15, left: 15, bottom: 20, top: 20),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error,
                                color: Color.fromRGBO(242, 201, 76, 1),
                                size: 30,
                              ),
                              Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  width: width * 0.8,
                                  child: const Text(
                                    'Период рассрочки не выбран',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ))
                            ],
                          ),
                        ),

                      if ((scoreCode == Constants.CODE_SUCCESS ||
                              scoreCode == Constants.CODE_SUCCESS_MSG) &&
                          creditSumPer1 != null)
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Деталь для выбранного периода',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto'),
                              ),
                              Gap(40),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromRGBO(234, 247, 240, 1)),
                                padding: EdgeInsets.only(
                                    right: 15, left: 15, bottom: 20, top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle_outline_outlined,
                                          color: Colors.green,
                                          size: 30,
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                            scoreSuccessMsg!,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Roboto'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          right: 42,
                                          left: 42,
                                          bottom: 0,
                                          top: 32),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Ежемесячная оплата: ',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Roboto'),
                                          ),
                                          Text(
                                            '${Constants.formatSumm(scoreMonthly!)} сум',
                                            textAlign: TextAlign.end,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Roboto'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          right: 42,
                                          left: 42,
                                          bottom: 0,
                                          top: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Общая сумма рассрочки: ',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Roboto'),
                                          ),
                                          Text(
                                            '${Constants.formatSumm(scoreTotalInsSum!)} сум',
                                            textAlign: TextAlign.end,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Roboto'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          right: 42,
                                          left: 42,
                                          bottom: 0,
                                          top: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Переплата: ',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Roboto'),
                                          ),
                                          Text(
                                            '${Constants.formatSumm(scoreOverpay!)} сум',
                                            textAlign: TextAlign.end,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Roboto',
                                                color: Color.fromRGBO(
                                                    235, 87, 87, 1)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Gap(20),
                              Center(
                                  child: Text(
                                'Расчёты произведены на основе данных предоставленных клиентом и могут отличаться от расчётов \n произведённых в банке.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Roboto',
                                    color: Color.fromRGBO(98, 98, 98, 1)),
                              )),
                            ],
                          ),
                        ),
                      Gap(30),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

DropdownMenuItem<String> cretitPeriods(item) {
  return DropdownMenuItem(
    value: item,
    child: Text(item),
  );
}
