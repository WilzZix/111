import 'package:graphql_flutter/graphql_flutter.dart';
import '../../constants.dart';
import '../graphql_strings.dart' as gql_string;

Future<Map> getAutoPayStatusLogik({
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
    QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(
          gql_string.getAutoPayStatusItem, // let'see string
        ),
        variables: {
          "claimsId": double.parse(id!),
        }),
  );
  print(id);
  return queryResult.data == null ? {} : queryResult.data?['getAutoPayStatus'];
}
