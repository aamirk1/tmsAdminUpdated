// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ticket_management_system/Homescreen.dart';
import 'package:ticket_management_system/Master/master.dart';
import 'package:ticket_management_system/Report/ticketTableReport.dart';
import 'package:ticket_management_system/screens/dashboard.dart';
import 'package:ticket_management_system/utils/colors.dart';

// ignore: camel_case_types, must_be_immutable
class customSide extends StatefulWidget {
  customSide({
    super.key,
  });

  @override
  State<customSide> createState() => _customSideState();
}

final String adminId = 'KM1737';

// ignore: camel_case_types
class _customSideState extends State<customSide> {
  List<String> userList = [];
  List<String> serviceProvider = [];

  List<String> tabTitle = [
    'Dashboard',
    'Master',
    'Reports',
  ];
  List<dynamic> tabIcon = [
    Icons.dashboard,
    Icons.house_rounded,
    Icons.house_outlined,
  ];
  List<bool> design = [
    true,
    false,
    false,
  ];

  int _selectedIndex = 0;

  List<Widget> pages = [];
  initState() {
    super.initState();
    fetchServiceProvider();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    pages = [
      const Dashboard(),
      MasterHomeScreen(adminId: 'KM1737'),
      TicketTableReport(serviceProvider: serviceProvider, userList: userList),
    ];
    return Scaffold(
      body: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 15),
            width: 150,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [lightMarron, marron])),
            child: Column(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Image.asset('assets/images/clgs.png'),
                ),
                SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.60,
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: tabIcon.length,
                        itemBuilder: (context, index) {
                          return customListTile(
                              tabTitle[index], tabIcon[index], index);
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 1.0, horizontal: 0.5),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: 100,
                    child: const Center(
                        child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            'T.M.S',
                            style: TextStyle(
                                color: white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Admin Panel',
                            style: TextStyle(
                                color: white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: pages[_selectedIndex])
        ],
      ),
    );
  }

  Widget customListTile(String title, dynamic icon, int index) {
    // final provider = Provider.of<NocManagementProvider>(context, listen: false);
    // final complaintProvider =
    //     Provider.of<ComplaintManagementProvider>(context, listen: false);
    return InkWell(
      onTap: () {
        // complaintProvider.setLoadWidget(false);
        // provider.setLoadWidget(false);
        setDesignBool();
        _selectedIndex = index;
        design[index] = !design[index];
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListTile(
          title: Icon(icon,
              size: 40,
              color: design[index]
                  ? const Color.fromARGB(223, 255, 251, 0)
                  : Colors.white),
          subtitle: Text(
            textAlign: TextAlign.center,
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  void setDesignBool() {
    List<bool> tempBool = [];
    for (int i = 0; i < 3; i++) {
      tempBool.add(false);
    }
    design = tempBool;
  }

  Widget getPage(int index) {
    if (index == 0) {
      return const Home();
    }
    return const Text('');
  }

// Function

  Future<void> fetchServiceProvider() async {
    try {
      // Clear existing data
      serviceProvider = [];

      // Fetch document IDs from 'members' collection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('members')
          .where('role', isNotEqualTo: null)
          .get();

      List<String> tempData = [];
      if (querySnapshot.docs.isNotEmpty) {
        tempData = querySnapshot.docs.map((e) => e.id).toList();
      }

      // Fetch each document and add to serviceProviders
      for (var id in tempData) {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('members')
            .doc(id)
            .get();

        if (documentSnapshot.exists) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;

          if (data.containsKey('role') &&
              // data['role'] is List &&
              data['role'].isNotEmpty) {
            if (data.containsKey('fullName')) {
              serviceProvider.add(data['fullName']);
            }
          }
        }
      }

      // Notify listeners after updating the list
      // notifyListeners();
    } catch (e) {
      // Handle any errors (optional)
      print('Error fetching service providers: $e');
    }
  }

  Future<void> fetchUser() async {
    try {
      // Clear existing data
      userList = [];

      // Fetch document IDs from 'members' collection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('members')
          .where('role', isEqualTo: null)
          .get();

      List<String> tempData = [];
      if (querySnapshot.docs.isNotEmpty) {
        tempData = querySnapshot.docs.map((e) => e.id).toList();
      }

      // Fetch each document and add to serviceProviders
      for (var id in tempData) {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('members')
            .doc(id)
            .get();

        if (documentSnapshot.exists) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;

          if (data.containsKey('role') &&
              data['role'] is List &&
              data['role'].isEmpty) {
            if (data.containsKey('fullName')) {
              userList.add(data['fullName']);
            }
          }
        }
      }

      // Notify listeners after updating the list
      // notifyListeners();
    } catch (e) {
      // Handle any errors (optional)
      print('Error fetching user: $e');
    }
  }
}
