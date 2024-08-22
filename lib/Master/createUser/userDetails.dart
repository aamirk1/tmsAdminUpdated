import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ticket_management_system/utils/colors.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key, required this.userId});
  final String userId;

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  String firstName = '';
  String lastName = '';
  String mobile = '';
  String userId = '';
  String password = '';
  List<dynamic> role = [];
  List<dynamic> roleList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getUserDetails(widget.userId).whenComplete(() => setState(() {
          isLoading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.75,
              child: Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'First Name: $firstName',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Last Name: $lastName',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Mobile: $mobile',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'User Id: ${widget.userId}',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Password: $password',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            'Roles',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          SizedBox(
                            height: 130,
                            width: 250,
                            // ignore: unnecessary_null_comparison
                            child: roleList != null
                                ? ListView.builder(
                                    itemCount: roleList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: SizedBox(
                                            height: 25,
                                            child: ListTile(
                                              title: RichText(
                                                  text: TextSpan(children: [
                                                TextSpan(
                                                  text:
                                                      '${index + 1}. ${roleList[index]}',
                                                  style: const TextStyle(
                                                      color: black),
                                                ),
                                              ])),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : const Text(
                                    'No Roles',
                                    style: TextStyle(color: black),
                                  ),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> getUserDetails(String userId) async {
    DocumentSnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('members')
        .doc(userId)
        .get();
    if (querySnapshot.exists && querySnapshot.data() != null) {
      Map<String, dynamic> data = querySnapshot.data() as Map<String, dynamic>;
      firstName = data['fName'] ?? '';
      lastName = data['lName'] ?? '';
      mobile = data['mobile'] ?? '';
      userId = data['userId'] ?? '';
      password = data['password'] ?? '';
      role = data['role'] ?? 'No Roles';
    }
    setState(() {});
    roleList = role;
  }
}
