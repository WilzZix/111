import 'package:MyID/utils/constants.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../graphql_strings.dart' as gql_string;

Future<List> searchProducts({
  String? input,
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
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(
          gql_string.searchProductQuery, // let'see string
        ),
        variables: {
          "input": input,
        }),
  );
  return queryResult.data == null ? [] : queryResult.data?['searchProduct'];
}
