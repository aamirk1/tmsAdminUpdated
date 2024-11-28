import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ticket_management_system/profile/changePassword.dart';
import 'package:ticket_management_system/utils/colors.dart';
import 'package:ticket_management_system/utils/loading_page.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.adminId});
  final String adminId;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String firstName = '';
  String lastName = '';
  String mobile = '';
  String adminId = '';
  bool isLoading = true;
  bool isShowChangeScreen = false;
  @override
  void initState() {
    super.initState();
    getProfile(widget.adminId).whenComplete(() => setState(() {
          isLoading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        // backgroundColor: const Color.fromARGB(255, 196, 196, 196),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [lightMarron, marron])),
        ),
      ),
      body: isLoading
          ? const Center(
              child: LoadingPage(),
            )
          : Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.15),
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.55,
                              child: Card(
                                elevation: 10,
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Column(
                                    children: [
                                      const Center(
                                        child: Text(
                                          'My Profile',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: []),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              isShowChangeScreen =
                                                  !isShowChangeScreen;
                                            });
                                          },
                                          child: const Text('Change Password'))
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
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: 500,
                    child: isShowChangeScreen
                        ? ChangePassword(adminId: adminId)
                        : Container(),
                  ),
                ),
              ],
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
}
