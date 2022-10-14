// import 'package:MyID/utils/constants.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
// import '../graphql_strings.dart' as gql_string;

// Future<List> getNotes({
//   String? id,
//   String? tokenFromLocaleStorage,
// }) async {
//   Map<String, String> requestHeaders = {
//     'Content-type': 'application/json',
//     'Accept': 'application/json',
//     'Authorization': 'Bearer ${tokenFromLocaleStorage}'
//   };
//   HttpLink link =
//       HttpLink(Constants.URL, defaultHeaders: requestHeaders); // same link
//   GraphQLClient qlClient = GraphQLClient(
//     link: link,
//     cache: GraphQLCache(
//       store: HiveStore(),
//     ), // cache
//   );
//   QueryResult queryResult = await qlClient.query(
//     // this is get so query methos
//     QueryOptions(
//         // one more thing if you notice  here when we use query method
//         //  we use QueryOptions , for mutate
//         fetchPolicy: FetchPolicy.networkOnly,
//         document: gql(
//           gql_string.getMerchNotes, // let'see string
//         ),
//         variables: {
//           "claimsId_inpt": id == null ? null : int.parse(id),
//         }),
//   );
//   print('queryResult.data ${queryResult.data}');
//   print('id ${id}');
//   return queryResult.data == null
//       ? []
//       : queryResult.data?['getMerchNotes']['data'];
//   // i am getting json respone in getUserInfo which i am returning
// }

import 'package:MyID/utils/constants.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql_strings.dart' as gql_string;

Future<Map> getNotes({
  String? id,
  String? tokenFromLocaleStorage,
}) async {
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${tokenFromLocaleStorage}'
  };
  HttpLink link =
      HttpLink(Constants.URL, defaultHeaders: requestHeaders); // same link
  GraphQLClient qlClient = GraphQLClient(
    link: link,
    cache: GraphQLCache(
      store: HiveStore(),
    ), // cache
  );
  QueryResult queryResult = await qlClient.query(
    // this is get so query methos
    QueryOptions(
        // one more thing if you notice  here when we use query method
        //  we use QueryOptions , for mutate
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(
          gql_string.getMerchNotes, // let'see string
        ),
        variables: {
          "claimsId_inpt": id == null ? null : int.parse(id),
        }),
  );
  // print('queryResult.data ${queryResult.data}');
  // print('id ${id}');
  return queryResult.data == null ? [] : queryResult.data?['getMerchNotes'];
  // i am getting json respone in getUserInfo which i am returning
}
