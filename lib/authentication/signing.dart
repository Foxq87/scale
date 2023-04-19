import 'package:cal/authentication/sign_in_page.dart';
import 'package:cal/authentication/sign_up_page.dart';
import 'package:cal/state_managers/data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Signing extends StatefulWidget {
  const Signing({super.key});

  @override
  State<Signing> createState() => _SigningState();
}

class _SigningState extends State<Signing> {
  @override
  Widget build(BuildContext context) {
    if (Provider.of<Data>(context).logIn) {
      return SignIn();
    } else {
      return Register();
    }
  }
}
