import 'package:graphql_flutter/graphql_flutter.dart';
import '../../constants.dart';
import '../graphql_strings.dart' as gql_string;

Future editClientInfo1(
    {String? address,
    String? cardDate,
    String? cartNumber,
    String? country,
    String? district,
    String? email,
    String? id,
    String? phoneFirst,
    String? phoneSecond,
    String? profileId,
    String? region,
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
          gql_string.editClientInfo,
        ),
        variables: {
          "id": id == null ? null : int.parse(id),
          "address": address,
          "cardDate": cardDate,
          "cardNumber": cartNumber,
          "country": country,
          "district": district,
          "email": email,
          "phoneFirst": phoneFirst,
          "phoneSecond": phoneSecond,
          "profileId": profileId == null ? null : int.parse(profileId),
          "region": region,
        }),
  );
  return queryResult.data?['editClientInfo'];
}
