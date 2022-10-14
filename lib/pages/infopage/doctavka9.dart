import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class Dostavka9 extends StatefulWidget {
  static const String routeName = '/Dostavka9';
  Dostavka9({Key? key}) : super(key: key);

  @override
  State<Dostavka9> createState() => _SostavZakazaState();
}

class _SostavZakazaState extends State<Dostavka9> {
  final items = ['item1', 'item2', 'item3'];
  String? liveCountriCity;
  String? liveCountriArea;
  final homeNumberController = TextEditingController();
  final flatNumberController = TextEditingController();
  final orientirController = TextEditingController();
  final addressController = TextEditingController();

  bool? isCheckbox = false;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
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
                  Navigator.of(context).pop();
                },
              ),
              Container(
                child: const Text(
                  '9. Доставка',
                  style: TextStyle(
                      fontSize: 22, fontFamily: 'Roboto', color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 245,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Color.fromRGBO(33, 150, 83, 1)),
        child: TextButton(
          onPressed: () => {},
          child: const Text(
            'Подтвердить',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
                color: Colors.white),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ListView(
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
                const Text(
                  'Доставка товара',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Roboto',
                    color: Color.fromRGBO(0, 0, 0, 1),
                  ),
                ),
                Gap(40),
                Container(
                  width: width * 1,
                  child: TextField(
                    autofocus: false,
                    keyboardType: TextInputType.streetAddress,
                    autocorrect: false,
                    controller: addressController,
                    onSubmitted: (val) => print(val),
                    style: const TextStyle(
                        fontFamily: 'Roboto',
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontSize: 16),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.black)),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      // suffixIcon: GestureDetector(
                      //   onTap: () {
                      //     FocusScope.of(context).requestFocus(FocusNode());
                      //   },
                      //   child: Transform.rotate(
                      //     angle: 15,
                      //     child: const Icon(
                      //       Icons.control_point_rounded,
                      //       size: 30,
                      //       color: Color.fromRGBO(0, 0, 0, 70),
                      //     ),
                      //   ),
                      // ),
                      labelText: 'Точный адрес*',
                      labelStyle:
                          const TextStyle(color: Colors.grey, fontSize: 15),
                      hintText:
                          'прим. Город Ташкент, ул Катта Дархан, 1 дом, 15 квартира',
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ),
                ),
                Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: width * 0.47,
                      padding: EdgeInsets.only(right: 15, left: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      // margin: EdgeInsets.only(right: 15),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: liveCountriCity,
                          iconSize: 30,
                          items: items.map(buildMenuItemsSity).toList(),
                          onChanged: (value) => setState(
                            () {
                              this.liveCountriCity = value as String?;
                            },
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Color.fromRGBO(0, 0, 0, 70),
                          ),
                          isExpanded: true,
                          hint: const Text(
                            'Город*',
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
                    Container(
                      width: width * 0.47,
                      padding: EdgeInsets.only(right: 15, left: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      child: Container(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: liveCountriArea,
                            iconSize: 30,
                            items: items.map(buildMenuItemsArea).toList(),
                            onChanged: (value) => setState(
                              () {
                                this.liveCountriArea = value as String?;
                              },
                            ),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Color.fromRGBO(0, 0, 0, 70),
                            ),
                            isExpanded: true,
                            hint: const Text(
                              'Район*',
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
                    ),
                  ],
                ),
                Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: width * 0.225,
                      child: TextField(
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        controller: homeNumberController,
                        onSubmitted: (val) => print(val),
                        textInputAction: TextInputAction.next,
                        autofocus: false,
                        style: const TextStyle(
                            fontFamily: 'Roboto',
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 16),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: Colors.black)),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          hintText: 'Номер дома*',
                          hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ),
                    ),
                    Container(
                      width: width * 0.225,
                      child: Container(
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          controller: flatNumberController,
                          onSubmitted: (val) => print(val),
                          textInputAction: TextInputAction.next,
                          autofocus: false,
                          style: const TextStyle(
                              fontFamily: 'Roboto',
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontSize: 16),
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            hintText: 'Номер квартиры*',
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: width * 0.47,
                      child: Container(
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          controller: orientirController,
                          onSubmitted: (val) => print(val),
                          textInputAction: TextInputAction.next,
                          autofocus: false,
                          style: const TextStyle(
                              fontFamily: 'Roboto',
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontSize: 16),
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            hintText: 'Ориентир ',
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

DropdownMenuItem<String> buildMenuItemsSity(String item) {
  return DropdownMenuItem<String>(
    value: item,
    child: Text(item),
  );
}

DropdownMenuItem<String> buildMenuItemsArea(String item) {
  return DropdownMenuItem<String>(
    value: item,
    child: Text(item),
  );
}
