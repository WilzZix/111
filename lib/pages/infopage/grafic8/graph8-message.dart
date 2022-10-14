import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../info_pages.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';

class Grafic8Message extends StatefulWidget {
  static const String routeName = '/Grafic8Message2-message';
  final String? userId;
  final String? data;
  final String? msg;

  Grafic8Message(
      {Key? key, required this.userId, required this.data, required this.msg})
      : super(key: key);

  @override
  State<Grafic8Message> createState() => _SostavZakazaState();
}

class _SostavZakazaState extends State<Grafic8Message> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

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
          body: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                if (widget.data == null)
                  Center(
                    child: Container(
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              // 'Данные будут доступны после оформления рассрочки',
                              widget.msg!,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Roboto',
                                color: Color.fromRGBO(0, 0, 0, 90),
                              ),
                            ),
                          ),
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
                                  // Navigator.of(context)
                                  //     .pushNamed(InfoPage.routeName),
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
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
