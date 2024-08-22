import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ticket_management_system/auth/login.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController adminIDController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.purple,
        title: const Text(
          "Forgot Passowrd",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.5,
            child: Card(
              elevation: 30,
              child: Form(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: adminIDController,
                      decoration: InputDecoration(
                          labelText: 'Admin ID',
                          // hintText: 'Enter your adminID',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.deepPurple))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your admin id';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple),
                      onPressed: () {
                        retrivePassword(adminIDController.text, context);
                      },
                      child: const Text(
                        "Retrive Password",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ))
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> retrivePassword(String adminID, BuildContext context) async {
    try {
      final adminDoc = await firestore.collection('admins').doc(adminID).get();
      if (adminDoc.exists) {
        final password = adminDoc.data()!['password'];
        showDialog(
            // ignore: use_build_context_synchronously
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Password Retrived'),
                content: Row(
                  children: [
                    const Text('Your Password is:  '),
                    Text(
                      '$password',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text("Back to Login"))
                ],
              );
            });
      } else {
        SnackBar snackBar = const SnackBar(
          backgroundColor: Colors.red,
          content: Center(
            child: Text('Admin does not exist'),
          ),
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      SnackBar snackBar = const SnackBar(
          backgroundColor: Colors.red,
          content: Center(
            child: Text('An error occured. Please try again.'),
          ));
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
