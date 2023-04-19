import 'package:cal/authentication/sign_up_page.dart';
import 'package:cal/constants.dart';
import 'package:cal/state_managers/data.dart';
import 'package:cal/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  signUserIn() {
    //show loading indicator
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: kDarkGreyColor,
              content: CupertinoActivityIndicator(
                color: Colors.grey[700],
              ),
            ));
    try {
      FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        snackbar('Error', 'Incorrect email ', true);
      } else if (e.code == 'wrong-password') {
        snackbar('Error', 'Incorrect password', true);
      } else {
        snackbar('Error', 'Incorrect password', true);
      }
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double systemWidth = MediaQuery.of(context).size.width;
    double systemHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              width: 300,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, bottom: 20),
                    child: Text(
                      'cal',
                      style: TextStyle(color: kThemeColor, fontSize: 30),
                    ),
                  ),
                  CupertinoTextField(
                    style: TextStyle(color: Colors.white),
                    controller: emailController,
                    placeholder: 'Email',
                    placeholderStyle: TextStyle(color: Colors.blueGrey),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: Colors.grey[800]!),
                        color: kDarkGreyColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CupertinoTextField(
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    controller: passwordController,
                    placeholder: 'Password',
                    placeholderStyle: TextStyle(color: Colors.blueGrey),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: Colors.grey[800]!),
                        color: kDarkGreyColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 8),
                    child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        color: Colors.transparent,
                        child: Text(
                          'Log In',
                        ),
                        onPressed: signUserIn),
                  ),
                  CupertinoButton(
                      padding: EdgeInsets.zero,
                      color: Colors.transparent,
                      child: Text(
                        'Don\'t have an account? Register now',
                        style: TextStyle(fontSize: 14, color: Colors.blue),
                      ),
                      onPressed: () {
                        Provider.of<Data>(context, listen: false)
                            .updateSigningChoice(false);
                      })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
