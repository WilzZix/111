import 'package:MyID/utils/mainGraphQl/servises/product/add_product.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/user_model.dart';
import '../../../utils/constants.dart';

class SostavZakazaSearchList extends StatefulWidget {
  final Product shopProductList;
  final price;
  String userId;

  SostavZakazaSearchList(
      {Key? key,
      required this.shopProductList,
      required this.userId,
      required this.price})
      : super(key: key);

  @override
  State<SostavZakazaSearchList> createState() => _SostavZakazaSearchListState();
}

class _SostavZakazaSearchListState extends State<SostavZakazaSearchList> {
  var tokenFromLocaleStorage = '';
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

  Future addAction() async {
    loadLocaleStorage();
    addProduct(
            claimsId: widget.userId,
            productId: widget.shopProductList.id,
            tokenFromLocaleStorage: tokenFromLocaleStorage)
        .then((value) {
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
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final media = MediaQuery.of(context);
    return media.size.width < 440
        ? Column(
            children: [
              Gap(10),
              InkWell(
                splashColor: Color.fromARGB(255, 2, 159, 250),
                onTap: () {
                  addAction();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Color.fromRGBO(244, 244, 244, 1),
                      width: 1,
                    ),
                  ),
                  padding:
                      EdgeInsets.only(top: 16, bottom: 16, left: 20, right: 16),
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: width * 0.5,
                          child: Text(
                            '${widget.shopProductList.name}',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Roboto'),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${Constants.formatSumm(widget.shopProductList.price!)} ',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Roboto'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        : Column(
            children: [
              Gap(10),
              InkWell(
                splashColor: Color.fromARGB(255, 2, 159, 250),
                onTap: () {
                  addAction();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Color.fromRGBO(244, 244, 244, 1),
                      width: 1,
                    ),
                  ),
                  padding:
                      EdgeInsets.only(top: 16, bottom: 16, left: 20, right: 16),
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: width * 0.7,
                          child: Text(
                            '${widget.shopProductList.name}',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Roboto'),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${Constants.formatSumm(widget.shopProductList.price!)} ',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Roboto'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
