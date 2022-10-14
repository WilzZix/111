import 'package:graphql_flutter/graphql_flutter.dart';
import '../../constants.dart';
import '../graphql_strings.dart' as gql_string;

Future addCode({String? code, String? tokenFromLocaleStorage}) async {
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${tokenFromLocaleStorage}'
  };

  HttpLink link = HttpLink(Constants.URL, defaultHeaders: requestHeaders);
  GraphQLClient qlClient = GraphQLClient(
    link: link,
    cache: GraphQLCache(
      store: HiveStore(),
    ),
  );
  QueryResult queryResult = await qlClient.mutate(
    MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(
          gql_string.addMyCode,
        ),
        variables: {
          "code": code,
        }),
  );
  print(
      '--- queryResult --------------------: ${queryResult.data?['getClientData']['data']}');
  return queryResult.data?['getClientData']['data'];
}
