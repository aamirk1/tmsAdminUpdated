import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ticket_management_system/Report/refreshScreen.dart';
import 'package:ticket_management_system/Report/reportDetails.dart';
import 'package:ticket_management_system/providers/buildingProvider.dart';
import 'package:ticket_management_system/providers/floorProvider.dart';
import 'package:ticket_management_system/providers/roomProvider.dart';
import 'package:ticket_management_system/providers/workProvider.dart';
import 'package:ticket_management_system/utils/colors.dart';
import 'package:ticket_management_system/utils/loading_page.dart';

import '../providers/assetsProvider.dart';

// ignore: must_be_immutable
class TicketTableReport extends StatefulWidget {
  TicketTableReport(
      {super.key,
      required this.serviceProvider,
      required this.userList,
      required this.buildings,
      required this.floors,
      required this.rooms,
      required this.assets});
  List<String> userList = [];
  List<String> serviceProvider = [];
  List<String> buildings = [];
  List<String> floors = [];
  List<String> rooms = [];
  List<String> assets = [];
  @override
  State<TicketTableReport> createState() => _TicketTableReportState();
}

class _TicketTableReportState extends State<TicketTableReport> {
  TextEditingController assetController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController workController = TextEditingController();
  TextEditingController floorController = TextEditingController();
  TextEditingController roomController = TextEditingController();
  TextEditingController buildingController = TextEditingController();
  TextEditingController ticketController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  List<String> buildingList = [];
  List<dynamic> filterData = [];
  List<String> floorList = [];
  List<String> roomList = [];
  List<String> assetList = [];
  List<String> userList = [];
  List<String> allTicketList = [];
  List<String> workList = [];
  List<String> uniqueFloorList = [];
  String? selectedAsset;
  String? selectedFloor;
  String? selectedRoom;
  String selectedStartDate = '';
  String selectedEndDate = '';
  String? selectedUser;
  String? selectedTicket;
  String? selectedbuilding;
  String? selectedWork;
  String? selectedStatus;

  String asset = '';
  String building = '';
  String floor = '';
  String remark = '';
  String room = '';
  String work = '';
  String serviceprovider = '';
  String tickets = '';

  List<String> floorNumberList = [];
  List<dynamic> allData = [];
  List<dynamic> serviceProviderList = [];
  String? selectedTicketNumber;
  List<String> buildingNumberList = [];
  List<String> allFloorData = [];
  List<String> allWorkData = [];
  List<String> allRoomData = [];
  List<String> allStatusData = ['Open', 'Close'];

  List<dynamic> ticketList = [];

  List<String> serviceProvider = [];
  List<String>? selectedSPList = [];

