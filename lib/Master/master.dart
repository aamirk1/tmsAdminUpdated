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
}
