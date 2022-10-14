import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class View extends StatefulWidget {
  static const routeName = '/old_testmy_id';
  const View({Key? key}) : super(key: key);

  static const platform = MethodChannel('flutter.native/myid');

  @override
  State<View> createState() => _ViewState();
}

class _ViewState extends State<View> {
  var result = "";
  var failed = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My ID'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                View.platform.invokeMethod('runSDK').then((value) => {
                      setState(() => {result = value, print(value)})
                    });
              },
              child: const Text("Запустить аутентификацию"),
            ),
            if (result != '')
              const SizedBox(
                height: 20,
              ),
            if (result != '')
              SelectableText(
                  "Сообщение: " +
                      result
                          .toString()
                          .replaceRange(0, 9, ' ')
                          .replaceRange(31, 33, ' '),
                  cursorColor: Colors.black,
                  showCursor: true,
                  toolbarOptions: ToolbarOptions(
                      copy: true, selectAll: true, cut: false, paste: false),
                  style: TextStyle(fontSize: 17)),
          ],
        ),
      ),
    );
  }
}
