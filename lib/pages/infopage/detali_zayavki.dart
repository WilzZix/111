import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../utils/mainGraphQl/servises/get-notes.dart';
import '../../utils/mainGraphQl/servises/set-note.dart';
import 'detali_title.dart';

class DetaliZakaza extends StatefulWidget {
  static const String routeName = '/detali_zakaza';
  String userId;
  DetaliZakaza({Key? key, required this.userId}) : super(key: key);
  @override
  State<DetaliZakaza> createState() => _DetaliZakazaState();
}

class _DetaliZakazaState extends State<DetaliZakaza> {
  final items = ['Примечание', 'Отказ'];
  String? areaLive;
  final primController = TextEditingController();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  bool showElements = true;

  var tokenFromLocaleStorage = '';
  loadLocaleStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tokenFromLocaleStorage = prefs.getString('token')!;
    });
  }

  var notesData = [];

  void addNotes() {
    final primControllerText = primController.text;

    if (primControllerText != '' || areaLive != '') {
      setNote(
              claimsId: widget.userId,
              note: primControllerText,
              action: areaLive == 'Примечание' ? '1' : '2',
              tokenFromLocaleStorage: tokenFromLocaleStorage)
          .then((value) {
        print('Notes ----- $value');
      });
      setState(() {
        primController.clear();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadLocaleStorage();
  }

  Future refreshNotes() async {
    if (tokenFromLocaleStorage == '') {
      loadLocaleStorage();
      await Future.delayed(const Duration(seconds: 1));
    }
    return null;
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
                    'Примечание к заявке ',
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
            Container(
              margin: EdgeInsets.only(right: 20),
              child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return AlertDialog(
                            title: Text(
                              "Добавить примечание",
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    "Выберите действие к текущей заявке",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromRGBO(33, 150, 83, 1),
                                    ),
                                  ),
                                  Gap(27),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: width * 0.75,
                                        padding: EdgeInsets.only(
                                            right: 15, left: 15),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color: Colors.grey, width: 1),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            value: areaLive,
                                            iconSize: 30,
                                            items: items
                                                .map(buildMenuItemsAreaLive)
                                                .toList(),
                                            onChanged: (value) => setState(
                                              () {
                                                print('areaLive $value');
                                                setState(() {
                                                  areaLive = value as String?;
                                                });
                                              },
                                            ),
                                            icon: const Icon(
                                              Icons.arrow_drop_down,
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 70),
                                            ),
                                            isExpanded: true,
                                            hint: const Text(
                                              'Примечание / Отказ',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: 'Roboto'),
                                            ),
                                            style: const TextStyle(
                                                fontFamily: 'Roboto',
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1),
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Gap(20),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: width * 0.75,
                                        child: Container(
                                          child: TextField(
                                            controller: primController,
                                            // keyboardType: TextInputType.number,
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: 4,
                                            autocorrect: false,
                                            // controller: priceController,
                                            onSubmitted: (val) => print(val),
                                            textInputAction:
                                                TextInputAction.next,
                                            autofocus: false,
                                            style: const TextStyle(
                                                fontFamily: 'Roboto',
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1),
                                                fontSize: 16),
                                            decoration: InputDecoration(
                                              // contentPadding:
                                              //     EdgeInsets.symmetric(horizontal: 20),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color: Colors.black)),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.0),
                                              ),
                                              labelText: 'Примечание / Отказ',
                                              labelStyle: TextStyle(
                                                fontFamily: 'Roboto',
                                                color: Colors.grey,
                                                fontSize: 15,
                                              ),
                                              // hintText: 'Примечание / Отказ',
                                              hintStyle: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                            actions: <Widget>[
                              BasicDialogAction(
                                title: Text(
                                  "Отмена",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(103, 80, 164, 1),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              BasicDialogAction(
                                title: Text(
                                  "Добавить",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(103, 80, 164, 1),
                                  ),
                                ),
                                onPressed: () {
                                  addNotes();
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
                icon: const Icon(
                  Icons.add_circle_outlined,
                  color: Color.fromRGBO(76, 175, 80, 1),
                  size: 30,
                ),
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: refreshNotes,
          child: FutureBuilder<Map>(
            future: getNotes(
                id: widget.userId,
                tokenFromLocaleStorage:
                    tokenFromLocaleStorage), // calling getUSer with id we got from main screen
            builder: (context, snapshot) {
              print('--------------------  ${snapshot.data!['data']}');
              // print(
              //     '--------------------  ${snapshot.data!['data'].first['note']}');
              print('--------------------  ${snapshot.data!['data'].length}');

              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                // setProductInfo(snapshot.data ?? {});
                return ListView(
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

                          // if (ClientData.products.length != 0) DetaliTitle(),
                          if (snapshot.data!['data'].length != 0) DetaliTitle(),
                          // -----------------------------------------------------------------
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!['data'].length,
                            itemBuilder: (context, index) {
                              // final item = ClientData.products[index];
                              return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      // height: 60,
                                      padding: const EdgeInsets.only(top: 15),
                                      width: width * 0.96,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 35,
                                                child: Text(
                                                  '${index + 1}',
                                                  // '1',
                                                  style: const TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 1),
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  Container(
                                                    // color: Colors.black,
                                                    width: width * 0.90,
                                                    child: Row(
                                                      children: [
                                                        // if (showElements == true)
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              width:
                                                                  width * 0.90,
                                                              child: Text(
                                                                '${snapshot.data!['data'][index]['note']}',
                                                                // 'Клиенту отказали в рассрочке, из-за существующего кредита',
                                                                style:
                                                                    const TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          1),
                                                                ),
                                                              ),
                                                            ),
                                                            Gap(5),
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  width: width *
                                                                      0.2,
                                                                  child: Text(
                                                                    // 'Примечание',
                                                                    '${snapshot.data!['data'][index]['action'] == 1 ? 'Примечание' : 'Отказ'}',

                                                                    style:
                                                                        const TextStyle(
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              17),
                                                                  child: Text(
                                                                    // '14.04.2021',
                                                                    // DateFormat('dd-MM-yyyy-HH:mm').format(dateFormat.parse(snapshot
                                                                    //     .data![
                                                                    //         'data']
                                                                    //         [
                                                                    //         index]
                                                                    //         [
                                                                    //         'createdAt']
                                                                    //     .toString())),
                                                                    '${snapshot.data!['data'][index]['createdAt'].toString().substring(0, 10)}',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  '${snapshot.data!['data'][index]['createdAt'].toString().substring(11, 17)}',
                                                                  // '11:58',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Gap(30),
                                          Container(
                                            padding: EdgeInsets.all(0),
                                            margin: EdgeInsets.all(0),
                                            height: 1,
                                            color: Color.fromRGBO(
                                                193, 193, 193, 0.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]);
                            },
                          ),
                          // -------------------------------------------------------------
                          if (snapshot.data!['data'].length == 0)
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  media.size.width < 440
                                      ? Container(
                                          margin: EdgeInsets.only(left: 160),
                                          child: Image.asset(
                                            'assets/images/comments.png',
                                            height: 250,
                                            width: 250,
                                          ),
                                        )
                                      : Container(
                                          margin: EdgeInsets.only(left: 300),
                                          child: Image.asset(
                                            'assets/images/comments.png',
                                            height: 450,
                                            width: 450,
                                          ),
                                        ),
                                  const Center(
                                    child: Text(
                                      'Примечания отсутствую к заявке \nЧтобы добавить, нажмите кнопку в верхнем правом углу',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromRGBO(73, 69, 79, 1)),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Gap(34),

                          Gap(34),
                        ],
                      ),
                    ),
                  ],
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return Container();
            },
          ),
        ),
      ),
    );
  }
}

DropdownMenuItem<String> buildMenuItemsAreaLive(String item) {
  return DropdownMenuItem<String>(
    value: item,
    child: Text(item),
  );
}
