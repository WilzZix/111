import 'package:MyID/providers/client_data.dart';
import 'package:MyID/utils/constants.dart';
import 'package:MyID/utils/mainGraphQl/servises/product/delete_product.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/mainGraphQl/servises/product/delete_all_products.dart';
import '../../../utils/mainGraphQl/servises/product/get_products.dart';
import 'sostav_zakaza_search.dart';
import "package:intl/intl.dart";
import 'package:flutter_slidable/flutter_slidable.dart';

import 'zakaz_title.dart';

class SostavZakaza extends StatefulWidget {
  static const String routeName = '/sostav_zakaza';
  String userId;
  SostavZakaza({Key? key, required this.userId}) : super(key: key);
  @override
  State<SostavZakaza> createState() => _SostavZakazaState();
}

class _SostavZakazaState extends State<SostavZakaza> {
  var tokenFromLocaleStorage = '';
  loadLocaleStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tokenFromLocaleStorage = prefs.getString('token')!;
    });
  }

  bool showElements = true;

  @override
  void initState() {
    super.initState();
    loadLocaleStorage();

    // fetchProducts();
    if (ClientData.is0OrdersLoading) {
      refreshProducts();
    }
  }

  void fetchProducts() {
    getProducts(
            id: widget.userId, tokenFromLocaleStorage: tokenFromLocaleStorage)
        .then((value) {
      setState(() {
        ClientData.set0OrdersInfo(value);
        ClientData.is0OrdersLoading = false;
      });
    });
  }

  Future refreshProducts() async {
    if (tokenFromLocaleStorage == '') {
      loadLocaleStorage();
      await Future.delayed(const Duration(seconds: 1));
    }
    setState(() {
      ClientData.amount = '0.00';
      ClientData.count = '0';
      ClientData.delivery = '0.00';
      ClientData.total = '0.00';
      ClientData.products = [];
      ClientData.is0OrdersLoading = true;
    });
    fetchProducts();
    return null;
  }

  Future removeOneProduct({String? pId = null}) async {
    if (tokenFromLocaleStorage == '') {
      loadLocaleStorage();
      await Future.delayed(const Duration(seconds: 1));
    }
    deleteProduct1(
            claimsId: widget.userId,
            productId: pId,
            tokenFromLocaleStorage: tokenFromLocaleStorage)
        .then((value) {
      String message = value['msg'].toString();
      print('*** result: $value');

      if (value['code'] == 0) {
        // refreshProducts();
        setState(() {
          ClientData.set0OrdersInfo(value['data']);
          message = 'Товар удален из список покупок';
        });
      }
      var snackdemo = SnackBar(
        content: Text(
          message,
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

  Future removeAllProducts(String id) async {
    if (tokenFromLocaleStorage == '') {
      loadLocaleStorage();
      await Future.delayed(const Duration(seconds: 1));
    }
    deleteAllProduct(
            claimsId: id, tokenFromLocaleStorage: tokenFromLocaleStorage)
        .then((value) {
      String message = value['msg'].toString();
      // products = [];
      print('*** result: $value');
      if (value['code'] == 0) {
        // refreshProducts();
        setState(() {
          ClientData.set0OrdersInfo(value['data']);
          message = 'Все товары удалены из списка покупок';
        });
      }
      var snackdemo = SnackBar(
        content: Text(
          message,
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
                    Navigator.pop(context, true);
                  },
                ),
                Container(
                  child: const Text(
                    'Состав заказа ',
                    style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'Roboto',
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                  builder: (context) =>
                      SostavZakazaSearch(userId: widget.userId),
                ))
                    .then((value) {
                  refreshProducts();
                });
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: refreshProducts,
          child: ClientData.is0OrdersLoading
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Всего товаров (${ClientData.count})',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromRGBO(
                                                    14, 51, 86, 1),
                                              ),
                                            ),
                                            GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              onTap: () {
                                                removeAllProducts(
                                                    widget.userId);
                                              },
                                              child: Container(
                                                height: 30,
                                                child: const Text(
                                                  'Очистить всё',
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
                                          ],
                                        ),
                                        const Gap(16),
                                        Container(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Товары: ',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'Roboto',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 80),
                                                    ),
                                                  ),
                                                  Text(
                                                    '${NumberFormat.currency(locale: 'uz').format(double.parse(ClientData.amount)).replaceAll('UZS', ' ')} сум',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'Roboto',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 70),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Gap(7),
                                              // Row(
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment.spaceBetween,
                                              //   children: [
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
                                              //       '${NumberFormat.currency(locale: 'uz').format(delivery!).replaceAll('UZS', ' ')} сум',
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
                                                color: Color.fromRGBO(
                                                    193, 193, 193, 1),
                                                thickness: 1,
                                              ),
                                              const Gap(13),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Общая сумма товаров:',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontFamily: 'Roboto',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 10, right: 130),
                                                child: Text(
                                                  '${NumberFormat.currency(locale: 'uz').format(double.parse(ClientData.total)).replaceAll('UZS', ' ')} сум',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.w700,
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 1),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Gap(52),
                                  if (ClientData.products.length != 0)
                                    ZakazTitle(),
                                  Gap(10),
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: ClientData.products.length,
                                    itemBuilder: (context, index) {
                                      final item = ClientData.products[index];
                                      return Slidable(
                                        // direction: DismissDirection.startToEnd,
                                        key: UniqueKey(),
                                        // onDismissed: (direction) {
                                        //   // Removes that item the list on swipwe
                                        //   setState(() {
                                        //     removeOneProduct(
                                        //         pId: ClientData.products[index].id);
                                        //     // ClientData.products.removeAt(index);

                                        //     ClientData.products.removeAt(index);
                                        //   });
                                        // },

                                        endActionPane: ActionPane(
                                          // dismissible: DismissiblePane(onDismissed: () {
                                          //   removeOneProduct(
                                          //       pId: ClientData.products[index].id);
                                          //   // ClientData.products.removeAt(index);
                                          // }),
                                          extentRatio: 0.25,
                                          motion: ScrollMotion(),

                                          children: [
                                            SlidableAction(
                                              onPressed: (context) => {
                                                removeOneProduct(
                                                    pId: ClientData
                                                        .products[index].id)
                                              },
                                              backgroundColor:
                                                  Color(0xFFFE4A49),
                                              foregroundColor: Colors.white,
                                              icon: Icons.delete,
                                              label: 'Удалить',
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                          ],
                                        ),

                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                // height: 60,
                                                padding: const EdgeInsets.only(
                                                    top: 15),
                                                width: width * 0.90,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.white,
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width: 35,
                                                          child: Text(
                                                            '${index + 1}',
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Color
                                                                  .fromRGBO(0,
                                                                      0, 0, 1),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: width * 0.80,
                                                          // color: Colors.red,
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              if (showElements ==
                                                                  true)
                                                                Column(
                                                                  children: [
                                                                    Container(
                                                                      width: width *
                                                                          0.40,
                                                                      child:
                                                                          Text(
                                                                        '${ClientData.products[index].name}',
                                                                        style:
                                                                            const TextStyle(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          color: Color.fromRGBO(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              1),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Container(
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Container(
                                                                          margin:
                                                                              EdgeInsets.only(right: 10),
                                                                          // width:
                                                                          //     width * 0.22,
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.end,
                                                                            children: [
                                                                              Text(
                                                                                '${Constants.formatSumm(ClientData.products[index].price!)}',
                                                                                style: const TextStyle(
                                                                                  fontFamily: 'Roboto',
                                                                                  fontSize: 20,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  color: Color.fromRGBO(0, 0, 0, 1),
                                                                                ),
                                                                                textAlign: TextAlign.end,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            // Container(
                                                                            //   margin: EdgeInsets.only(
                                                                            //       left:
                                                                            //           14),
                                                                            //   child:
                                                                            //       GestureDetector(
                                                                            //     onTap:
                                                                            //         () {
                                                                            //       setState(
                                                                            //           () {
                                                                            //         removeOneProduct(pId: ClientData.products[index].id);
                                                                            //       });
                                                                            //     },
                                                                            //     child: Transform
                                                                            //         .rotate(
                                                                            //       angle:
                                                                            //           15,
                                                                            //       child:
                                                                            //           const Icon(
                                                                            //         Icons.control_point_rounded,
                                                                            //         size:
                                                                            //             30,
                                                                            //         color: Color.fromRGBO(
                                                                            //             0,
                                                                            //             0,
                                                                            //             0,
                                                                            //             90),
                                                                            //       ),
                                                                            //     ),
                                                                            //   ),
                                                                            // ),
                                                                          ],
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
                                                    Gap(30),
                                                    // Container(
                                                    //   padding: EdgeInsets.all(0),
                                                    //   margin: EdgeInsets.all(0),
                                                    //   child: Divider(
                                                    //     color: Color.fromRGBO(
                                                    //         193, 193, 193, 1),
                                                    //     thickness: 1,
                                                    //   ),
                                                    // ),

                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      margin: EdgeInsets.all(0),
                                                      height: 1,
                                                      color: Color.fromRGBO(
                                                          193, 193, 193, 0.5),

                                                      // child: Divider(
                                                      //   color: Color.fromRGBO(
                                                      //       193, 193, 193, 1),
                                                      //   thickness: 1,
                                                      // ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ]),
                                      );
                                    },
                                  ),
                                  if (ClientData.products.length == 0)
                                    Center(
                                      child: Column(
                                        children: [
                                          const Gap(133),
                                          const Icon(
                                              Icons.shopping_cart_outlined,
                                              size: 150,
                                              color: Color.fromRGBO(
                                                  215, 215, 215, 1)),
                                          Gap(47),
                                          const Text(
                                            'Список товаров пуст, добавьте товары в корзину',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromRGBO(
                                                    73, 69, 79, 1)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Gap(34),
                                  Center(
                                    child: Container(
                                      width: 281,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Color.fromRGBO(103, 80, 164, 1),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                SostavZakazaSearch(
                                              userId: widget.userId,
                                            ),
                                          ))
                                              .then((value) {
                                            refreshProducts();
                                          });
                                        },
                                        child: const Text(
                                          'Добавить товары',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Gap(34),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Всего товаров (${ClientData.count})',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromRGBO(
                                                    14, 51, 86, 1),
                                              ),
                                            ),
                                            GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              onTap: () {
                                                removeAllProducts(
                                                    widget.userId);
                                              },
                                              child: Container(
                                                height: 30,
                                                child: const Text(
                                                  'Очистить всё',
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
                                          ],
                                        ),
                                        const Gap(16),
                                        Container(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Товары: ',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'Roboto',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 80),
                                                    ),
                                                  ),
                                                  Text(
                                                    '${NumberFormat.currency(locale: 'uz').format(double.parse(ClientData.amount)).replaceAll('UZS', ' ')} сум',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'Roboto',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 70),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Gap(7),
                                              // Row(
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment.spaceBetween,
                                              //   children: [
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
                                              //       '${NumberFormat.currency(locale: 'uz').format(delivery!).replaceAll('UZS', ' ')} сум',
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
                                                color: Color.fromRGBO(
                                                    193, 193, 193, 1),
                                                thickness: 1,
                                              ),
                                              const Gap(13),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Общая сумма товаров:',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontFamily: 'Roboto',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                    ),
                                                  ),
                                                  Text(
                                                    '${NumberFormat.currency(locale: 'uz').format(double.parse(ClientData.total)).replaceAll('UZS', ' ')} сум',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontFamily: 'Roboto',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
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
                                  const Gap(52),
                                  if (ClientData.products.length != 0)
                                    ZakazTitle(),
                                  Gap(10),
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: ClientData.products.length,
                                    itemBuilder: (context, index) {
                                      final item = ClientData.products[index];
                                      return Slidable(
                                        // direction: DismissDirection.startToEnd,
                                        key: UniqueKey(),
                                        // onDismissed: (direction) {
                                        //   // Removes that item the list on swipwe
                                        //   setState(() {
                                        //     removeOneProduct(
                                        //         pId: ClientData.products[index].id);
                                        //     // ClientData.products.removeAt(index);

                                        //     ClientData.products.removeAt(index);
                                        //   });
                                        // },

                                        endActionPane: ActionPane(
                                          // dismissible: DismissiblePane(onDismissed: () {
                                          //   removeOneProduct(
                                          //       pId: ClientData.products[index].id);
                                          //   // ClientData.products.removeAt(index);
                                          // }),
                                          extentRatio: 0.25,
                                          motion: ScrollMotion(),

                                          children: [
                                            SlidableAction(
                                              onPressed: (context) => {
                                                removeOneProduct(
                                                    pId: ClientData
                                                        .products[index].id)
                                              },
                                              backgroundColor:
                                                  Color(0xFFFE4A49),
                                              foregroundColor: Colors.white,
                                              icon: Icons.delete,
                                              label: 'Удалить',
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                          ],
                                        ),

                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                // height: 60,
                                                padding: const EdgeInsets.only(
                                                    top: 15),
                                                width: width * 0.96,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.white,
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width: 35,
                                                          child: Text(
                                                            '${index + 1}',
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Color
                                                                  .fromRGBO(0,
                                                                      0, 0, 1),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: width * 0.90,
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              if (showElements ==
                                                                  true)
                                                                Column(
                                                                  children: [
                                                                    Container(
                                                                      width: width *
                                                                          0.58,
                                                                      child:
                                                                          Text(
                                                                        '${ClientData.products[index].name}',
                                                                        style:
                                                                            const TextStyle(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          color: Color.fromRGBO(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              1),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Container(
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Container(
                                                                          margin:
                                                                              EdgeInsets.only(right: 10),
                                                                          width:
                                                                              width * 0.22,
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.end,
                                                                            children: [
                                                                              Text(
                                                                                '${Constants.formatSumm(ClientData.products[index].price!)}',
                                                                                style: const TextStyle(
                                                                                  fontFamily: 'Roboto',
                                                                                  fontSize: 20,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  color: Color.fromRGBO(0, 0, 0, 1),
                                                                                ),
                                                                                textAlign: TextAlign.end,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            // Container(
                                                                            //   margin: EdgeInsets.only(
                                                                            //       left:
                                                                            //           14),
                                                                            //   child:
                                                                            //       GestureDetector(
                                                                            //     onTap:
                                                                            //         () {
                                                                            //       setState(
                                                                            //           () {
                                                                            //         removeOneProduct(pId: ClientData.products[index].id);
                                                                            //       });
                                                                            //     },
                                                                            //     child: Transform
                                                                            //         .rotate(
                                                                            //       angle:
                                                                            //           15,
                                                                            //       child:
                                                                            //           const Icon(
                                                                            //         Icons.control_point_rounded,
                                                                            //         size:
                                                                            //             30,
                                                                            //         color: Color.fromRGBO(
                                                                            //             0,
                                                                            //             0,
                                                                            //             0,
                                                                            //             90),
                                                                            //       ),
                                                                            //     ),
                                                                            //   ),
                                                                            // ),
                                                                          ],
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
                                                    Gap(30),
                                                    // Container(
                                                    //   padding: EdgeInsets.all(0),
                                                    //   margin: EdgeInsets.all(0),
                                                    //   child: Divider(
                                                    //     color: Color.fromRGBO(
                                                    //         193, 193, 193, 1),
                                                    //     thickness: 1,
                                                    //   ),
                                                    // ),

                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      margin: EdgeInsets.all(0),
                                                      height: 1,
                                                      color: Color.fromRGBO(
                                                          193, 193, 193, 0.5),

                                                      // child: Divider(
                                                      //   color: Color.fromRGBO(
                                                      //       193, 193, 193, 1),
                                                      //   thickness: 1,
                                                      // ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ]),
                                      );
                                    },
                                  ),
                                  if (ClientData.products.length == 0)
                                    Center(
                                      child: Column(
                                        children: [
                                          const Gap(133),
                                          const Icon(
                                              Icons.shopping_cart_outlined,
                                              size: 150,
                                              color: Color.fromRGBO(
                                                  215, 215, 215, 1)),
                                          Gap(47),
                                          const Text(
                                            'Список товаров пуст, добавьте товары в корзину',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromRGBO(
                                                    73, 69, 79, 1)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Gap(34),
                                  Center(
                                    child: Container(
                                      width: 281,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Color.fromRGBO(103, 80, 164, 1),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                SostavZakazaSearch(
                                              userId: widget.userId,
                                            ),
                                          ))
                                              .then((value) {
                                            refreshProducts();
                                          });
                                        },
                                        child: const Text(
                                          'Добавить товары',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Gap(34),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
        ),
      ),
    );
  }
}