  String? selectedServiceProvider;
  List<String> roomNumberList = [];
  List<String> ticketNumberList = [];
  bool isLoading = true;
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(2020, 01, 01),
    end: DateTime(2025, 01, 01),
  );

  DateTime rangeStartDate = DateTime.now();
  DateTime? rangeEndDate = DateTime.now();
  @override
  void initState() {
    getTicketList().whenComplete(() {
      setState(() {});
    });
    // fetchServiceProvider();
    // fetchUser();

    getWorkList();

    getRoom();
    getAsset();

    setState(() {
      isLoading = false;
    });

    super.initState();
  }

  TextEditingController ticketnumberController = TextEditingController();
  TextEditingController serviceProviderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'All Tickets Report',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        //  backgroundColor: Colors.deepPurple,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [lightMarron, marron])),
        ),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 20),
        //     child: IconButton(
        //         onPressed: () {
        //           signOut(context);
        //         },
        //         icon: const Icon(
        //           Icons.power_settings_new_outlined,
        //           size: 30,
        //           color: white,
        //         )),
        //   )
        // ],
      ),
      body: isLoading
          ? const Center(child: LoadingPage())
          : SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: customDropDown('Select Status', allStatusData,
                              "Search Status", 8),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: customDropDown(
                            'Select Ticket Number',
                            ticketList.map((e) => e.toString()).toList(),
                            "Search Ticket Number",
                            1,
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                                elevation: 5,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 245,
                                      height: 50,
                                      child: TextButton(
                                        onPressed: () {
                                          pickDateRange();
                                          setState(() {});
                                        },
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            // Text(
                                            //   textAlign: TextAlign.justify,
                                            //   'Search Date: \n $selectedDate',
                                            //   style: const TextStyle(
                                            //       color: Colors.black,
                                            //       fontSize: 16),
                                            // ),
                                            child: RichText(
                                                text: TextSpan(
                                                    text: 'Search Date: \n',
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                    children: [
                                                  TextSpan(
                                                      text: selectedStartDate
                                                              .isNotEmpty
                                                          ? " $selectedStartDate TO $selectedEndDate  "
                                                          : '',
                                                      style: const TextStyle(
                                                          backgroundColor:
                                                              marron,
                                                          color: Colors.white)),
                                                ])),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const Refreshscreen()))
                                                  .whenComplete(() {
                                                selectedStartDate = '';
                                                selectedEndDate = '';
                                                setState(() {});
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.clear,
                                              size: 15,
                                            )))
                                  ],
                                ))),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: customDropDown(
                            'Select Work',
                            allWorkData,
                            "Search Work",
                            9,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: customDropDown('Select Building',
                              widget.buildings, "Search Building Number", 2),
                        ),
                      ]),
                      Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: customDropDown('Select Floor', widget.floors,
                              "Search Floor Number", 3),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: customDropDown(
                              'Select Room', roomList, "Search Room Number", 4),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: customDropDown(
                              'Select Asset', assetList, "Search Asset", 6),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: customDropDown(
                              'Select User', widget.userList, "Search User", 5),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: customDropDown(
                              'Select Service Provider',
                              widget.serviceProvider,
                              "Search Service Provider",
                              7),
                        ),
                      ]),
                    ],
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.20,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: Row(
                          children: [
                            ElevatedButton(
                              style: const ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(marron),
                              ),
                              onPressed: () {
                                showFetchingData(context, 'Fetching Data...');

                                filterTickets().whenComplete(() {
                                  if (kDebugMode) {
                                    print(
                                        'selectedServiceProvider: $selectedServiceProvider');
                                  }
                                  if (selectedStatus != null ||
                                      selectedTicket != null ||
                                      selectedWork != null ||
                                      selectedbuilding != null ||
                                      selectedFloor != null ||
                                      selectedRoom != null ||
                                      selectedAsset != null ||
                                      selectedUser != null ||
                                      selectedServiceProvider != null ||
                                      selectedStartDate.isNotEmpty ||
                                      selectedEndDate.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return ReportDetails(
                                          ticketData: filterData,
                                        );
                                      }),
                                    ).whenComplete(() {
                                      getTicketList().whenComplete(() {
                                        setState(() {});
                                      });
                                      fetchServiceProvider();
                                      fetchUser();

                                      getBuilding().whenComplete(() {
                                        getFloor().whenComplete(() {
                                          getRoom().whenComplete(() {
                                            getAsset().whenComplete(() {
                                              setState(() {});
                                            });
                                          });
                                        });
                                      });
                                      clearSelectdData();
                                      setState(() {});
                                      Navigator.pop(context);
                                    });
                                  } else {
                                    popupAlertmessage(
                                        'Please select any filter');
                                  }
                                });
                              },
                              child: const Text(
                                'Get Report',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              style: const ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(marron),
                              ),
                              onPressed: () {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Refreshscreen()))
                                    .whenComplete(() {
                                  selectedWork = null;
                                  selectedServiceProvider = null;
                                  selectedStatus = null;
                                  selectedAsset = null;
                                  selectedUser = null;
                                  selectedRoom = null;
                                  selectedFloor = null;
                                  selectedbuilding = null;
                                  selectedTicket = null;
                                  selectedStartDate = '';
                                  selectedEndDate = '';
                                  ticketList.clear();
                                  filterData.clear();
                                  setState(() {});
                                });
                              },
                              child: const Text(
                                'Refresh',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  void popupAlertmessage(String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: AlertDialog(
              content: Text(
                msg,
                style: const TextStyle(fontSize: 14, color: Colors.red),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.black),
                    ))
              ],
            ),
          );
        });
  }

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
  // Future<void> fetchUser() async {
  //   userList = [];
  //   final provider = Provider.of<AllUserProvider>(context, listen: false);
  //   List<String> tempData = [];
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection('members')
  //       .where('role', isEqualTo: null)
  //       .get();

  //   if (querySnapshot.docs.isNotEmpty) {
  //     tempData = querySnapshot.docs.map((e) => e.id).toList();
  //   }
  //   for (var i = 0; i < tempData.length; i++) {
  //     DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
  //         .collection('members')
  //         .doc(tempData[i])
  //         .get();
  //     if (documentSnapshot.data() != null) {
  //       Map<String, dynamic> data =
  //           documentSnapshot.data() as Map<String, dynamic>;
  //       String fullName = data['fullName'];
  //       // print(fullName);
  //       userList.add(fullName);
  //     }
  //   }
  //   print('user $userList');
  //   provider.setBuilderList(userList);
  // }

  // Future<void> fetchServiceProvider() async {
  //   serviceProvider = [];
  //   List<String> tempData = [];
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection('members')
  //       .where('role', isNotEqualTo: null)
  //       .get();

  //   if (querySnapshot.docs.isNotEmpty) {
  //     tempData = querySnapshot.docs.map((e) => e.id).toList();
  //   }
  //   for (var i = 0; i < tempData.length; i++) {
  //     DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
  //         .collection('members')
  //         .doc(tempData[i])
  //         .get();
  //     if (documentSnapshot.data() != null) {
  //       Map<String, dynamic> data =
  //           documentSnapshot.data() as Map<String, dynamic>;
  //       serviceProvider.add(data['fullName']);
  //     }
  //   }
  //   print('service provider $serviceProvider');
  //   setState(() {});
  // }

  // Future<void> getTicketList() async {
  //   final provider = Provider.of<AllRoomProvider>(context, listen: false);
  //   provider.setBuilderList([]);

  //   ticketList.clear();

  //   QuerySnapshot monthQuery =
  //       await FirebaseFirestore.instance.collection("raisedTickets").get();
  //   List<dynamic> dateList = monthQuery.docs.map((e) => e.id).toList();

  //   // dateList = dateList.reversed.toList();
  //   for (int j = 0; j < dateList.length; j++) {
  //     List<String> temp = [];
  //     QuerySnapshot ticketQuery = await FirebaseFirestore.instance
  //         .collection("raisedTickets")
  //         .doc(dateList[j])
  //         .collection('tickets')
  //         .get();
  //     temp = ticketQuery.docs.map((e) => e.id).toList();
  //     temp = temp.reversed.toList();
  //     ticketList = ticketList + temp;
  //     // ticketList.sort((a, b) {
  //     //   DateTime dateA = parseDate(a['date']); // Parse date from mapData
  //     //   DateTime dateB = parseDate(b['date']);
  //     //   return dateA.compareTo(dateB); // Descending order
  //     // });
  //   }

  //   setState(() {});
  // }
  Future<void> getTicketList() async {
    final provider = Provider.of<AllRoomProvider>(context, listen: false);
    provider.setBuilderList([]);

    ticketList.clear();

    QuerySnapshot monthQuery =
        await FirebaseFirestore.instance.collection("raisedTickets").get();
    List<dynamic> dateList = monthQuery.docs.map((e) => e.id).toList();

    for (int j = 0; j < dateList.length; j++) {
      List<String> temp = [];
      QuerySnapshot ticketQuery = await FirebaseFirestore.instance
          .collection("raisedTickets")
          .doc(dateList[j])
          .collection('tickets')
          .get();
      temp = ticketQuery.docs.map((e) => e.id).toList();
      temp = temp.reversed.toList(); // This reverses the order within each date
      ticketList = ticketList + temp;
    }

    // Sort ticketList in descending order based on the date in the ticket IDs
    ticketList.sort((a, b) {
      DateTime dateA = parseDateForTicketNo(
          a); // Assuming parseDate extracts a DateTime from the string
      DateTime dateB = parseDateForTicketNo(b);
      return dateB.compareTo(dateA); // Sort in descending order
    });

    setState(() {});
  }

