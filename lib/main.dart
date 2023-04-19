import 'package:cal/authentication/auth_page.dart';
import 'package:cal/pages/home.dart';
import 'package:cal/state_managers/data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options:DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChangeNotifierProvider(
    create: (BuildContext context) {
      return Data();
    },
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        cupertinoOverrideTheme:
            NoDefaultCupertinoThemeData(primaryColor: kThemeColor),
        primaryColor: kDarkGreyColor,
      ),
      home: const AuthPage(),
    );
  }
}
