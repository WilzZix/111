import 'package:flutter/material.dart';
import 'my_id.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return Scaffold(
                        appBar: AppBar(
                          title: const Text('Страница аутентификации'),
                        ),
                        body: const View(),
                      );
                    },
                  ),
                );
              },
              child: const Text('Перейти к аутентификации'),
            ),
          ),
        ],
      ),
    );
  }
}
