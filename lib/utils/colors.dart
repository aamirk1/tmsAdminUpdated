import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/material.dart';
import 'package:ticket_management_system/auth/login.dart';
import 'package:ticket_management_system/splash_screen/splash_service.dart';
import 'package:ticket_management_system/utils/loading_page.dart';

const white = Colors.white;
const black = Colors.black;
const purple = Colors.purple;
const marron = Color.fromARGB(223, 97, 4, 4);
const lightMarron = Color.fromARGB(223, 252, 169, 169);
Future<void> signOut(context) async {
//  await FirebaseAuth.instance.signOut();
  await FirebaseAuth.instance.signOut().whenComplete(() {
    SplashService().removeLogin(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  });
}

void showFetchingData(BuildContext context, String msg) {
  cupertino.showCupertinoDialog(
    context: context,
    builder: (context) => cupertino.CupertinoAlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
            width: 50,
            child: Center(
              child: LoadingPage(),
            ),
          ),
          Text(
            msg,
            style: const TextStyle(
                color: Color.fromARGB(255, 151, 64, 69),
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          )
        ],
      ),
    ),
  );
}