// Helper function to parse the date from the ticket ID
  DateTime parseDateForTicketNo(String ticketId) {
    // Assuming the format is 'YYYYMMDD.xx' (e.g., '20241005.03')
    int year = int.parse(ticketId.substring(0, 4));
    int month = int.parse(ticketId.substring(4, 6));
    int day = int.parse(ticketId.substring(6, 8));
    return DateTime(year, month, day);
  }

  Future<void> getBuilding() async {
    final provider = Provider.of<AllBuildingProvider>(context, listen: false);
    provider.setBuilderList([]);
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('buildingNumbers').get();
    if (querySnapshot.docs.isNotEmpty) {
      List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();
      buildingNumberList = tempData;
    }
    provider.setBuilderList(buildingNumberList);
  }

  Future<void> getFloor() async {
    final provider = Provider.of<AllFloorProvider>(context, listen: false);
    provider.setBuilderList([]);
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('floors').get();
    if (querySnapshot.docs.isNotEmpty) {
      List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();

      uniqueFloorList.addAll(tempData);
      Set<String> set = uniqueFloorList.toSet();
      floorNumberList = set.toList();
    }
    provider.setBuilderList(floorNumberList);
  }

  Future<void> getRoom() async {
    List<String> uniqueRoomList = [];
    final provider = Provider.of<AllRoomProvider>(context, listen: false);
    provider.setBuilderList([]);
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('rooms').get();
    if (querySnapshot.docs.isNotEmpty) {
      List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();
      uniqueRoomList.addAll(tempData);
      Set<String> set = uniqueRoomList.toSet();
      roomNumberList = set.toList();
    }
    provider.setBuilderList(roomNumberList);
    // print(roomNumberList);
  }

  Future<void> getAsset() async {
    List<String> uniqueAssetsList = [];
    final provider = Provider.of<AllAssetProvider>(context, listen: false);
    provider.setBuilderList([]);
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('assets').get();
    if (querySnapshot.docs.isNotEmpty) {
      List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();
      uniqueAssetsList.addAll(tempData);
      Set<String> set = uniqueAssetsList.toSet();
      assetList = set.toList();
    }
    provider.setBuilderList(assetList);
  }

