import 'package:flutter/material.dart';

class NotItem extends StatelessWidget {
  const NotItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return media.size.width < 440
        ? Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/shopping.png',
                  height: 250,
                  width: 250,
                ),
                const Center(
                  child: Text(
                    'Найдите товары по ключевым словам, \n  прим. “Холодильник”',
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
          )
        : Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/shopping.png',
                  height: 450,
                  width: 450,
                ),
                const Center(
                  child: Text(
                    'Найдите товары по ключевым словам, \n  прим. “Холодильник”',
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
          );
  }
}
