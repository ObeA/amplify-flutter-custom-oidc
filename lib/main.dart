import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_flutter_custom_oidc/models/ModelProvider.dart';
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
  final AmplifyAPI _apiPlugin =
      AmplifyAPI(authProviders: const [CustomOIDCProvider()]);
  final AmplifyDataStore _dataStorePlugin =
      AmplifyDataStore(modelProvider: ModelProvider.instance);

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    Amplify.addPlugins([_apiPlugin, _dataStorePlugin]);

    try {
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      print(
          "Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    }
  }

  Future<void> _fetchTodos() async {
    try {
      List<Todo> updatedTodos = await Amplify.DataStore.query(Todo.classType);
      print("Query results: $updatedTodos");
    } catch (e) {
      throw Exception('An error occurred while querying Todos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Center(
      child: ElevatedButton(
          onPressed: () => _fetchTodos(), child: const Text('Fetch items')),
    ));
  }
}

class CustomOIDCProvider extends OIDCAuthProvider {
  const CustomOIDCProvider();

  @override
  Future<String?> getLatestAuthToken() async {
    return 'some token';
  }
}
