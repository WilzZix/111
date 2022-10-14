import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLAPI extends StatefulWidget {
  const GraphQLAPI({Key? key}) : super(key: key);
  final title = 'GraphQL Demo';
  @override
  State<GraphQLAPI> createState() => _GraphQLAPIState();
}

class _GraphQLAPIState extends State<GraphQLAPI> {
  List<dynamic> characters = [];
  bool _loading = false;
  var statusCode;

  void fetchData() async {
    setState(() {
      _loading = true;
    });
    HttpLink link = HttpLink("https://rickandmortyapi.com/graphql");
    GraphQLClient qlClient = GraphQLClient(
      link: link,
      cache: GraphQLCache(
        store: HiveStore(),
      ),
    );
    QueryResult queryResult = await qlClient.query(
      QueryOptions(
        document: gql(
          """query {
  characters() {
    results {
      name
      image 
    }
  }
  
}""",
        ),
      ),
    );

    // queryResult.data  // contains data
// queryResult.exception // will give what exception you got /errors
// queryResult.hasException // you can check if you have any exception

// queryResult.context.entry<HttpLinkResponseContext>()?.statusCode  // to get status code of response
    setState(
      () {
        statusCode =
            queryResult.context.entry<HttpLinkResponseContext>()?.statusCode;
        characters = queryResult.data!['characters']['results'];
        _loading = false;

        // print(queryResult.data);
        print(characters);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ElevatedButton(
            child: const Text("Fetch Data"),
            onPressed: () {
              fetchData();
            },
          ),
          // if (!characters.isEmpty)
          //   Text(
          //     characters[1]['name'],
          //   ),
          const SizedBox(
            height: 20,
          ),
          if (!characters.isEmpty)
            Container(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                // shrinkWrap: true,
                itemCount: characters.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Image(
                        image: NetworkImage(
                          characters[index]['image'],
                        ),
                      ),
                      title: Text(
                        characters[index]['name'],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
