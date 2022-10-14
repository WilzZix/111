import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../model/user_model.dart';
import '../utils/loyout.dart';
import 'info_pages.dart';

class HomePageContentsList extends StatefulWidget {
  final Users users;
  HomePageContentsList({Key? key, required this.users}) : super(key: key);
  @override
  State<HomePageContentsList> createState() => _HomePageContentsListState();
}

class _HomePageContentsListState extends State<HomePageContentsList> {
  @override
  Widget build(BuildContext context) {
    // print('------------------ widget.users ${widget.users.label}');
    // print('------------------ widget.count ${widget.users.count}');
    // print('------------------ widget.data ${widget.users.data}');
    // print(
    //     '------------------ widget.users.data.length ${widget.users.data.length}');

    final media = MediaQuery.of(context);
    print(media);
    final size = AppLayout.getSize(context);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return media.size.width < 440
        ? Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: width * 0.90,

                  // width: media.size.width > 440 ? width * 0.95 : width * 0.7,
                  child: Column(
                    children: [
                      Container(
                        width: width * 0.90,
                        // color: Colors.green,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Gap(15),
                                Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    // '6 Октября 2022 г. (3)',
                                    "${widget.users.label}  (${widget.users.count})",
                                    // '${widget.users.name}',
                                    style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                    ),
                                  ),
                                ),
                                Gap(10),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10),
                                  // padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                  ),
                                  width: width * 0.9,
                                  // color: Colors.green,
                                  // width: media.size.width > 440
                                  //     ? width * 0.95
                                  //     : width * 0.93,
                                  child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    // itemCount: usersListFilter.length + 1,
                                    itemCount: widget.users.data.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.only(top: 15),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              onTap: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          InfoPage(
                                                        userId: widget.users
                                                            .data[index]['id']!
                                                            .toString(),
                                                      ),
                                                    ))
                                                    .then((value) {});
                                              },
                                              // width: width * 0.3,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            // width: 40,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 15),
                                                            child: Text(
                                                              '${widget.users.data[index]['id']}',
                                                              // '123',
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
                                                          Container(
                                                            width: width * 0.6,
                                                            // width:
                                                            //     media.size.width > 440
                                                            //         ? width * 0.68
                                                            //         : width * 0.35,
                                                            child: Text(
                                                              // '${snapshot.data!['data'][index]['note']}',
                                                              '${widget.users.data[index]['name']}',
                                                              // 'Markin.P',
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
                                                        ],
                                                      ),
                                                      // Container(
                                                      //   child: Text(
                                                      //     '${widget.users.data[index]['date']}',
                                                      //     style:
                                                      //         const TextStyle(
                                                      //       fontFamily:
                                                      //           'Roboto',
                                                      //       fontSize: 16,
                                                      //       fontWeight:
                                                      //           FontWeight.w400,
                                                      //       color:
                                                      //           Color.fromRGBO(
                                                      //               0, 0, 0, 1),
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                    ],
                                                  ),
                                                  Gap(5),
                                                  Container(
                                                    child: Text(
                                                      '${widget.users.data[index]['date']}',
                                                      style: const TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Color.fromRGBO(
                                                            0, 0, 0, 1),
                                                      ),
                                                    ),
                                                  ),
                                                  Gap(5),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        // width: width * 0.2,state
                                                        child: Text(
                                                          // 'Примечание',
                                                          // '${widget.users.data[index]['status'] == 1 ? 'Примечание' : 'Отказ'}',
                                                          '${widget.users.data[index]['state']}',

                                                          style:
                                                              const TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Gap(15),
                                                  // Text('sdsdsdsdsd'),
                                                  Container(
                                                    width: width * 0.8,
                                                    // width: media.size.width > 440
                                                    //     ? width * 0.925
                                                    //     : width * 0.80,
                                                    height: 1,
                                                    color: Color.fromRGBO(
                                                        193, 193, 193, 0.5),
                                                    child: Text('1'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Gap(10),
                                Container(
                                  padding: EdgeInsets.all(0),
                                  margin: EdgeInsets.all(0),
                                  height: 1,
                                  color: Color.fromRGBO(193, 193, 193, 0.5),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: width * 0.93,

                  // width: media.size.width > 440 ? width * 0.95 : width * 0.7,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Gap(15),
                              Container(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  // '6 Октября 2022 г. (3)',
                                  "${widget.users.label}  (${widget.users.count})",
                                  // '${widget.users.name}',
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                  ),
                                ),
                              ),
                              Gap(10),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10),
                                // padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                                width: width * 0.93,
                                // width: media.size.width > 440
                                //     ? width * 0.95
                                //     : width * 0.93,
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  // itemCount: usersListFilter.length + 1,
                                  itemCount: widget.users.data.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(top: 15),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        InfoPage(
                                                      userId: widget.users
                                                          .data[index]['id']!
                                                          .toString(),
                                                    ),
                                                  ))
                                                  .then((value) {});
                                            },
                                            // width: width * 0.3,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          // width: 40,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 15),
                                                          child: Text(
                                                            '${widget.users.data[index]['id']}',
                                                            // '123',
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
                                                          width: width * 0.63,
                                                          // width:
                                                          //     media.size.width > 440
                                                          //         ? width * 0.68
                                                          //         : width * 0.35,
                                                          child: Text(
                                                            // '${snapshot.data!['data'][index]['note']}',
                                                            '${widget.users.data[index]['name']}',
                                                            // 'Markin.P',
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
                                                      ],
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        // '${snapshot.data!['data'][index]['note']}',
                                                        '${widget.users.data[index]['date']}',
                                                        // '2022-10-06 17-22-51',
                                                        // '${snapshot.data!['data'][index]['createdAt'].toString().substring(11, 17)}',
                                                        style: const TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Color.fromRGBO(
                                                              0, 0, 0, 1),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Gap(5),
                                                Row(
                                                  children: [
                                                    Container(
                                                      // width: width * 0.2,state
                                                      child: Text(
                                                        // 'Примечание',
                                                        // '${widget.users.data[index]['status'] == 1 ? 'Примечание' : 'Отказ'}',
                                                        '${widget.users.data[index]['state']}',

                                                        style: const TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Gap(15),
                                                // Text('sdsdsdsdsd'),
                                                Container(
                                                  width: width * 0.89,
                                                  // width: media.size.width > 440
                                                  //     ? width * 0.925
                                                  //     : width * 0.80,
                                                  height: 1,
                                                  color: Color.fromRGBO(
                                                      193, 193, 193, 0.5),
                                                  child: Text('1'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Gap(10),
                              Container(
                                padding: EdgeInsets.all(0),
                                margin: EdgeInsets.all(0),
                                height: 1,
                                color: Color.fromRGBO(193, 193, 193, 0.5),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
