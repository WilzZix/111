import 'package:MyID/utils/constants.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql_strings.dart' as gql_string;

Future<List> getUser({
  int? page,
  int? size,
  String? keyword,
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
          gql_string.getAllUsersQuery, // let'see string
        ),
        variables: {
          "page": page,
          "size": size,
          "keyword": keyword,
        }),
  );

  return queryResult.data == null
      ? []
      : queryResult.data?['getClaimsList']['data']['list'];
  // i am getting json respone in getUserInfo which i am returning
}
