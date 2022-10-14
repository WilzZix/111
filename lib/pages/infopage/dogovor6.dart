import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../utils/mainGraphQl/servises/get_oferta.dart';
import '../../utils/mainGraphQl/servises/set_oferta_decision.dart';

class Dogovor6 extends StatefulWidget {
  static const String routeName = '/Dogovor6';
  final String userId;
  Dogovor6({Key? key, required this.userId}) : super(key: key);

  @override
  State<Dogovor6> createState() => _SostavZakazaState();
}

class _SostavZakazaState extends State<Dogovor6> {
  bool? isCheckbox = false;
  bool checkBoxEnabled = false;
  var tokenFromLocaleStorage = '';
  final _controller = ScrollController();
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
    refreshOferta();
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        setState(() {
          checkBoxEnabled = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  var ofertaLIst;
  String setYES = 'YES';
  String setNO = 'NO';

  Future refreshOferta() async {
    if (tokenFromLocaleStorage == '') {
      loadLocaleStorage();
      await Future.delayed(const Duration(seconds: 1));
    }
    getOfertaQuery(tokenFromLocaleStorage: tokenFromLocaleStorage)
        .then((value) {
      setState(() {
        ofertaLIst = jsonDecode(value['data']);
      });
    });
  }

  decisionOferta(String desicion) {
    setOfertaDecisions(
            decision: desicion,
            claimsId: widget.userId,
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
                  '6. Договор ',
                  style: TextStyle(
                      fontSize: 22, fontFamily: 'Roboto', color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
      body: media.size.width < 440
          ? ListView(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Column(
                  children: [
                    Container(
                      height: height - 250,
                      child: ListView(
                        shrinkWrap: true,
                        controller: _controller,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: Container(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Gap(20),
                                      Container(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Color.fromRGBO(
                                                    244, 244, 244, 1),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Color.fromRGBO(
                                                  250, 250, 250, 1)),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 20,
                                          ),
                                          child: Container(
                                            // height: 600,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.vertical,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ofertaLIst == null
                                                      ? Center(
                                                          child:
                                                              const CircularProgressIndicator(
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                    Color>(
                                                              Colors.blue,
                                                            ),
                                                          ),
                                                        )
                                                      : Container(
                                                          // height: 600,
                                                          child:
                                                              ListView.builder(
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemCount: ofertaLIst[
                                                                    'dogovor']!
                                                                .length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int ind) {
                                                              return Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    '${ofertaLIst['dogovor']![ind]['title']}',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              1),
                                                                    ),
                                                                  ),
                                                                  Gap(30),
                                                                  Container(
                                                                    // height: 600,
                                                                    child: ListView
                                                                        .builder(
                                                                      physics:
                                                                          const NeverScrollableScrollPhysics(),
                                                                      shrinkWrap:
                                                                          true,
                                                                      itemCount:
                                                                          ofertaLIst['dogovor']![ind]['contentsLevel2']
                                                                              .length,
                                                                      itemBuilder:
                                                                          (BuildContext context,
                                                                              int inde) {
                                                                        return Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Gap(15),
                                                                            RichText(
                                                                              text: TextSpan(
                                                                                children: <TextSpan>[
                                                                                  TextSpan(
                                                                                    text: '${ofertaLIst['dogovor']![ind]['contentsLevel2'][inde]['title'].replaceAll('null', ' ')}',
                                                                                    style: TextStyle(
                                                                                      fontSize: 16,
                                                                                      fontWeight: FontWeight.w700,
                                                                                      fontFamily: 'Roboto',
                                                                                      color: Color.fromRGBO(0, 0, 0, 1),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Gap(15),
                                                                            Container(
                                                                              // height: 600,
                                                                              child: ListView.builder(
                                                                                physics: const NeverScrollableScrollPhysics(),
                                                                                shrinkWrap: true,
                                                                                itemCount: ofertaLIst['dogovor']![ind]['contentsLevel2'][inde]['contentsLevel3'].length,
                                                                                itemBuilder: (BuildContext context, int index) {
                                                                                  // print(
                                                                                  //     '--------------- ${ofertaLIst['dogovor'][ind]['contentsLevel2'][inde]['contentsLevel3'][index]}');
                                                                                  return Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Gap(5),
                                                                                      RichText(
                                                                                        text: TextSpan(
                                                                                          children: <TextSpan>[
                                                                                            TextSpan(
                                                                                              text: '${ofertaLIst['dogovor']![ind]['contentsLevel2'][inde]['contentsLevel3'][index]['title'] ?? ''}',
                                                                                              style: TextStyle(
                                                                                                fontSize: 16,
                                                                                                fontWeight: FontWeight.w600,
                                                                                                fontFamily: 'Roboto',
                                                                                                color: Color.fromRGBO(0, 0, 0, 1),
                                                                                              ),
                                                                                            ),
                                                                                            TextSpan(
                                                                                              text: '${ofertaLIst['dogovor']![ind]['contentsLevel2'][inde]['contentsLevel3'][index]['subTitle'] ?? ''}',
                                                                                              style: TextStyle(
                                                                                                fontSize: 16,
                                                                                                fontWeight: FontWeight.w400,
                                                                                                fontFamily: 'Roboto',
                                                                                                color: Color.fromRGBO(0, 0, 0, 1),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Gap(5),
                                                                                    ],
                                                                                  );
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                  Gap(40),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 13, left: 10, right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: isCheckbox,
                              onChanged: (checkBoxEnabled == true)
                                  ? (bool? newBool) {
                                      setState(() {
                                        isCheckbox = newBool;
                                      });
                                    }
                                  : null,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 15),
                              // height: 90,
                              child: const Text(
                                'Я прочитал(а) и принимаю условия \nПользовательского соглашения и \nПолитики   конфиденциальности \nперсональных данных.',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Roboto',
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // -------------------------------------
                    Gap(50),
                    Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 40,
                            width: 165,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              color: Colors.white,
                              border: Border.all(
                                color: Color.fromRGBO(220, 9, 46, 1),
                                width: 1,
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                decisionOferta(setNO);
                              },
                              child: Text(
                                'Отклонить',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(220, 9, 46, 1),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15),
                            height: 40,
                            width: 165,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              color: isCheckbox == false
                                  ? Color.fromRGBO(31, 31, 31, 0.12)
                                  : Color.fromRGBO(33, 150, 83, 1),
                            ),
                            child: TextButton(
                              onPressed: () {
                                if (isCheckbox == true) {
                                  decisionOferta(setYES);
                                }
                              },
                              child: Text(
                                'Подтвердить',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: isCheckbox == false
                                      ? Color.fromRGBO(152, 151, 153, 1)
                                      : Colors.white,
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
            )
          : Column(
              children: [
                Container(
                  height: height - 250,
                  child: ListView(
                    shrinkWrap: true,
                    controller: _controller,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Container(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Gap(20),
                                  Container(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color.fromRGBO(
                                                244, 244, 244, 1),
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color:
                                              Color.fromRGBO(250, 250, 250, 1)),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 20,
                                      ),
                                      child: Container(
                                        // height: 600,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ofertaLIst == null
                                                  ? Center(
                                                      child:
                                                          const CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                Color>(
                                                          Colors.blue,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      // height: 600,
                                                      child: ListView.builder(
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount: ofertaLIst[
                                                                'dogovor']!
                                                            .length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int ind) {
                                                          return Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                '${ofertaLIst['dogovor']![ind]['title']}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          1),
                                                                ),
                                                              ),
                                                              Gap(30),
                                                              Container(
                                                                // height: 600,
                                                                child: ListView
                                                                    .builder(
                                                                  physics:
                                                                      const NeverScrollableScrollPhysics(),
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount: ofertaLIst['dogovor']![
                                                                              ind]
                                                                          [
                                                                          'contentsLevel2']
                                                                      .length,
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int inde) {
                                                                    return Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Gap(15),
                                                                        RichText(
                                                                          text:
                                                                              TextSpan(
                                                                            children: <TextSpan>[
                                                                              TextSpan(
                                                                                text: '${ofertaLIst['dogovor']![ind]['contentsLevel2'][inde]['title'].replaceAll('null', ' ')}',
                                                                                style: TextStyle(
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.w700,
                                                                                  fontFamily: 'Roboto',
                                                                                  color: Color.fromRGBO(0, 0, 0, 1),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Gap(15),
                                                                        Container(
                                                                          // height: 600,
                                                                          child:
                                                                              ListView.builder(
                                                                            physics:
                                                                                const NeverScrollableScrollPhysics(),
                                                                            shrinkWrap:
                                                                                true,
                                                                            itemCount:
                                                                                ofertaLIst['dogovor']![ind]['contentsLevel2'][inde]['contentsLevel3'].length,
                                                                            itemBuilder:
                                                                                (BuildContext context, int index) {
                                                                              // print(
                                                                              //     '--------------- ${ofertaLIst['dogovor'][ind]['contentsLevel2'][inde]['contentsLevel3'][index]}');
                                                                              return Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Gap(5),
                                                                                  RichText(
                                                                                    text: TextSpan(
                                                                                      children: <TextSpan>[
                                                                                        TextSpan(
                                                                                          text: '${ofertaLIst['dogovor']![ind]['contentsLevel2'][inde]['contentsLevel3'][index]['title'] ?? ''}',
                                                                                          style: TextStyle(
                                                                                            fontSize: 16,
                                                                                            fontWeight: FontWeight.w600,
                                                                                            fontFamily: 'Roboto',
                                                                                            color: Color.fromRGBO(0, 0, 0, 1),
                                                                                          ),
                                                                                        ),
                                                                                        TextSpan(
                                                                                          text: '${ofertaLIst['dogovor']![ind]['contentsLevel2'][inde]['contentsLevel3'][index]['subTitle'] ?? ''}',
                                                                                          style: TextStyle(
                                                                                            fontSize: 16,
                                                                                            fontWeight: FontWeight.w400,
                                                                                            fontFamily: 'Roboto',
                                                                                            color: Color.fromRGBO(0, 0, 0, 1),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  Gap(5),
                                                                                ],
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                              Gap(40),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                Center(
                  child: Container(
                    padding: EdgeInsets.only(top: 13, left: 10, right: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: isCheckbox,
                          onChanged: (checkBoxEnabled == true)
                              ? (bool? newBool) {
                                  setState(() {
                                    isCheckbox = newBool;
                                  });
                                }
                              : null,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child: const Text(
                            'Я прочитал(а) и принимаю условия Пользовательского соглашения и Политики  \n конфиденциальности персональных данных.',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Roboto',
                              color: Color.fromRGBO(0, 0, 0, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // -------------------------------------
                Gap(50),
                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 40,
                        width: 245,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.white,
                          border: Border.all(
                            color: Color.fromRGBO(220, 9, 46, 1),
                            width: 1,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            decisionOferta(setNO);
                          },
                          child: Text(
                            'Отклонить',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(220, 9, 46, 1),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        height: 40,
                        width: 245,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: isCheckbox == false
                              ? Color.fromRGBO(31, 31, 31, 0.12)
                              : Color.fromRGBO(33, 150, 83, 1),
                        ),
                        child: TextButton(
                          onPressed: () {
                            if (isCheckbox == true) {
                              decisionOferta(setYES);
                            }
                          },
                          child: Text(
                            'Подтвердить',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isCheckbox == false
                                  ? Color.fromRGBO(152, 151, 153, 1)
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