//   Future<void> getRoom() async {
//     List<String> uniqueRoomsList = [];
//     // final provider = Provider.of<AllAssetProvider>(context, listen: false);
//     // provider.setBuilderList([]);
//     for (var i = 0; i < widget.buildings.length; i++) {
//       for (var j = 0; j < widget.floors.length; j++) {
//         QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//             .collection('buildingNumbers')
//             .doc(widget.buildings[i])
//             .collection('floorNumbers')
//             .doc(widget.floors[j])
//             .collection('roomNumbers')
//             .get();
//         if (querySnapshot.docs.isNotEmpty) {
//           List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();
//           uniqueRoomsList.addAll(tempData);
//           Set<String> set = uniqueRoomsList.toSet();
//           roomList = set.toList();
//           // provider.setBuilderList(assetList);
//         }
//       }
//     }

//     print('start on Rooms: $roomList');
//     setState(() {});
//   }

// // assets
//   Future<void> getAsset() async {
//     List<String> uniqueAssetsList = [];
//     // final provider = Provider.of<AllAssetProvider>(context, listen: false);
//     // provider.setBuilderList([]);
//     for (var i = 0; i < widget.buildings.length; i++) {
//       for (var j = 0; j < widget.floors.length; j++) {
//         for (var k = 0; k < roomList.length; k++) {
//           QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//               .collection('buildingNumbers')
//               .doc(widget.buildings[i])
//               .collection('floorNumbers')
//               .doc(widget.floors[j])
//               .collection('roomNumbers')
//               .doc(roomList[k])
//               .collection('assets')
//               .get();
//           if (querySnapshot.docs.isNotEmpty) {
//             List<String> tempData =
//                 querySnapshot.docs.map((e) => e.id).toList();
//             uniqueAssetsList.addAll(tempData);
//             Set<String> set = uniqueAssetsList.toSet();
//             assetList = set.toList();
//             // provider.setBuilderList(assetList);
//           }
//         }
//       }
//     }

