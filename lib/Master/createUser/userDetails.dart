import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ticket_management_system/utils/colors.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key, required this.fullName});
  final String fullName;

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
    getUserDetails(widget.fullName).whenComplete(() => setState(() {
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
          : SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.75,
                child: Card(
                  color: Color.fromARGB(255, 249, 227, 253),
                  shadowColor: Colors.red,
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildProfile('First Name :', firstName),
                          // Text(
                          //   'First Name: $firstName',
                          //   style: const TextStyle(
                          //       fontSize: 16, color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 5,
                          // ),
                          buildProfile('Last Name :', lastName),
                          // Text(
                          //   'Last Name: $lastName',
                          //   style: const TextStyle(
                          //       fontSize: 16, color: Colors.black),
                          // ),

                          buildProfile('Mobile No :', mobile),
                          // Text(
                          //   'Mobile: $mobile',
                          //   style: const TextStyle(
                          //       fontSize: 16, color: Colors.black),
                          // ),

                          buildProfile('User Id :', userId),
                          // Text(
                          //   'User Id: ${widget.userId}',
                          //   style: const TextStyle(
                          //       fontSize: 16, color: Colors.black),
                          // ),
                          buildProfile('Password :', password),
                          // Text(
                          //   'Password: $password',
                          //   style: const TextStyle(
                          //       fontSize: 16, color: Colors.black),
                          // ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10, bottom: 60),
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                width: MediaQuery.of(context).size.width * 0.1,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 141, 36, 41),
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: const Center(
                                  child: Text(
                                    'Roles :',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.21,
                                width: 160,
                                // ignore: unnecessary_null_comparison
                                child: roleList != null
                                    ? ListView.builder(
                                        itemCount: roleList.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return SingleChildScrollView(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
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
                            ],
                          ),
                        ]),
                  ),
                ),
              ),
            ),
    );
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
                color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Future<void> getUserDetails(String fullName) async {
    DocumentSnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('members')
        .doc(fullName)
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
