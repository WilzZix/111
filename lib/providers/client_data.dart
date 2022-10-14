import '../model/user_model.dart';
import '../utils/mainGraphQl/servises/product/get_products.dart';

class ClientData {
  static bool is0OrdersLoading = true;
  static bool is1IdentityLoading = true;
  static bool is2InfoLoading = true;
  static bool is3ClientLoading = true;
  static bool is4ScoringLoading = true;
  static bool is5RegistrationLoading = true;
  static bool is6ContractLoading = true;
  static bool is7ConfirmLoading = true;
  static bool is8ScheduleLoading = true;
  static bool is9DeliveryLoading = true;

  // 0: Orders
  static String amount = '0.00';
  static String count = '0.00';
  static String delivery = '0.00';
  static String total = '0.00';
  static List<Product> products = [];

  static void set0OrdersInfo(Map value) {
    if (!value.isEmpty) {
      ClientData.products.clear();

      ClientData.amount = value['amount'].toString();
      ClientData.count = value['count'].toString();
      ClientData.total = value['amount'].toString(); // + delivery;
      int size = value['products'].length;
      for (int i = 0; i < size; i++) {
        ClientData.products.add(Product(
            id: value['products'][i]['id'].toString(),
            name: value['products'][i]['name'].toString(),
            category: value['products'][i]['category'].toString(),
            price: value['products'][i]['price'].toString()));
      }
    }
  }

  static Future load0Orders(String userId, String token) async {
    getProducts(id: userId, tokenFromLocaleStorage: token).then((value) {
      if (!value.isEmpty) {
        ClientData.products.clear();

        ClientData.amount = value['amount'].toString();
        ClientData.count = value['count'].toString();
        ClientData.total = value['amount'].toString(); // + delivery;
        int size = value['products'].length;
        for (int i = 0; i < size; i++) {
          ClientData.products.add(Product(
              id: value['products'][i]['id'].toString(),
              name: value['products'][i]['name'].toString(),
              category: value['products'][i]['category'].toString(),
              price: value['products'][i]['price'].toString()));
        }
      }
      ClientData.is0OrdersLoading = false;
    });
  }

  static Future loadAllClientData(String userId, String token) async {
    load0Orders(userId, token);
  }

  static void clearAllClientData() {
    is0OrdersLoading = true;
    is1IdentityLoading = true;
    is2InfoLoading = true;
    is3ClientLoading = true;
    is4ScoringLoading = true;
    is5RegistrationLoading = true;
    is6ContractLoading = true;
    is7ConfirmLoading = true;
    is8ScheduleLoading = true;
    is9DeliveryLoading = true;

    // 0: Orders
    amount = '0.00';
    count = '0.00';
    delivery = '0.00';
    total = '0.00';
    products = [];
  }
}
