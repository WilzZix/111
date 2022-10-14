import 'package:MyID/utils/constants.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../graphql_strings.dart' as gql_string;

Future deleteProduct1(
    {String? claimsId,
    String? productId,
    String? tokenFromLocaleStorage}) async {
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
    ),
  );
  QueryResult queryResult = await qlClient.mutate(
    // mutate method , as we are mutating value
    MutationOptions(
        // mutation options
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(
          gql_string.deleteProduct,
        ),
        variables: {
          "claimsId": claimsId == null ? null : int.parse(claimsId),
          "productId": productId == null ? null : int.parse(productId),
        }),
  );
  return queryResult.data == null ? {} : queryResult.data?['removeProduct'];
}
