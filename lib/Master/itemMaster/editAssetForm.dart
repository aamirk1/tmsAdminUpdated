import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_management_system/providers/assetsProvider.dart';
import 'package:ticket_management_system/providers/userProvider.dart';
import 'package:ticket_management_system/utils/colors.dart';

class EditAssetForm extends StatefulWidget {
  const EditAssetForm({super.key, required this.assetId});
  final String assetId;

  @override
  State<EditAssetForm> createState() => _EditAssetFormState();
}

class _EditAssetFormState extends State<EditAssetForm> {
  TextEditingController assetController = TextEditingController();

  bool isLoading = true;
  List<String> assetList = [];
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    assetController.text = widget.assetId;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Center(
            child: Text('Asset Form', style: TextStyle(color: Colors.white))),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [lightMarron, marron],
            ),
          ),
        ),
      ),
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
                              textInputAction: TextInputAction.next,
                              expands: true,
                              maxLines: null,
                              controller: assetController,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                hintText: 'Update Asset',
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
                              backgroundColor: lightMarron,
                              fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.30,
                                45,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              updateData(widget.assetId, assetController.text)
                                  .whenComplete(() async {
                                await popupmessage(
                                    'Asset Updated successfully!!');
                              });
                            }
                          },
                          child: const Center(
                            child: Text(
                              'Update Asset',
                              style: TextStyle(
                                  color: marron,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
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
    final provider = Provider.of<AllAssetProvider>(context, listen: false);

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('assets')
        .doc(oldDocumentId)
        .get();
    if (snapshot.exists) {
      await FirebaseFirestore.instance
          .collection('assets')
          .doc(newDocumentId)
          .set({
        'asset': newDocumentId,
      });
      provider.addSingleList({
        'asset': newDocumentId,
      });
      // print("Document updated successfully");
    } else {
      print("Document does not exist");
    }
  }

  Future<void> deleteOldData(String oldDocumentId) async {
    final provider = Provider.of<AllAssetProvider>(context, listen: false);
    await FirebaseFirestore.instance
        .collection('assets')
        .doc(oldDocumentId)
        .delete();
    provider.removeData(provider.assetList.indexOf(oldDocumentId));
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
                      deleteOldData(widget.assetId);
                      assetController.clear();
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
