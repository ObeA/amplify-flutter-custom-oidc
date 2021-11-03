import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';

import 'amplifyconfiguration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    // Add the following line to add API plugin to your app
    Amplify.addPlugin(AmplifyAPI(authProviders: const [CustomOIDCProvider()]));

    try {
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      print(
          "Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    }
  }

  _fetchItems() async {
    try {
      String graphQLDocument = '''query ListTodos {
        listTodos {
          items {
            id
            name
            description
          }
          nextToken
        }
      }''';

      var operation = Amplify.API.query(
          request: GraphQLRequest<String>(
        document: graphQLDocument,
      ));

      var response = await operation.response;
      var data = response.data;

      print('Query result: ' + data);
    } on ApiException catch (e) {
      print('Query failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Center(
      child: ElevatedButton(
          onPressed: () => _fetchItems(), child: const Text('Fetch items')),
    ));
  }
}

class CustomOIDCProvider extends OIDCAuthProvider {
  const CustomOIDCProvider();

  @override
  Future<String?> getLatestAuthToken() async {
    // This is never called
    return 'some token';
  }
}
