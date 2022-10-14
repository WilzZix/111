import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../info_pages.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';

class Grafic8 extends StatefulWidget {
  static const String routeName = '/Grafic8';

  final String? userId;
  final String? monthly;
  final String? overpay;
  final String? period;
  final String? productTotal;
  final String? reportUrl;
  final String? total;

  Grafic8({
    Key? key,
    required this.userId,
    required this.monthly,
    required this.overpay,
    required this.period,
    required this.productTotal,
    required this.reportUrl,
    required this.total,
  }) : super(key: key);

  @override
  State<Grafic8> createState() => _SostavZakazaState();
}

class _SostavZakazaState extends State<Grafic8> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final media = MediaQuery.of(context);

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 1));
        setState(() {
          // userInfo = null;
          // refreshPage();
        });

        return null;
      },
      child: WillPopScope(
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
                    },
                  ),
                  Container(
                    child: const Text(
                      '8. График',
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                  'Результаты расчета',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Roboto',
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                  ),
                                ),
                                Container(
                                  width: width * 1,
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Gap(41),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 220,
                                            child: const Text(
                                              'Сумма товара',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Roboto',
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 90),
                                              ),
                                            ),
                                          ),
                                          const Text(
                                            'Сумма рассрочки',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Roboto',
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 90),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Gap(12),
                                      Row(
                                        children: [
                                          Container(
                                            width: 220,
                                            child: Text(
                                              // '100 000 000,00 Сум',
                                              // '${widget.productTotal} Сум',
                                              '${widget.productTotal != 'null' ? NumberFormat.currency(locale: 'uz').format(double.parse(widget.productTotal.toString())).replaceAll('UZS', ' ') : '0'} Сум',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Roboto',
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            // '13 000 000,00 Сум',
                                            // '${widget.total} Сум',
                                            '${widget.total != 'null' ? NumberFormat.currency(locale: 'uz').format(double.parse(widget.total.toString())).replaceAll('UZS', ' ') : '0'} Сум',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto',
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Gap(41),
                                      Row(
                                        children: [
                                          Container(
                                            width: 220,
                                            child: const Text(
                                              'Разница',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Roboto',
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 90),
                                              ),
                                            ),
                                          ),
                                          const Text(
                                            'Общая задолженность',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Roboto',
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 90),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Gap(12),
                                      Row(
                                        children: [
                                          Container(
                                            width: 220,
                                            child: Text(
                                              // '3 000 000,00 Сум',
                                              // '${widget.overpay} Сум',
                                              '${widget.overpay != 'null' ? NumberFormat.currency(locale: 'uz').format(double.parse(widget.overpay.toString())).replaceAll('UZS', ' ') : '0'} Сум',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Roboto',
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            // '13 000 000,00 Сум',
                                            // '${widget.total} Сум',
                                            '${widget.total != 'null' ? NumberFormat.currency(locale: 'uz').format(double.parse(widget.total.toString())).replaceAll('UZS', ' ') : '0'} Сум',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto',
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Gap(41),
                                      Row(
                                        children: [
                                          Container(
                                            width: 220,
                                            child: const Text(
                                              'Период рассрочки',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Roboto',
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 90),
                                              ),
                                            ),
                                          ),
                                          const Text(
                                            'Ежемесячная оплата',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Roboto',
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 90),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Gap(12),
                                      Row(
                                        children: [
                                          if (widget.period != 'null'
                                              ? widget.period == '1'
                                              : false)
                                            Container(
                                              width: 220,
                                              child: Text(
                                                // '4 месяца',
                                                '${widget.period} Месяц',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Roboto',
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                ),
                                              ),
                                            ),
                                          if (widget.period == '2')
                                            Container(
                                              width: 220,
                                              child: Text(
                                                // '4 месяца',
                                                '${widget.period} Месяца',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Roboto',
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                ),
                                              ),
                                            ),
                                          if (widget.period == '3')
                                            Container(
                                              width: 220,
                                              child: Text(
                                                // '4 месяца',
                                                '${widget.period} Месяца',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Roboto',
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                ),
                                              ),
                                            ),
                                          if (widget.period == '4')
                                            Container(
                                              width: 220,
                                              child: Text(
                                                // '4 месяца',
                                                '${widget.period} Месяца',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Roboto',
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                ),
                                              ),
                                            ),
                                          if (int.parse(widget.period!) >=
                                              int.parse('5'))
                                            Container(
                                              width: 220,
                                              child: Text(
                                                // '4 месяца',
                                                '${widget.period} Месяцев',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Roboto',
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                ),
                                              ),
                                            ),
                                          Text(
                                            // '3 250 000,00 Сум',
                                            // '${widget.monthly} Сум',
                                            '${widget.monthly != 'null' ? NumberFormat.currency(locale: 'uz').format(double.parse(widget.monthly.toString())).replaceAll('UZS', ' ') : '0'} Сум',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto',
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Gap(70),
                                      Center(
                                        child: QrImage(
                                          data: "${widget.reportUrl}",
                                          version: QrVersions.auto,
                                          size: 250.0,
                                        ),
                                      ),
                                      Gap(26),
                                      Center(
                                        child: Text(
                                          'Для скачивания детальный график оплаты отсканируйте QR код',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Roboto',
                                            color: Color.fromRGBO(0, 0, 0, 90),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Gap(50),
                          // Center(
                          //   child: Text(
                          //     'Данные будут доступны после оформления рассрочки',
                          //     style: const TextStyle(
                          //       fontSize: 20,
                          //       fontWeight: FontWeight.w400,
                          //       fontFamily: 'Roboto',
                          //       color: Color.fromRGBO(0, 0, 0, 90),
                          //     ),
                          //   ),
                          // ),
                          Gap(23),
                          Center(
                            child: Container(
                              width: 245,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color.fromRGBO(103, 80, 164, 1),
                              ),
                              child: TextButton(
                                onPressed: () => {
                                  // Navigator.of(context).pushNamed(InfoPage.routeName),
                                  Navigator.pop(context, true)
                                },
                                child: Text(
                                  'Вернуться на главную',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    // Container(
                    //   child: Column(
                    //     children: [
                    //       Gap(50),
                    //       Center(
                    //         child: Text(
                    //           'Данные будут доступны после оформления рассрочки',
                    //           style: const TextStyle(
                    //             fontSize: 20,
                    //             fontWeight: FontWeight.w400,
                    //             fontFamily: 'Roboto',
                    //             color: Color.fromRGBO(0, 0, 0, 90),
                    //           ),
                    //         ),
                    //       ),
                    //       Gap(23),
                    //       Center(
                    //         child: Container(
                    //           width: 245,
                    //           height: 40,
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(50),
                    //             color: Color.fromRGBO(103, 80, 164, 1),
                    //           ),
                    //           child: TextButton(
                    //             onPressed: () => {
                    //               // Navigator.of(context)
                    //               //     .pushNamed(InfoPage.routeName),
                    //               Navigator.pop(context, true)
                    //             },
                    //             child: Text(
                    //               'Вернуться на главную',
                    //               style: const TextStyle(
                    //                 fontSize: 14,
                    //                 fontWeight: FontWeight.w500,
                    //                 fontFamily: 'Roboto',
                    //                 color: Colors.white,
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // )
                  ],
                )
              : ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                  'Результаты расчета',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Roboto',
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                  ),
                                ),
                                Container(
                                  width: width * 1,
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Gap(41),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 300,
                                            child: const Text(
                                              'Сумма товара',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Roboto',
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 90),
                                              ),
                                            ),
                                          ),
                                          const Text(
                                            'Сумма рассрочки',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Roboto',
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 90),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Gap(12),
                                      Row(
                                        children: [
                                          Container(
                                            width: 300,
                                            child: Text(
                                              // '100 000 000,00 Сум',
                                              // '${widget.productTotal} Сум',
                                              '${widget.productTotal != 'null' ? NumberFormat.currency(locale: 'uz').format(double.parse(widget.productTotal.toString())).replaceAll('UZS', ' ') : '0'} Сум',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Roboto',
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            // '13 000 000,00 Сум',
                                            // '${widget.total} Сум',
                                            '${widget.total != 'null' ? NumberFormat.currency(locale: 'uz').format(double.parse(widget.total.toString())).replaceAll('UZS', ' ') : '0'} Сум',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto',
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Gap(41),
                                      Row(
                                        children: [
                                          Container(
                                            width: 300,
                                            child: const Text(
                                              'Разница',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Roboto',
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 90),
                                              ),
                                            ),
                                          ),
                                          const Text(
                                            'Общая задолженность',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Roboto',
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 90),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Gap(12),
                                      Row(
                                        children: [
                                          Container(
                                            width: 300,
                                            child: Text(
                                              // '3 000 000,00 Сум',
                                              // '${widget.overpay} Сум',
                                              '${widget.overpay != 'null' ? NumberFormat.currency(locale: 'uz').format(double.parse(widget.overpay.toString())).replaceAll('UZS', ' ') : '0'} Сум',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Roboto',
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            // '13 000 000,00 Сум',
                                            // '${widget.total} Сум',
                                            '${widget.total != 'null' ? NumberFormat.currency(locale: 'uz').format(double.parse(widget.total.toString())).replaceAll('UZS', ' ') : '0'} Сум',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto',
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Gap(41),
                                      Row(
                                        children: [
                                          Container(
                                            width: 300,
                                            child: const Text(
                                              'Период рассрочки',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Roboto',
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 90),
                                              ),
                                            ),
                                          ),
                                          const Text(
                                            'Ежемесячная оплата',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Roboto',
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 90),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Gap(12),
                                      Row(
                                        children: [
                                          if (widget.period != 'null'
                                              ? widget.period == '1'
                                              : false)
                                            Container(
                                              width: 300,
                                              child: Text(
                                                // '4 месяца',
                                                '${widget.period} Месяц',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Roboto',
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                ),
                                              ),
                                            ),
                                          if (widget.period == '2')
                                            Container(
                                              width: 300,
                                              child: Text(
                                                // '4 месяца',
                                                '${widget.period} Месяца',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Roboto',
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                ),
                                              ),
                                            ),
                                          if (widget.period == '3')
                                            Container(
                                              width: 300,
                                              child: Text(
                                                // '4 месяца',
                                                '${widget.period} Месяца',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Roboto',
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                ),
                                              ),
                                            ),
                                          if (widget.period == '4')
                                            Container(
                                              width: 300,
                                              child: Text(
                                                // '4 месяца',
                                                '${widget.period} Месяца',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Roboto',
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                ),
                                              ),
                                            ),
                                          if (int.parse(widget.period!) >=
                                              int.parse('5'))
                                            Container(
                                              width: 300,
                                              child: Text(
                                                // '4 месяца',
                                                '${widget.period} Месяцев',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Roboto',
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                ),
                                              ),
                                            ),
                                          Text(
                                            // '3 250 000,00 Сум',
                                            // '${widget.monthly} Сум',
                                            '${widget.monthly != 'null' ? NumberFormat.currency(locale: 'uz').format(double.parse(widget.monthly.toString())).replaceAll('UZS', ' ') : '0'} Сум',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto',
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Gap(70),
                                      Center(
                                        child: QrImage(
                                          data: "${widget.reportUrl}",
                                          version: QrVersions.auto,
                                          size: 250.0,
                                        ),
                                      ),
                                      Gap(26),
                                      Center(
                                        child: Text(
                                          'Для скачивания детальный график оплаты отсканируйте QR код',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Roboto',
                                            color: Color.fromRGBO(0, 0, 0, 90),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Gap(50),
                          // Center(
                          //   child: Text(
                          //     'Данные будут доступны после оформления рассрочки',
                          //     style: const TextStyle(
                          //       fontSize: 20,
                          //       fontWeight: FontWeight.w400,
                          //       fontFamily: 'Roboto',
                          //       color: Color.fromRGBO(0, 0, 0, 90),
                          //     ),
                          //   ),
                          // ),
                          Gap(23),
                          Center(
                            child: Container(
                              width: 245,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color.fromRGBO(103, 80, 164, 1),
                              ),
                              child: TextButton(
                                onPressed: () => {
                                  // Navigator.of(context).pushNamed(InfoPage.routeName),
                                  Navigator.pop(context, true)
                                },
                                child: Text(
                                  'Вернуться на главную',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    // Container(
                    //   child: Column(
                    //     children: [
                    //       Gap(50),
                    //       Center(
                    //         child: Text(
                    //           'Данные будут доступны после оформления рассрочки',
                    //           style: const TextStyle(
                    //             fontSize: 20,
                    //             fontWeight: FontWeight.w400,
                    //             fontFamily: 'Roboto',
                    //             color: Color.fromRGBO(0, 0, 0, 90),
                    //           ),
                    //         ),
                    //       ),
                    //       Gap(23),
                    //       Center(
                    //         child: Container(
                    //           width: 245,
                    //           height: 40,
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(50),
                    //             color: Color.fromRGBO(103, 80, 164, 1),
                    //           ),
                    //           child: TextButton(
                    //             onPressed: () => {
                    //               // Navigator.of(context)
                    //               //     .pushNamed(InfoPage.routeName),
                    //               Navigator.pop(context, true)
                    //             },
                    //             child: Text(
                    //               'Вернуться на главную',
                    //               style: const TextStyle(
                    //                 fontSize: 14,
                    //                 fontWeight: FontWeight.w500,
                    //                 fontFamily: 'Roboto',
                    //                 color: Colors.white,
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // )
                  ],
                ),
        ),
      ),
    );
  }
}
