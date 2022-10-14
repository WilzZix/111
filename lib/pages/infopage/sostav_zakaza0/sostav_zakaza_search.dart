import 'package:MyID/utils/mainGraphQl/servises/product/search_product.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/user_model.dart';
import '../../../utils/mainGraphQl/servises/product/custom-add-products.dart';
import 'no_item.dart';
import 'sostav_zakaza_search_list.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

class SostavZakazaSearch extends StatefulWidget {
  static const String routeName = '/sostav_zakaza_search';
  String userId;
  SostavZakazaSearch({Key? key, required this.userId}) : super(key: key);

  @override
  State<SostavZakazaSearch> createState() => _SostavZakazaSearchState();
}

class _SostavZakazaSearchState extends State<SostavZakazaSearch> {
  List<Product> products = [];
  String query = '';
  final productNameController = TextEditingController();
  final priceController = TextEditingController();
  final nameController = TextEditingController();

  bool searchBoolean = true;
  bool loadingProducts = false;
  var searchText = '';
  var tokenFromLocaleStorage = '';
  bool productsShow = false;

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
  }

  void fetchProducts() {
    loadingProducts = true;
    loadLocaleStorage();
    if (searchText != '') {
      searchProducts(
              input: searchText, tokenFromLocaleStorage: tokenFromLocaleStorage)
          .then((value) {
        print('value------------------ ${value}');
        setState(() {
          if (value.isEmpty == true) {
            productsShow = true;
          }
          if (searchText == '') {
            productsShow = false;
          }
          // if (value != []) {
          //   productsShow = false;
          // }
          print('productsShow------------------ ${productsShow}');
        });
        if (!value.isEmpty) {
          setState(() {
            productsShow = false;
            int size = value.length;
            products.clear();
            for (int i = 0; i < size; i++) {
              products.add(Product(
                  id: value[i]['id'].toString(),
                  name: value[i]['name'].toString(),
                  category: value[i]['category'].toString(),
                  price: value[i]['price'].toString()));
            }
          });
        }
      });
    }
    loadingProducts = false;
  }

  Future refreshProducts() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      products.clear();
    });
    fetchProducts();
    return null;
  }

  void addCustomProduicts() {
    final priceControllerEdit = priceController.text;
    final nameControllerEdit = nameController.text;
    print('priceControllerEdit $priceControllerEdit');
    print('nameControllerEdit $nameControllerEdit');
    if (priceControllerEdit != '' || nameControllerEdit != '') {
      addProductCustom(
              claimsId: widget.userId,
              name: nameControllerEdit,
              price: priceControllerEdit,
              tokenFromLocaleStorage: tokenFromLocaleStorage)
          .then((value) {
        print('Товар добавлен в список покупок $value');
        if (!value.isEmpty) {
          // setState(() {});

          const snackdemo = SnackBar(
            content: Text(
              'Товар добавлен в список покупок',
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
        }
      });
      setState(() {
        priceController.clear();
        nameController.clear();
      });
    }
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
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        automaticallyImplyLeading: false,
        title: Container(
          width: width * 1,
          color: Color.fromRGBO(250, 250, 250, 1),
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
                  'Добавить новый товар ',
                  style: TextStyle(
                      fontSize: 22, fontFamily: 'Roboto', color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(shrinkWrap: true, children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Color.fromRGBO(250, 250, 250, 1),
              child: Row(
                children: [
                  Container(
                    color: Color.fromRGBO(250, 250, 250, 1),
                    height: 56,
                    // width: width * 0.72,
                    width: media.size.width > 440 ? width * 0.72 : width * 0.8,
                    margin: EdgeInsets.only(right: 10, left: 20),
                    child: TextField(
                      autofocus: true,
                      style: const TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 70),
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'Поиск товара',
                        hintStyle: const TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 90),
                          fontFamily: 'Roboto',
                          fontSize: 20,
                        ),
                        prefixIcon: GestureDetector(
                          onTap: () {
                            productNameController.clear();
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {
                              searchBoolean = true;
                            });
                          },
                          child: const Icon(
                            Icons.search,
                            size: 30,
                            color: Color.fromRGBO(0, 0, 0, 90),
                          ),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            productNameController.clear();
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {
                              products.clear();
                              productsShow = false;
                            });
                          },
                          child: searchText.length != 0
                              ? Transform.rotate(
                                  angle: 15,
                                  child: const Icon(
                                    Icons.control_point_rounded,
                                    size: 30,
                                    color: Color.fromRGBO(0, 0, 0, 70),
                                  ),
                                )
                              : Icon(
                                  Icons.control_point_rounded,
                                  size: 30,
                                  color: Colors.transparent,
                                ),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      controller: productNameController,
                      onChanged: (value) => {
                        setState(() {
                          searchText = value;
                          // productsShow = false;
                        }),
                        if (!loadingProducts) {refreshProducts()}
                      },
                    ),
                  ),
                  // Container(
                  //   width: width * 0.15,
                  //   child: TextButton(onPressed: () => {}, child: Text('sdsdsd')),
                  // ),

                  Container(
                    child: media.size.width < 440
                        ? Container(
                            // width: width * 0.21,
                            // height: 45,

                            child: IconButton(
                              onPressed: () {
                                // showDialogWithFields();
                                // _showConfirmationAlert(context);

                                showPlatformDialog(
                                  context: context,
                                  builder: (_) => BasicDialogAlert(
                                    title: Text(
                                      "Добавить свой товар в список",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        // Gap(10),
                                        Text(
                                          "Введите наименование и сумму товара, которого нет в списке",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w400,
                                            color:
                                                Color.fromRGBO(33, 150, 83, 1),
                                          ),
                                        ),
                                        Gap(27),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: width * 0.65,
                                              child: TextField(
                                                autofocus: false,
                                                autocorrect: true,
                                                keyboardType:
                                                    TextInputType.text,
                                                controller: nameController,
                                                onSubmitted: (val) =>
                                                    print(val),
                                                onChanged: (val) => print(val),
                                                textInputAction:
                                                    TextInputAction.next,
                                                style: const TextStyle(
                                                    fontFamily: 'Roboto',
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 1),
                                                    fontSize: 16),
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 20),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      borderSide: BorderSide(
                                                          color: Colors.black)),
                                                  focusedBorder:
                                                      const OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    borderSide: BorderSide(
                                                        color: Colors.grey,
                                                        width: 1.0),
                                                  ),

                                                  //

                                                  labelText:
                                                      'Наименование товара',

                                                  labelStyle: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    color: Colors.grey,
                                                    fontSize: 15,
                                                  ),

                                                  hintText:
                                                      'Наименование товара',
                                                  hintStyle: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Gap(20),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: width * 0.30,
                                              child: Container(
                                                child: TextField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  autocorrect: false,
                                                  controller: priceController,
                                                  onSubmitted: (val) =>
                                                      print(val),
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  autofocus: false,
                                                  style: const TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                      fontSize: 16),
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black)),
                                                    focusedBorder:
                                                        const OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5)),
                                                      borderSide: BorderSide(
                                                          color: Colors.grey,
                                                          width: 1.0),
                                                    ),
                                                    labelText: 'Сумма товара',
                                                    labelStyle: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.grey,
                                                      fontSize: 15,
                                                    ),
                                                    hintText: 'Сумма товара',
                                                    hintStyle: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      BasicDialogAction(
                                        title: Text(
                                          "Отмена",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w400,
                                            color:
                                                Color.fromRGBO(103, 80, 164, 1),
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
                                            color:
                                                Color.fromRGBO(103, 80, 164, 1),
                                          ),
                                        ),
                                        onPressed: () {
                                          addCustomProduicts();
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.add_circle_outlined,
                                color: Color.fromRGBO(76, 175, 80, 1),
                                size: 30,
                              ),
                            ),
                          )
                        : Container(
                            width: width * 0.21,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Color.fromRGBO(208, 188, 255, 1),
                            ),
                            child: TextButton(
                              onPressed: () {
                                // showDialogWithFields();
                                // _showConfirmationAlert(context);

                                showPlatformDialog(
                                  context: context,
                                  builder: (_) => BasicDialogAlert(
                                    title: Text(
                                      "Добавить свой товар в список",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        // Gap(10),
                                        Text(
                                          "Введите наименование и сумму товара, которого нет в списке",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w400,
                                            color:
                                                Color.fromRGBO(33, 150, 83, 1),
                                          ),
                                        ),
                                        Gap(27),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: width * 0.75,
                                              child: TextField(
                                                autofocus: false,
                                                autocorrect: true,
                                                keyboardType:
                                                    TextInputType.text,
                                                controller: nameController,
                                                onSubmitted: (val) =>
                                                    print(val),
                                                onChanged: (val) => print(val),
                                                textInputAction:
                                                    TextInputAction.next,
                                                style: const TextStyle(
                                                    fontFamily: 'Roboto',
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 1),
                                                    fontSize: 16),
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 20),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      borderSide: BorderSide(
                                                          color: Colors.black)),
                                                  focusedBorder:
                                                      const OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    borderSide: BorderSide(
                                                        color: Colors.grey,
                                                        width: 1.0),
                                                  ),

                                                  //

                                                  labelText:
                                                      'Наименование товара',

                                                  labelStyle: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    color: Colors.grey,
                                                    fontSize: 15,
                                                  ),

                                                  hintText:
                                                      'Наименование товара',
                                                  hintStyle: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Gap(20),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: width * 0.30,
                                              child: Container(
                                                child: TextField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  autocorrect: false,
                                                  controller: priceController,
                                                  onSubmitted: (val) =>
                                                      print(val),
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  autofocus: false,
                                                  style: const TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                      fontSize: 16),
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black)),
                                                    focusedBorder:
                                                        const OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5)),
                                                      borderSide: BorderSide(
                                                          color: Colors.grey,
                                                          width: 1.0),
                                                    ),
                                                    labelText: 'Сумма товара',
                                                    labelStyle: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.grey,
                                                      fontSize: 15,
                                                    ),
                                                    hintText: 'Сумма товара',
                                                    hintStyle: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      BasicDialogAction(
                                        title: Text(
                                          "Отмена",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w400,
                                            color:
                                                Color.fromRGBO(103, 80, 164, 1),
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
                                            color:
                                                Color.fromRGBO(103, 80, 164, 1),
                                          ),
                                        ),
                                        onPressed: () {
                                          addCustomProduicts();
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Text(
                                '+ Свой товар',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Найдите товар, который хотите добавить в список',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Roboto',
                  color: Colors.grey.shade500,
                ),
              ),
            ),
            Gap(10),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Container(
                  child: SostavZakazaSearchList(
                    shopProductList: products[index],
                    userId: widget.userId,
                    price: products[index].price,
                  ),
                );
              },
            ),
            if (searchText.length == 0 && products.length == 0) NotItem(),
            if (productsShow == true)
              Column(
                children: [
                  Gap(100),
                  Container(
                    child: Center(
                      child: const Text(
                        'Товар не найден \nВы можете добавить товар вручную',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Roboto',
                            color: Color.fromRGBO(0, 0, 0, 70)),
                      ),
                    ),
                  ),
                  Gap(20),
                  Container(
                    width: 281,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Color.fromRGBO(103, 80, 164, 1),
                    ),
                    child: TextButton(
                      onPressed: () {
                        // showDialogWithFields();
                        // _showConfirmationAlert(context);

                        showPlatformDialog(
                          context: context,
                          builder: (_) => BasicDialogAlert(
                            title: Text(
                              "Добавить свой товар в список",
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                // Gap(10),
                                Text(
                                  "Введите наименование и сумму товара, которого нет в списке",
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
                                      child: TextField(
                                        autofocus: false,
                                        autocorrect: true,
                                        keyboardType: TextInputType.text,
                                        controller: nameController,
                                        onSubmitted: (val) => print(val),
                                        onChanged: (val) => print(val),
                                        textInputAction: TextInputAction.next,
                                        style: const TextStyle(
                                            fontFamily: 'Roboto',
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontSize: 16),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 20),
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
                                                color: Colors.grey, width: 1.0),
                                          ),

                                          //

                                          labelText: 'Наименование товара',

                                          labelStyle: TextStyle(
                                            fontFamily: 'Roboto',
                                            color: Colors.grey,
                                            fontSize: 15,
                                          ),

                                          hintText: 'Наименование товара',
                                          hintStyle: const TextStyle(
                                              color: Colors.grey, fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Gap(20),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: width * 0.30,
                                      child: Container(
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          autocorrect: false,
                                          controller: priceController,
                                          onSubmitted: (val) => print(val),
                                          textInputAction: TextInputAction.next,
                                          autofocus: false,
                                          style: const TextStyle(
                                              fontFamily: 'Roboto',
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 16),
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20),
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
                                            labelText: 'Сумма товара',
                                            labelStyle: TextStyle(
                                              fontFamily: 'Roboto',
                                              color: Colors.grey,
                                              fontSize: 15,
                                            ),
                                            hintText: 'Сумма товара',
                                            hintStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
                                  addCustomProduicts();
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text(
                        'Добавить свой товар',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
        Gap(30),
      ]),
    );
  }
}
