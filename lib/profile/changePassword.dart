import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ticket_management_system/utils/colors.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key, required this.adminId});
  final String adminId;

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Center(
                            child: Text(
                              'Change Password',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Form(
                              key: _formKey,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextFormField(
                                        controller: oldPasswordController,
                                        decoration: const InputDecoration(
                                          border: UnderlineInputBorder(),
                                          labelText: 'Enter Old Password',
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                        controller: newPasswordController,
                                        decoration: const InputDecoration(
                                          border: UnderlineInputBorder(),
                                          labelText: 'Enter New Password',
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Center(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: marron,
                                          ),
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              updatePassword(
                                                oldPasswordController.text,
                                                newPasswordController.text,
                                                widget.adminId,
                                              );
                                            }
                                          },
                                          child: const Text(
                                            'Change Password',
                                            style: TextStyle(
                                                color: white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )
                                    ]),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updatePassword(
      String oldPassword, String newPassword, String adminId) async {
    FirebaseFirestore instance = FirebaseFirestore.instance;
    DocumentSnapshot admin =
        await instance.collection('admins').doc(adminId).get();
    if (admin.exists) {
      if (oldPassword == admin['password']) {
        await instance
            .collection('admins')
            .doc(adminId)
            .update({'password': newPassword});
        Navigator.pop(context);
        SnackBar snackBar = const SnackBar(
          backgroundColor: Colors.green,
          content: Center(child: Text('Password Updated Successfully')),
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        SnackBar snackBar = const SnackBar(
          backgroundColor: Colors.red,
          content: Center(child: Text('Invalid Old Password')),
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      SnackBar snackBar = const SnackBar(
        backgroundColor: Colors.red,
        content: Center(child: Text('Invalid Admin Id')),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
