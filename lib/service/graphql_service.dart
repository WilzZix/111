import 'package:MyID/service/shared_pref_service.dart';
import 'package:MyID/utils/constants.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphqlService {
  late GraphQLClient _client;

  // GraphqlService(){
  //   HttpLink link = HttpLink(Constants.URL, defaultHeaders: requestHeaders);
  //   _client =
  //       GraphQLClient(link: link, cache: GraphQLCache(store: HiveStore()));
  // }

  Future connectionService() async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${SharePrefService.getUserAccessToken()}'
    };
  }
}