//     print('start on Assets: $assetList');
//     setState(() {});
//   }

  Future<void> getWorkList() async {
    final provider = Provider.of<AllWorkProvider>(context, listen: false);
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('works').get();
    if (querySnapshot.docs.isNotEmpty) {
      List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();
      allWorkData = tempData;
    }

    provider.setBuilderList(allWorkData);
  }

  Widget customDropDown(String title, List<String> customDropDownList,
      String hintText, int index) {
    return Card(
      elevation: 5.0,
      child: Row(
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: Text(
                hintText,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              items: customDropDownList
                  .map((item) => DropdownMenuItem(
                        value:
                            item, //customDropDownList.contains(item) ? item : '',
                        child: Text(
                          item, //  customDropDownList.contains(item) ? item : '',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                        ),
                      ))
                  .toList(),
              value: index == 0
                  ? selectedStartDate
                  : index == 1
                      ? selectedTicket
                      : index == 2
                          ? selectedbuilding
                          : index == 3
                              ? selectedFloor
                              : index == 4
                                  ? selectedRoom
                                  : index == 5
                                      ? selectedUser
                                      : index == 6
                                          ? selectedAsset
                                          : index == 7
                                              ? selectedServiceProvider
                                              : index == 8
                                                  ? selectedStatus
                                                  : selectedWork,
              onChanged: (value) async {
                setState(() {
                  index == 0
                      ? selectedStartDate = value!
                      : index == 1
                          ? selectedTicket = value
                          : index == 2
                              ? selectedbuilding = value
                              : index == 3
                                  ? selectedFloor = value
                                  : index == 4
                                      ? selectedRoom = value
                                      : index == 5
                                          ? selectedUser = value
                                          : index == 6
                                              ? selectedAsset = value
                                              : index == 7
                                                  ? selectedServiceProvider =
                                                      value
                                                  : index == 8
                                                      ? selectedStatus = value
                                                      : selectedWork = value;
                });
                await getFloor().whenComplete(() {
                  setState(() {
                    getRoom().whenComplete(() {
                      setState(() {
                        getAsset().whenComplete(() {
                          setState(() {});
                        });
                      });
                    });
                  });
                });
              },
              buttonStyleData: const ButtonStyleData(
                decoration: BoxDecoration(),
                padding: EdgeInsets.symmetric(horizontal: 16),
                height: 50,
                width: 250,
              ),
              dropdownStyleData: const DropdownStyleData(
                maxHeight: 200,
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
              ),
              dropdownSearchData: DropdownSearchData(
                searchController: index == 0
                    ? dateController
                    : index == 1
                        ? ticketController
                        : index == 2
                            ? buildingController
                            : index == 3
                                ? floorController
                                : index == 4
                                    ? roomController
                                    : index == 5
                                        ? userController
                                        : index == 6
                                            ? assetController
                                            : index == 7
                                                ? serviceProviderController
                                                : index == 8
                                                    ? statusController
                                                    : workController,
                searchInnerWidgetHeight: 50,
                searchInnerWidget: Container(
                  height: 50,
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 4,
                    right: 8,
                    left: 8,
                  ),
                  child: TextFormField(
                    expands: true,
                    maxLines: null,
                    controller: index == 0
                        ? dateController
                        : index == 1
                            ? ticketController
                            : index == 2
                                ? buildingController
                                : index == 3
                                    ? floorController
                                    : index == 4
                                        ? roomController
                                        : index == 5
                                            ? userController
                                            : index == 6
                                                ? assetController
                                                : index == 7
                                                    ? serviceProviderController
                                                    : index == 8
                                                        ? statusController
                                                        : workController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      hintText: hintText,
                      hintStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                searchMatchFn: (item, searchValue) {
                  return item.value.toString().contains(searchValue);
                },
              ),
              //This to clear the search value when you close the menu
              onMenuStateChange: (isOpen) {
                if (!isOpen) {}
              },
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Refreshscreen()))
                    .whenComplete(() {
                  index == 0
                      ? selectedStartDate = ''
                      : index == 1
                          ? selectedTicket = null
                          : index == 2
                              ? selectedbuilding = null
                              : index == 3
                                  ? selectedFloor = null
                                  : index == 4
                                      ? selectedRoom = null
                                      : index == 5
                                          ? selectedUser = null
                                          : index == 6
                                              ? selectedAsset = null
                                              : index == 7
                                                  ? selectedServiceProvider =
                                                      null
                                                  : index == 8
                                                      ? selectedStatus = null
                                                      : selectedWork = null;
                  setState(() {});
                });
              },
              icon: const Icon(
                Icons.clear,
                size: 15,
              ))
        ],
      ),
    );
  }

  Future<void> pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,

      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      saveText: "OK",
      // initialEntryMode: DatePickerEntryMode.input,
    );
    if (newDateRange == null) return;
    setState(() {
      dateRange = newDateRange;
      rangeStartDate = dateRange.start;
      rangeEndDate = dateRange.end;

      selectedStartDate =
          "${rangeStartDate.day.toString().padLeft(2, '0')}-${rangeStartDate.month.toString().padLeft(2, '0')}-${rangeStartDate.year.toString()} ";
      selectedEndDate =
          "${rangeEndDate!.day.toString().padLeft(2, '0')}-${rangeEndDate!.month.toString().padLeft(2, '0')}-${rangeEndDate!.year.toString()} ";
    });
  }

  DateTime parseDateString(String dateStr) {
    try {
      // Using DateFormat to parse the string into DateTime object
      return DateFormat('dd-MM-yyyy').parse(dateStr);
    } catch (e) {
      print("Error parsing date: $e");
      return DateTime.now(); // Return the current date if parsing fails
    }
  }

  Future<void> filterTickets() async {
    // print('before $selectedUser');
    // selectedUser = selectedUser.toString().split(' ')[2];
    // print('selectedUse123r $selectedUser');
    try {
      filterData.clear();
      ticketList.clear();

      // QuerySnapshot dateQuery =
      //     await FirebaseFirestore.instance.collection("raisedTickets").get();

      // List<dynamic> dateList = dateQuery.docs.map((e) => e.id).toList();
      // print('dateList ${dateList}');
      if (selectedStartDate.isNotEmpty && selectedEndDate.isNotEmpty) {
        // Parse the selected start and end date strings into DateTime objects
        DateTime parsedStartDate = parseDateString(selectedStartDate);
        DateTime parsedEndDate = parseDateString(selectedEndDate);

        // Get all dateList entries (your raisedTickets document IDs)
        QuerySnapshot dateQuery =
            await FirebaseFirestore.instance.collection("raisedTickets").get();
        List<dynamic> dateList = dateQuery.docs.map((e) => e.id).toList();

        for (int j = 0; j < dateList.length; j++) {
          List<dynamic> temp = [];

          // Query to get the tickets for each date
          QuerySnapshot ticketQuery = await FirebaseFirestore.instance
              .collection("raisedTickets")
              .doc(dateList[j])
              .collection('tickets')
              .get();

          // Loop through the tickets and check if their date falls within the range
          for (var doc in ticketQuery.docs) {
            String ticketDateStr = doc[
                'date']; // Assuming the date is stored as a string in Firestore

            // Convert the ticket's string date to DateTime
            DateTime ticketDate = parseDateString(ticketDateStr);

            // Check if the ticket's date is within the selected date range
            if (ticketDate.isAfter(parsedStartDate) &&
                ticketDate.isBefore(parsedEndDate.add(Duration(days: 1)))) {
              temp.add(doc.id);
            } 
          }
          temp = temp.reversed.toList();
          if (temp.isNotEmpty) {
            ticketList = ticketList + temp;
            for (int k = 0; k < temp.length; k++) {
              DocumentSnapshot ticketDataQuery = await FirebaseFirestore
                  .instance
                  .collection("raisedTickets")
                  .doc(dateList[j])
                  .collection('tickets')
                  .doc(temp[k])
                  .get();
              if (ticketDataQuery.exists) {
                Map<String, dynamic> mapData =
                    ticketDataQuery.data() as Map<String, dynamic>;

                filterData.add(mapData);
                filterData.sort((a, b) {
                  DateTime dateA =
                      parseDate(a['date']); // Parse date from mapData

                  DateTime dateB = parseDate(b['date']);
                  return dateB.compareTo(dateA); // Descending order
                });
                // temp.sort((a, b) {
                //   DateTime dateA =
                //       parseDate(a['date']); // Parse date from mapData
                //   DateTime dateB = parseDate(b['date']);
                //   return dateA.compareTo(dateB); // Descending order
                // });

                print('$mapData abc');
              }
            }
          }
          // filterData = ticketList;
          // print(' =outside ticketList ${filterData}');
        }
      } else {
        QuerySnapshot dateQuery =
            await FirebaseFirestore.instance.collection("raisedTickets").get();
        List<dynamic> dateList = dateQuery.docs.map((e) => e.id).toList();
        for (int j = 0; j < dateList.length; j++) {
          List<dynamic> temp = [];
          Query query = FirebaseFirestore.instance
              .collection("raisedTickets")
              .doc(dateList[j])
              .collection('tickets');
          if (selectedStatus != null) {
            query = query.where('status', isEqualTo: selectedStatus);
          }
          if (selectedUser != null) {
            query = query.where('name', isEqualTo: selectedUser);
          }
          if (selectedFloor != null) {
            query = query.where('floor', isEqualTo: selectedFloor);
          }
          if (selectedTicket != null) {
            query = query.where('tickets', isEqualTo: selectedTicket);
          }
          if (selectedRoom != null) {
            query = query.where('room', isEqualTo: selectedRoom);
          }
          if (selectedWork != null) {
            query = query.where('work', isEqualTo: selectedWork);
          }
          if (selectedAsset != null) {
            query = query.where('asset', isEqualTo: selectedAsset);
          }
          if (selectedbuilding != null) {
            query = query.where('building', isEqualTo: selectedbuilding);
          }

          if (selectedServiceProvider != null) {
            query = query.where('serviceProvider',
                isEqualTo: selectedServiceProvider);
          }
          QuerySnapshot ticketQuery = await query.get();

          temp = ticketQuery.docs.map((e) => e.id).toList();
          // ticketList = ticketList + temp;
          temp = temp.reversed.toList();
          print('Temp String $temp');

          if (temp.isNotEmpty) {
            ticketList = ticketList + temp;
            for (int k = 0; k < temp.length; k++) {
              DocumentSnapshot ticketDataQuery = await FirebaseFirestore
                  .instance
                  .collection("raisedTickets")
                  .doc(dateList[j])
                  .collection('tickets')
                  .doc(temp[k])
                  .get();
              if (ticketDataQuery.exists) {
                Map<String, dynamic> mapData =
                    ticketDataQuery.data() as Map<String, dynamic>;

                filterData.add(mapData);
                filterData.sort((a, b) {
                  DateTime dateA =
                      parseDate(a['date']); // Parse date from mapData

                  DateTime dateB = parseDate(b['date']);
                  return dateB.compareTo(dateA); // Descending order
                });
                // temp.sort((a, b) {
                //   DateTime dateA =
                //       parseDate(a['date']); // Parse date from mapData
                //   DateTime dateB = parseDate(b['date']);
                //   return dateA.compareTo(dateB); // Descending order
                // });

                print('$mapData abc');
              }
            }
          }
        }
        print('tickets $tickets');
      }
    } catch (e) {
      print("Error Fetching tickets: $e");
    }
  }

  DateTime parseDate(String date) {
    List<String> parts = date.split('-');
    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);
    return DateTime(year, month, day);
  }

  //     else {
  //       for (int j = 0; j < dateList.length; j++) {
  //         List<dynamic> temp = [];
  //         QuerySnapshot ticketQuery = await FirebaseFirestore.instance
  //             .collection("raisedTickets")
  //             .doc(dateList[j])
  //             .collection('tickets')
  //             .where('work', isEqualTo: selectedWork) // Filter by work
  //             .where('status', isEqualTo: selectedStatus) // Filter by work
  //             .where('serviceProvider',
  //                 isEqualTo: selectedServiceProvider) // Filter by work
  //             .where('building', isEqualTo: selectedbuilding) // Filter by work
  //             .where('floor', isEqualTo: selectedFloor) // Filter by work
  //             .where('room', isEqualTo: selectedRoom) // Filter by work
  //             .where('asset', isEqualTo: selectedAsset) // Filter by work
  //             .where('user', isEqualTo: selectedUser) // Filter by work
  //             .where('tickets', isEqualTo: selectedTicket) // Filter by work
  //             .get();

  //         temp = ticketQuery.docs.map((e) => e.id).toList();
  //         // ticketList = ticketList + temp;

  //         if (temp.isNotEmpty) {
  //           ticketList.addAll(temp);
  //           for (int k = 0; k < temp.length; k++) {
  //             DocumentSnapshot ticketDataQuery = await FirebaseFirestore
  //                 .instance
  //                 .collection("raisedTickets")
  //                 .doc(dateList[j])
  //                 .collection('tickets')
  //                 .doc(temp[k])
  //                 .get();
  //             if (ticketDataQuery.exists) {
  //               Map<String, dynamic> mapData =
  //                   ticketDataQuery.data() as Map<String, dynamic>;

  //               filterData.add(mapData);
  //               // print('$mapData abc');
  //             }
  //           }
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print("Error Fetching tickets: $e");
  //     }
  //   }
  //   setState(() {});
  // }

  void clearSelectdData() {
    selectedWork = null;
    selectedServiceProvider = null;
    selectedStatus = null;
    selectedAsset = null;
    selectedUser = null;
    selectedRoom = null;
    selectedFloor = null;
    selectedbuilding = null;
    selectedTicket = null;
    selectedStartDate = '';
    selectedEndDate = '';
    ticketList.clear();
    filterData.clear();
  }
}
