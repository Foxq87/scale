import 'package:cal/authentication/sign_in_page.dart';
import 'package:cal/constants.dart';
import 'package:cal/pages/home.dart';
import 'package:cal/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:provider/provider.dart';

import '../state_managers/data.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  signUserUp() {
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
      FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Future.delayed(const Duration(seconds: 5), () {
        String uid = FirebaseAuth.instance.currentUser!.uid;
        usersRef.doc(uid).set({
          "id": uid,
          "username": usernameController.text,
          "email": emailController.text,
          "password": passwordController.text,
          "creation": DateTime.now(),
          "topics": [],
          "imageUrl":
              "https://i.pinimg.com/474x/21/d2/9f/21d29f70c61cdfc6a90cf1e53004d22e.jpg"
        });
      });
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
                          border:
                              Border.all(width: 1, color: Colors.grey[800]!),
                          color: kDarkGreyColor),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CupertinoTextField(
                      style: TextStyle(color: Colors.white),
                      controller: usernameController,
                      placeholder: 'Username',
                      placeholderStyle: TextStyle(color: Colors.blueGrey),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(width: 1, color: Colors.grey[800]!),
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
                          border:
                              Border.all(width: 1, color: Colors.grey[800]!),
                          color: kDarkGreyColor),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, top: 8),
                      child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          color: Colors.transparent,
                          child: Text(
                            'Sign Up',
                          ),
                          onPressed: signUserUp),
                    ),
                    CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Text(
                          'Already have an account? Sign In',
                          style: TextStyle(fontSize: 14, color: Colors.blue),
                        ),
                        onPressed: () {
                          Provider.of<Data>(context, listen: false)
                              .updateSigningChoice(true);
                        })
                  ],
                ),
              ),
            ),
          ]),
    );
  }
}
