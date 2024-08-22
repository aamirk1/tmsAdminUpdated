import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_management_system/providers/userProvider.dart';
import 'package:ticket_management_system/providers/workProvider.dart';
import 'package:ticket_management_system/utils/colors.dart';

class EditWorkForm extends StatefulWidget {
  const EditWorkForm({super.key, required this.workId});
  final String workId;

  @override
  State<EditWorkForm> createState() => _EditWorkFormState();
}

class _EditWorkFormState extends State<EditWorkForm> {
  TextEditingController workController = TextEditingController();

  bool isLoading = true;
  List<String> workList = [];
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    workController.text = widget.workId;
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Center(
              child: Text('Work Form', style: TextStyle(color: Colors.white))),
          flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
            colors: [ lightMarron,
                  marron],
          )))),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          height: MediaQuery.of(context).size.height * 0.50,
          width: MediaQuery.of(context).size.width * 0.50,
          child: Card(
            elevation: 10,
            child: Container(
              margin: EdgeInsets.only(top: 50),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          child: Container(
                            color: Colors.white,
                            height: 60,
                            width: MediaQuery.of(context).size.width * 0.30,
                            child: TextFormField(
                              textInputAction: TextInputAction.done,
                              expands: true,
                              maxLines: null,
                              controller: workController,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                hintText: 'Update Work',
                                hintStyle: const TextStyle(fontSize: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.30,
                                45,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              updateData(widget.workId, workController.text)
                                  .whenComplete(() async {
                                await popupmessage(
                                    'Work Updated successfully!!');
                              });
                            }
                          },
                          child: const Center(
                            child: Text(
                              'Update Work',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future updateData(String oldDocumentId, String newDocumentId) async {
    final provider = Provider.of<AllWorkProvider>(context, listen: false);

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('works')
        .doc(oldDocumentId)
        .get();
    if (snapshot.exists) {
      await FirebaseFirestore.instance
          .collection('works')
          .doc(newDocumentId)
          .set({
        'work': newDocumentId,
      });
      provider.addSingleList({
        'work': newDocumentId,
      });
      // print("Document updated successfully");
    } else {
      print("Document does not exist");
    }
  }

  Future<void> deleteOldData(String oldDocumentId) async {
    final provider = Provider.of<AllWorkProvider>(context, listen: false);
    await FirebaseFirestore.instance
        .collection('works')
        .doc(oldDocumentId)
        .delete();
    provider.removeData(provider.workList.indexOf(oldDocumentId));
  }

  Future<void> popupmessage(String msg) async {
    final provider = Provider.of<AllUserProvider>(context, listen: false);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: AlertDialog(
              content: Text(
                msg,
                style: const TextStyle(fontSize: 14, color: Colors.green),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      deleteOldData(widget.workId);
                      workController.clear();
                      Navigator.pop(context);
                      Navigator.pop(context);
                      provider.setLoadWidget(false);
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.green),
                    ))
              ],
            ),
          );
        });
  }
}
