import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/providers/location_provider.dart';
import 'package:travel_app/services/user_service.dart';
import 'package:travel_app/views/screens/homescreen.dart';
import 'package:travel_app/views/screens/welcome_screen.dart';

void main() {
  const apiKey = String.fromEnvironment('apiKey');
  if (apiKey.isEmpty) {
    print('API Key is missing. Please set the apiKey environment variable.');
    return;
  }

  Gemini.init(apiKey: apiKey, enableDebugging: true);
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => LocationProvider()),
    ], child: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travel App',
      theme: ThemeData(primarySwatch: Colors.deepOrange, useMaterial3: true),
      home: FutureBuilder<String?>(
        future: UserService().getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.isNotEmpty) {
            return const HomeScreen();
          } else {
            return WelcomeScreen();
          }
        },
      ),
    );
  }
}
