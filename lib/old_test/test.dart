import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Test extends StatefulWidget {
  static const String routeName = '/test';
  Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // late Future<int> _counter;

  // Future<void> _incrementCounter() async {
  //   final SharedPreferences prefs = await _prefs;
  //   final int counter = (prefs.getInt('counter') ?? 0) + 1;

  //   setState(() {
  //     _counter = prefs.setInt('counter', counter).then((bool success) {
  //       return counter;
  //     });
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _counter = _prefs.then((SharedPreferences prefs) {
  //     return prefs.getInt('counter') ?? 0;
  //   });
  // }

  var value = '';

  List<String> arrayNew = [];

  var lastList = [];

  ssss() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      lastList = prefs.getStringList('pinCode') as List<String>;
    });
  }

  // var lastList = arrayNew.forEach((element) {
  //   if(element == '123'){
  //     print('123');
  //   }
  // });

  @override
  Widget build(BuildContext context) {
    // if (lastList != -1) {
    //   print(
    //       'lastList ------------------------------------------------------ ${lastList}');
    // }

    print('indexNumber ${arrayNew.indexOf('123')}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('SharedPreferences Demo'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('test', 'my value');
                },
                child: Text('Save data')),
            // ElevatedButton(
            //     onPressed: () async {
            //       SharedPreferences prefs =
            //           await SharedPreferences.getInstance();
            //       setState(() {
            //         value = prefs.getString('test')!;
            //       });
            //       print('Value: $value');
            //     },
            //     child: Text('load data')),
            // ElevatedButton(
            //     onPressed: () async {
            //       SharedPreferences prefs =
            //           await SharedPreferences.getInstance();
            //       prefs.remove('test');
            //     },
            //     child: Text('clear data')),
            // Text('Value: ${value}', style: TextStyle(fontSize: 30)),
            // -------------------------------------------
            ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  //  List<String> lastArr =  arrayNew.add('test111');
                  arrayNew.add('test111');
                  arrayNew.add('123');

                  prefs.setStringList('array', arrayNew);
                },
                child: Text('Save data')),
            ElevatedButton(onPressed: ssss, child: Text('load data')),
            // Text('Value: ${arrayNew}', style: TextStyle(fontSize: 30)),
            // if([1,2,3].indexOf(1))
            // if (lastList.indexOf('123') != -1)
            Text('Value: ${lastList}', style: TextStyle(fontSize: 30)),
          ],
        ),
      ),
    );
  }
}
