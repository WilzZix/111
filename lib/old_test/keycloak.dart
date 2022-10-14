import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class Keycloak extends StatefulWidget {
  const Keycloak({Key? key}) : super(key: key);

  @override
  State<Keycloak> createState() => _KeycloakState();
}

class _KeycloakState extends State<Keycloak> {
  var userAccessToken;
  var userName;
  var tokenLive;

  var userLoginFild;
  var userPasswordFild;

  var user = 'test';
  var pass = 'test';
  var client = 'lendo-tablet';

  @override
  Widget build(BuildContext context) {
    void launchURL() async {
      try {
        var url = Uri.parse(
            'https://auth.flexit.uz/auth/realms/lendo/protocol/openid-connect/token');
        var response = await http.post(url, body: {
          'grant_type': 'password',
          'username': userLoginFild,
          'password': userPasswordFild,
          'client_id': client,
          // 'client_secret': 'test',
          // 'scope': 'openid',
        }, headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        });

        var jsonResponse = convert.jsonDecode(response.body);

        // print('Response status: ${response.statusCode}');
        // print('Response body: ${response.body}');
        // print(jsonResponse);

        userAccessToken = jsonResponse['access_token'];
        Map<String, dynamic> decodedToken = JwtDecoder.decode(userAccessToken);

        setState(() {
          userName = decodedToken["preferred_username"];
          tokenLive = decodedToken["exp"];
        });

        // var calkDays = tokenLive / (1000 * 60 * 60 * 24).format(DateFormat('dd'));
        // DateTime currentTime = DateTime.now();

        // // the "dd/MM/yyyy HH:mm" format
        // print(DateFormat.yMd().add_jm().format(currentTime));

        print(userName);
      } catch (e) {
        print(e);
      }
    }

    print(userName);
//-----------------
    void addNewTransaktion(String password, String login) {
      // final newTransaktion = Transaktion(
      //   title: title,
      //   amount: amount,
      //   date: chosenData,
      //   id: DateTime.now().toString(),
      // );

      // setState(() {
      //   transaktions.add(newTransaktion);
      // });
      setState(() {
        print(password);
        print(login);

        userLoginFild = login;
        userPasswordFild = password;

        launchURL();
      });

      password = '';
      login = '';
    }

    final passwordCont = TextEditingController();
    final userLogin = TextEditingController();

    void submited() {
      final enteredPasswordCont = passwordCont.text;
      final enteredUserLogin = userLogin.text;

      if (enteredPasswordCont.isEmpty || enteredUserLogin.isEmpty) {
        return;
      }
      addNewTransaktion(enteredPasswordCont, enteredUserLogin);
      print('pressed');
      setState(() {
        print(enteredPasswordCont);
        print(enteredUserLogin);
      });

      // Navigator.of(context).pop();
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: launchURL,
            child: Text('Отправить запрос на авторизацию'),
          ),
          if (userName != null)
            Text(
              'Добро пожаловать $userName',
              style: TextStyle(fontSize: 20),
            ),
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                TextField(
                  autocorrect: true,
                  decoration: const InputDecoration(labelText: 'Логин'),
                  keyboardType: TextInputType.text,
                  controller: userLogin,
                  onSubmitted: (val) => submited(),
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 3, 3, 3), fontSize: 20),
                ),
                TextField(
                  autocorrect: true,
                  decoration: const InputDecoration(labelText: 'Пароль'),
                  controller: passwordCont,
                  keyboardType: TextInputType.visiblePassword,
                  onSubmitted: (val) => submited(),
                  style: const TextStyle(
                      color: Color.fromARGB(255, 3, 3, 3), fontSize: 20),
                ),
                ElevatedButton(
                  child: const Text('Войти',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                  onPressed: () {
                    submited();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
