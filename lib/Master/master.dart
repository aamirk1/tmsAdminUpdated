import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ticket_management_system/Master/createUser/createUser.dart';
import 'package:ticket_management_system/Master/itemMaster/itemMaster.dart';
import 'package:ticket_management_system/Master/work/listOfWork.dart';
import 'package:ticket_management_system/utils/colors.dart';

// ignore: must_be_immutable
class MasterHomeScreen extends StatefulWidget {
  MasterHomeScreen({super.key, required this.adminId});
  String adminId;
  @override
  State<MasterHomeScreen> createState() => _MasterHomeScreenState();
}

class _MasterHomeScreenState extends State<MasterHomeScreen> {
  bool isUserScreen = false;
  bool isWorkScreen = false;
  bool isItemMasterScreen = false;
  String firstName = '';
  String lastName = '';
  String mobile = '';
  String adminId = '';
  @override
  void initState() {
    getProfile(widget.adminId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Master',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 196, 196, 196),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [lightMarron, marron])),
        ),
        actions: [
          IconButton(
            onPressed: () {
              profilePopup();
            },
            icon: const Icon(
              Icons.supervised_user_circle_sharp,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(marron),
                          minimumSize: WidgetStatePropertyAll(Size(300, 50))),
                      onPressed: () {
                        setState(() {
                          isWorkScreen = false;
                          isItemMasterScreen = false;
                          isUserScreen = !isUserScreen;
                        });
                      },
                      child: const Text(
                        'Create User',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )),
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(marron),
                          minimumSize: WidgetStatePropertyAll(Size(300, 50))),
                      onPressed: () {
                        setState(() {
                          isUserScreen = false;
                          isItemMasterScreen = false;
                          isWorkScreen = !isWorkScreen;
                        });
                      },
                      child: const Text(
                        'Work List',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )),
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(marron),
                          minimumSize: WidgetStatePropertyAll(Size(300, 50))),
                      onPressed: () {
                        setState(() {
                          isUserScreen = false;
                          isWorkScreen = false;
                          isItemMasterScreen = !isItemMasterScreen;
                        });
                      },
                      child: const Text(
                        'Item Master',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width * 0.99,
              child: isUserScreen
                  ? const CreateUser(adminId: 'adminId')
                  : isWorkScreen
                      ? const ListOfWork()
                      : isItemMasterScreen
                          ? AllItemMaster(
                              adminId: '',
                            )
                          : Container(),
            )
          ],
        ),
      ),
    );
  }

  Future<void> getProfile(String adminId) async {
    DocumentSnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('admins')
        .doc(adminId)
        .get();
    if (querySnapshot.exists && querySnapshot.data() != null) {
      Map<String, dynamic> data = querySnapshot.data() as Map<String, dynamic>;
      firstName = data['firstName'] ?? '';
      lastName = data['lastName'] ?? '';
      mobile = data['mobile'] ?? '';
      adminId = data['adminId'] ?? '';
    }

    setState(() {});
  }

  void profilePopup() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            alignment: Alignment.topRight,
            shape: const BeveledRectangleBorder(),
            content: Container(
              // margin: const EdgeInsets.only(top: 20),
              height: MediaQuery.of(context).size.height * 0.4,
              child: Align(
                alignment: Alignment.center,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildProfile('First Name :', firstName),
                      buildProfile('Last Name :', lastName),
                      buildProfile('Mobile No :', mobile),
                      buildProfile('Admin Id:', widget.adminId),
                    ]),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Back',
                    style: TextStyle(color: marron),
                  ))
            ],
          );
        });
  }

  Widget buildProfile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IntrinsicWidth(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.1,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 141, 36, 41),
                  borderRadius: BorderRadius.circular(8.0)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Center(
                  child: Text(
                    label,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 40),
          Text(
            value.isEmpty ? 'N/A' : value,
            style: const TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
