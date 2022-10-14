import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../utils/loyout.dart';
import '../pages/home_pages.dart';

class IdentificationList extends StatefulWidget {
  static const String routeName = '/identification';
  IdentificationList({Key? key}) : super(key: key);

  @override
  State<IdentificationList> createState() => _IdentificationListState();
}

class _IdentificationListState extends State<IdentificationList> {
  String dropdownValue = '9';
  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
            padding: EdgeInsets.only(left: AppLayout.getWidth(30)),
            child: const Text('Вы прошли идентификацию')),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppLayout.getWidth(20),
                      vertical: AppLayout.getHeight(0)),
                  margin: EdgeInsets.only(top: AppLayout.getHeight(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: AppLayout.getWidth(180),
                        height: AppLayout.getHeight(45),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(HomePagesScreen.routeName);
                          },
                          child: Text(
                            'Назад к списку',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: AppLayout.getHeight(20),
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        width: AppLayout.getWidth(200),
                        height: AppLayout.getHeight(45),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(HomePagesScreen.routeName);
                          },
                          child: Text(
                            'Отказ',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: AppLayout.getHeight(19),
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red.shade400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(AppLayout.getHeight(10)),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: AppLayout.getHeight(1),
                ),
                Gap(AppLayout.getHeight(10)),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppLayout.getWidth(20),
                      vertical: AppLayout.getHeight(0)),
                  // margin: EdgeInsets.only(top: AppLayout.getHeight(20)),
                  child: Row(
                    children: [
                      Container(
                        width: AppLayout.getWidth(200),
                        child: Text(
                          'Товар',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: AppLayout.getHeight(17),
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade900),
                        ),
                      ),
                    ],
                  ),
                ),

                //----

                Gap(AppLayout.getHeight(10)),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: AppLayout.getHeight(1),
                ),
                Gap(AppLayout.getHeight(10)),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppLayout.getWidth(20),
                      vertical: AppLayout.getHeight(0)),
                  // margin: EdgeInsets.only(top: AppLayout.getHeight(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Наименование',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: AppLayout.getHeight(19),
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade900),
                      ),
                      Text(
                        'Сообщение',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: AppLayout.getHeight(19),
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade900),
                      ),
                      Text(
                        'Статус',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: AppLayout.getHeight(19),
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade900),
                      ),
                    ],
                  ),
                ),

                //-----------
                Gap(AppLayout.getHeight(10)),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: AppLayout.getHeight(1),
                ),
                Gap(AppLayout.getHeight(10)),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppLayout.getWidth(20),
                      vertical: AppLayout.getHeight(0)),
                  // margin: EdgeInsets.only(top: AppLayout.getHeight(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Идентификация',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: AppLayout.getHeight(17),
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade900),
                      ),
                      Text(
                        'Успешно',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: AppLayout.getHeight(17),
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade900),
                      ),
                    ],
                  ),
                ),

                //-----------
                Gap(AppLayout.getHeight(10)),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: AppLayout.getHeight(1),
                ),
                Gap(AppLayout.getHeight(10)),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppLayout.getWidth(20),
                      vertical: AppLayout.getHeight(0)),
                  // margin: EdgeInsets.only(top: AppLayout.getHeight(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Данные',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: AppLayout.getHeight(17),
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade900),
                      ),
                      Text(
                        'Готова',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: AppLayout.getHeight(17),
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade900),
                      ),
                    ],
                  ),
                ),

                //-----------
                Gap(AppLayout.getHeight(10)),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: AppLayout.getHeight(1),
                ),
                Gap(AppLayout.getHeight(10)),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppLayout.getWidth(20),
                      vertical: AppLayout.getHeight(0)),
                  // margin: EdgeInsets.only(top: AppLayout.getHeight(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: AppLayout.getWidth(200),
                        child: Text(
                          'Клиент',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: AppLayout.getHeight(17),
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade900),
                        ),
                      ),
                      Text(
                        'Сообщение',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: AppLayout.getHeight(17),
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade900),
                      ),
                      const Spacer(),
                      Text(
                        'Успешно',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: AppLayout.getHeight(17),
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade900),
                      ),
                    ],
                  ),
                ),

                //-----------
                Gap(AppLayout.getHeight(10)),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: AppLayout.getHeight(1),
                ),
                Gap(AppLayout.getHeight(10)),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppLayout.getWidth(20),
                      vertical: AppLayout.getHeight(0)),
                  // margin: EdgeInsets.only(top: AppLayout.getHeight(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: AppLayout.getWidth(200),
                        child: Text(
                          'Скоринг',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: AppLayout.getHeight(17),
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade900),
                        ),
                      ),
                      Text(
                        'Сообщение',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: AppLayout.getHeight(17),
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade900),
                      ),
                      const Spacer(),
                      Text(
                        'Успешно',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: AppLayout.getHeight(17),
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade900),
                      ),
                    ],
                  ),
                ),

                //-----------
                Gap(AppLayout.getHeight(10)),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: AppLayout.getHeight(1),
                ),

                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppLayout.getWidth(20),
                      vertical: AppLayout.getHeight(0)),
                  // margin: EdgeInsets.only(top: AppLayout.getHeight(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: AppLayout.getWidth(200),
                        child: Text(
                          'Оформление',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: AppLayout.getHeight(17),
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade900),
                        ),
                      ),
                      // Text(
                      //   'ДропМеню',
                      //   style: TextStyle(fontFamily: 'Roboto',
                      //       fontSize: AppLayout.getHeight(17),
                      //       fontWeight: FontWeight.w400,
                      //       color: Colors.grey.shade900),
                      // ),

                      Row(
                        children: [
                          Text(
                            'Выберите параметры рассрочки: ',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: AppLayout.getHeight(17),
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade900),
                          ),
                          DropdownButton<String>(
                            value: dropdownValue,
                            icon: const Icon(
                              Icons.arrow_downward,
                              color: Colors.transparent,
                            ),
                            // elevation: 16,
                            style: const TextStyle(
                                fontFamily: 'Roboto',
                                color: Colors.black,
                                fontSize: 17),
                            underline: Container(
                              height: 2,
                              color: Colors.transparent,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                              });
                            },
                            items: <String>['4', '6', '9', '12']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        'Готова',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: AppLayout.getHeight(17),
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade900),
                      ),
                    ],
                  ),
                ),

                //-----------

                Divider(
                  color: Colors.grey.shade300,
                  thickness: AppLayout.getHeight(1),
                ),
                Gap(AppLayout.getHeight(10)),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppLayout.getWidth(20),
                      vertical: AppLayout.getHeight(0)),
                  // margin: EdgeInsets.only(top: AppLayout.getHeight(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: AppLayout.getWidth(200),
                        child: Text(
                          'Договор',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: AppLayout.getHeight(17),
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade900),
                        ),
                      ),
                      Text(
                        'Дата погашения',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: AppLayout.getHeight(17),
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade900),
                      ),
                      const Spacer(),
                      Text(
                        'Готова',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: AppLayout.getHeight(17),
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade900),
                      ),
                    ],
                  ),
                ),

                //-----------
                Gap(AppLayout.getHeight(10)),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: AppLayout.getHeight(1),
                ),
                Gap(AppLayout.getHeight(10)),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppLayout.getWidth(20),
                      vertical: AppLayout.getHeight(0)),
                  // margin: EdgeInsets.only(top: AppLayout.getHeight(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: AppLayout.getWidth(200),
                        child: Text(
                          'Подтверждение',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: AppLayout.getHeight(17),
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade900),
                        ),
                      ),
                      Text(
                        'Вам в телефон пришла СМС',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: AppLayout.getHeight(17),
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade900),
                      ),
                      const Spacer(),
                      Text(
                        'Успешно',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: AppLayout.getHeight(17),
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade900),
                      ),
                    ],
                  ),
                ),

                //-----------
                Gap(AppLayout.getHeight(10)),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: AppLayout.getHeight(1),
                ),
                Gap(AppLayout.getHeight(10)),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppLayout.getWidth(20),
                      vertical: AppLayout.getHeight(0)),
                  // margin: EdgeInsets.only(top: AppLayout.getHeight(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: AppLayout.getWidth(200),
                        child: Text(
                          'График',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: AppLayout.getHeight(17),
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade900),
                        ),
                      ),
                      Text(
                        'Сообщение',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: AppLayout.getHeight(17),
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade900),
                      ),
                      const Spacer(),
                      Text(
                        'Готова',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: AppLayout.getHeight(17),
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade900),
                      ),
                    ],
                  ),
                ),

                //-----------
                Gap(AppLayout.getHeight(10)),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: AppLayout.getHeight(1),
                ),
                Gap(AppLayout.getHeight(10)),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppLayout.getWidth(20),
                      vertical: AppLayout.getHeight(0)),
                  // margin: EdgeInsets.only(top: AppLayout.getHeight(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: AppLayout.getWidth(200),
                        child: Text(
                          'Доставка',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: AppLayout.getHeight(17),
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade900),
                        ),
                      ),
                      Text(
                        'Сообщение',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: AppLayout.getHeight(17),
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade900),
                      ),
                      const Spacer(),
                      Text(
                        'Доставлено',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: AppLayout.getHeight(17),
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade900),
                      ),
                    ],
                  ),
                ),

                Gap(AppLayout.getHeight(10)),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: AppLayout.getHeight(1),
                ),
                Gap(AppLayout.getHeight(10)),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppLayout.getWidth(20),
                      vertical: AppLayout.getHeight(0)),
                  width: double.infinity,
                  height: AppLayout.getHeight(50),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.of(context)
                      //     .pushNamed(HomePagesScreen.routeName);
                      print('sss');
                    },
                    child: Text(
                      'Текущие состояние в этапе оформление',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: AppLayout.getHeight(20),
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
