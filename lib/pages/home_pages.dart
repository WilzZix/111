import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../autorization/auth_keyloak.dart';
import '../model/user_model.dart';
import '../utils/loyout.dart';
import '../utils/mainGraphQl/servises/add_code.dart';
import '../utils/mainGraphQl/servises/get-claims-list-grouped.dart';
import '../utils/mainGraphQl/servises/get_users.dart';
import 'home_page_contents_list.dart';
import 'package:flutter/services.dart';

import 'info_pages.dart';

class HomePagesScreen extends StatefulWidget {
  static const String routeName = '/home';
  HomePagesScreen({Key? key}) : super(key: key);
  static const platform = MethodChannel('flutter.native/myid');

  @override
  State<HomePagesScreen> createState() => _HomePagesScreenState();
}

class _HomePagesScreenState extends State<HomePagesScreen> {
  final defaultPage = 1;
  final defaultSizePage = 20;
  late int page;
  late int sizePage;
  String keyword = '';
  bool hasMoreClients = true;
  bool isLoadingClients = false;
  List<Users> usersListFilter = [];
  List<Users> usersListFilter1 = [];
  String query = '';
  final _controller = ScrollController();
  late Future<List<String>> _future;
  var searchResItems = '';
  var response;
  String? result = '';
  var res2 = "";
  int res4 = 0;
  final fioController = TextEditingController();
  final paymentController = TextEditingController();
  var tokenFromLocaleStorage = '';
  bool redirectNavigate = true;

  loadLocaleStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tokenFromLocaleStorage = prefs.getString('token')!;
    });
  }

  void savePinCodeToLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('auth', false);
    prefs.remove('token');
    prefs.remove('userLoginFild');
    prefs.remove('userPasswordFild');
    Navigator.of(context).pushNamed(AuthKeyloak.routeName);
  }

  @override
  void initState() {
    super.initState();
    loadLocaleStorage();
    page = defaultPage;
    sizePage = defaultSizePage;
    fetchClients();
    refreshClients(key: '');
    _controller.addListener(() {
      var isEnd = _controller.offset == _controller.position.maxScrollExtent;
      if (_controller.position.maxScrollExtent == _controller.offset) {
        fetchClients();
      }
    });
  }

  void fetchClients() {
    if (isLoadingClients) return;
    isLoadingClients = true;
    loadLocaleStorage();
    getClaimsListGroupedFun(
            page: page,
            size: sizePage,
            keyword: keyword,
            tokenFromLocaleStorage: tokenFromLocaleStorage)
        .then((value) {
      // print('--------- value --------- $value');
      int? size = value.length;
      List<Users> temp = [];
      List tempppppttt = [];
      print('value[0] ++++++++++++++++++ ${value}');
      if (size > 0 && value != 'DEFAULT_RESPONSE') {
        for (int i = 0; i < size; i++) {
          // print(
          //     '------------------ widget.users-fio ------- ${value[i]['data'][i]['name'].toString()}');

          Users user = Users(
            fio: value[i]['data'][i]['name'].toString(),
            payment: value[i]['data'][i]['summ'].toString(),

// ---------
            label: value[i]['label'].toString(),
            count: value[i]['count'].toString(),
            id: value[i]['data'][i]['id'].toString(),
            status: value[i]['data'][i]['state'].toString(),
            data: value[i]['data'],
          );
          temp.add(user);
          // for (int intg = 0; intg < value[i]['data'].length; intg++) {
          //   Users user = Users(
          //     fio: value[i]['data'][intg]['name'].toString(),
          //     payment: value[i]['data'][intg]['summ'].toString(),
          //   );
          //   temp.add(user);
          // }

          print('------------------ user.fio ${user.fio}');
        }
      }
      setState(() {
        usersListFilter.addAll(temp);
        if (size == 0 || (size < sizePage && value != 'DEFAULT_RESPONSE')) {
          hasMoreClients = false;
        }
      });
    });
    page++;
    isLoadingClients = false;
  }

  Future refreshClients({String key = ''}) async {
    if (tokenFromLocaleStorage == '') {
      loadLocaleStorage();
      await Future.delayed(const Duration(seconds: 1));
    }
    setState(() {
      page = defaultPage;
      sizePage = defaultSizePage;
      keyword = key;
      searchBoolean = true;
      searchLine = false;
      hasMoreClients = true;
      isLoadingClients = false;
      usersListFilter = [];
      usersListFilter1 = [];
      usersListTotal = [];
    });
    fetchClients();
    return null;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List usersListTotal = [];
  bool searchBoolean = true;
  bool searchLine = false;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    void searchFIO(String query) {
      setState(() {
        usersListFilter1 = usersListFilter.where((fion) {
          print(
              '------------------ fionfionfionfionfionfion ------- ${fion.toString()}');
          var input = query.split(' ');
          var inp2 = input.length != 1 ? input[1] : '';
          var sort = fion.fio!.toLowerCase().contains(input[0].toLowerCase()) &&
              fion.payment!.toLowerCase().replaceAll('', ' ').contains(inp2);
          var sort2 = fion.fio!
                  .toLowerCase()
                  .replaceAll('', ' ')
                  .contains(inp2.toLowerCase()) &&
              fion.payment!.toLowerCase().contains(input[0]);
          return sort || sort2;
        }).toList();
        // print('------------ +++++++++++ ========= query $query');
        // print(
        //     '------------ +++++++++++ ========= usersListFilter ${usersListFilter}');
      });
    }

    final size = AppLayout.getSize(context);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final media = MediaQuery.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: searchBoolean == true
            ? Color.fromRGBO(103, 80, 164, 1)
            : Colors.grey[50],
        automaticallyImplyLeading: false,
        title: Container(
            child: Container(
          child: searchBoolean == false
              ? Container(
                  padding: EdgeInsets.only(top: 40),
                  child: TextField(
                    autofocus: true,
                    autocorrect: true,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Поиск',
                      hintStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: GestureDetector(
                        onTap: () {
                          fioController.clear();
                          searchFIO('');
                          setState(() {
                            searchBoolean = true;
                          });
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: Color.fromRGBO(0, 0, 0, 70),
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    controller: fioController,
                    onChanged: (value) => {
                      searchFIO(value),
                      setState(() {
                        searchResItems = value;
                      }),
                      if (value != '')
                        {
                          setState(() {
                            searchLine = true;
                          }),
                        }
                      else
                        {
                          setState(() {
                            value = '';
                            searchLine = false;
                            fetchClients();
                          }),
                        }
                    },
                  ),
                )
              : Container(
                  width: width * 1,
                  // width: media.size.width > 440 ? width * 1 : width * 0.90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: IconButton(
                            onPressed: () {
                              if (!scaffoldKey.currentState!.isDrawerOpen) {
                                //check if drawer is closed
                                scaffoldKey.currentState!
                                    .openDrawer(); //open drawer
                              }
                            },
                            icon: const Icon(Icons.menu,
                                size: 30, color: Colors.white)),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: AppLayout.getWidth(0)),
                        child: const Text(
                          'Список заявок',
                          style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'Roboto',
                              color: Colors.white),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search,
                            size: 35, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            searchBoolean = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
        )),
      ),
      floatingActionButton: Container(
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Color.fromRGBO(238, 232, 244, 1),
            borderRadius: BorderRadius.all(Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.35),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: FloatingActionButton(
            backgroundColor: Color.fromRGBO(238, 232, 244, 1),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            onPressed: () => {
              HomePagesScreen.platform.invokeMethod('runSDK').then((value) => {
                    setState(() => {
                          result = value,
                          res2 = value
                              .toString()
                              .trim()
                              .replaceRange(0, 9, ' ')
                              .replaceRange(31, 33, ' ')
                              .replaceAll(' ', ''),
                          res4 = value.length,
                          if (res4 == 41)
                            setState(() {
                              redirectNavigate = false;
                            }),
                          {
                            addCode(
                              code: res2,
                              tokenFromLocaleStorage: tokenFromLocaleStorage,
                            ).then((value) => {
                                  setState(() => {
                                        response = value,
                                        if (response != null)
                                          {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) => InfoPage(
                                                userId: response['claimsId']
                                                    .toString(),
                                              ),
                                            ))
                                                .then((value) {
                                              refreshClients();
                                            }),
                                            setState(() {
                                              redirectNavigate = true;
                                            }),
                                          }
                                      }),
                                }),
                          }
                        })
                  })
            },
            child: const Icon(
              Icons.add,
              size: 35,
              color: Color.fromRGBO(103, 80, 164, 1),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 64,
              child: const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(103, 80, 164, 1),
                ),
                child: Text('Lendo', style: TextStyle(color: Colors.white)),
              ),
            ),
            ListTile(
              title: const Text(
                'Выйти',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              ),
              onTap: () {
                savePinCodeToLocalStorage();
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refreshClients,
        child: Container(
          child: Container(
            child: redirectNavigate != true
                ? ListView(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _controller,
                    children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Center(
                              child: const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ])
                : ListView(
                    shrinkWrap: false,
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _controller,
                    children: [
                      Column(
                        children: [
                          Gap(7),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: AppLayout.getHeight(8)),
                            child: Column(
                              children: [
                                // HomePageContentsList(),
                                ListView.builder(
                                  // controller: _controller,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  // itemCount: usersListFilter.length + 1,
                                  itemCount: searchResItems == ''
                                      ? usersListFilter.length + 1
                                      : usersListFilter1.length,
                                  itemBuilder: (context, index) {
                                    if (index < usersListFilter.length) {
                                      final userList =
                                          searchResItems.length <= 0
                                              ? usersListFilter[index]
                                              : usersListFilter1[index];
                                      return Container(
                                        padding: EdgeInsets.only(
                                            top: AppLayout.getHeight(10),
                                            bottom: AppLayout.getHeight(10)),
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {},
                                          child: HomePageContentsList(
                                            users: userList,
                                            // snapshot.data![index],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 32),
                                        child: Center(
                                            child: hasMoreClients
                                                ? const CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                      Colors.blue,
                                                    ),
                                                  )
                                                : const Text(' ')),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
