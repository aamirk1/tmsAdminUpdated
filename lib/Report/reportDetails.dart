import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:ticket_management_system/Report/upDateServiceProvider.dart';
import 'package:ticket_management_system/utils/colors.dart';

// ignore: must_be_immutable
class ReportDetails extends StatefulWidget {
  ReportDetails(
      {super.key, required this.ticketList, required this.ticketData});

  List<dynamic> ticketList = [];
  List<dynamic> ticketData = [];
  @override
  State<ReportDetails> createState() => _ReportDetailsState();
}

class _ReportDetailsState extends State<ReportDetails> {
  final pattern = RegExp(r',\s*');
  List<dynamic> keys = [
    'date',
    'tickets',
    'building',
    'floor',
    'room',
    'user',
    'asset',
    'serviceProvider',
    'status',
    'work',
  ];
  List<List<String>> rowData = [];

  List<String> assetList = [];
  List<String> floorList = [];
  List<String> buildingList = [];
  List<String> roomList = [];
  List<String> dateList = [];
  List<String> dateClosedList = [];
  List<String> workList = [];
  List<String> serviceList = [];
  List<String> tatList = [];
  List<String> statusList = [];
  List<String> userList = [];
  List<String> remarkList = [];
  List<String> pictureList = [];
  List<String> assignList = [];
  List<String> reviveList = [];
  List<String> ticketNumList = [];

  List<dynamic> ticketList = [];
  List<String> ticketNumberList = [];
  List<String> yearList = [];
  List<String> monthList = [];
  List<String> dayList = [];

  List<String> serviceProvider = [];
  List<dynamic> allData = [];
  String? selectedServiceProvider;
  List<String> allTicketData = [];
  bool isLoading = true;

  String asset = '';
  String building = '';
  String floor = '';
  String remark = '';
  String room = '';
  String work = '';
  String serviceprovider = '';
  List<dynamic> ticketListData = [];

  @override
  void initState() {
    // getdata().whenComplete(() => setState(() {
    //       isLoading = false;
    //     }));
    super.initState();
    // print('mdklsalk');
    // print(widget.ticketList);
    // print(widget.ticketData);
    // print(widget.workFilter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Report Details',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient:
                  LinearGradient(colors: [Colors.purple, Colors.deepPurple])),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              widget.ticketList.isNotEmpty
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.95,
                      width: MediaQuery.of(context).size.width * 0.99,
                      child: GridView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: widget.ticketList.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                  childAspectRatio: 0.8,
                                  crossAxisCount: 3),
                          itemBuilder: (BuildContext context, int index) {
                            List<String> imageFilePaths = List<String>.from(
                                widget.ticketData[index]['imageFilePaths'] ??
                                    []);
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          ticketCard(
                                              Icons.work,
                                              "Status: ",
                                              widget.ticketData[index]
                                                      ['status'] ??
                                                  "N/A",
                                              index)
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        children: [
                                          ticketCard(
                                              Icons.work,
                                              "Ticket No.: ",
                                              widget.ticketList[index] ?? "N/A",
                                              index)
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        children: [
                                          ticketCard(
                                              Icons.work,
                                              "Date (Opened): ",
                                              widget.ticketData[index]
                                                      ['date'] ??
                                                  "N/A",
                                              index)
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        children: [
                                          ticketCard(
                                              Icons.work,
                                              "Date (Closed): ",
                                              widget.ticketData[index]
                                                      ['closedDate'] ??
                                                  "N/A",
                                              index)
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        children: [
                                          ticketCard(
                                              Icons.business,
                                              'Tat: ',
                                              widget.ticketData[index]['tat']
                                                      .toString() ??
                                                  "N/A",
                                              index)
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        children: [
                                          ticketCard(
                                              Icons.business,
                                              'Work: ',
                                              widget.ticketData[index]
                                                      ['work'] ??
                                                  "N/A",
                                              index)
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        children: [
                                          ticketCard(
                                              Icons.layers,
                                              "Building: ",
                                              widget.ticketData[index]
                                                      ['building']
                                                  .toString(),
                                              index)
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        children: [
                                          ticketCard(
                                              Icons.layers,
                                              "Floor: ",
                                              widget.ticketData[index]['floor']
                                                  .toString(),
                                              index)
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        children: [
                                          ticketCard(
                                              Icons.room,
                                              'Room: ',
                                              widget.ticketData[index]
                                                      ['room'] ??
                                                  "N/A",
                                              index)
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          ticketCard(
                                              Icons.account_balance,
                                              "Asset: ",
                                              widget.ticketData[index]
                                                      ['asset'] ??
                                                  "N/A",
                                              index)
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          ticketCard(
                                              Icons.build,
                                              'User: ',
                                              widget.ticketData[index]
                                                      ['user'] ??
                                                  "N/A",
                                              index)
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          ticketCard(
                                              Icons.build,
                                              'ServiceProvider: ',
                                              widget.ticketData[index]
                                                      ['serviceProvider']
                                                  .toString()
                                                  .replaceAll(
                                                      RegExp(r'\[|\]'), ' '),
                                              index)
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Row(children: [
                                        ticketCard(
                                            Icons.comment,
                                            'Remark: ',
                                            widget.ticketData[index]['remark']
                                                .toString(),
                                            index)
                                      ]),
                                      const SizedBox(height: 2),
                                      SizedBox(
                                        height: 50,
                                        child: ListView.builder(
                                          itemCount: imageFilePaths.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index2) =>
                                              SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: isLoading
                                                ? const CircularProgressIndicator()
                                                : kIsWeb
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: ImageNetwork(
                                                          onTap: () {
                                                            // Navigator.push(
                                                            //     context,
                                                            //     MaterialPageRoute(
                                                            //         builder:
                                                            //             (context) =>
                                                            //                 ImageScreen(
                                                            //                   pageTitle: 'Report Page',
                                                            //                   imageFiles: imageFilePaths,
                                                            //                   initialIndex: index2,
                                                            //                   imageFile: imageFilePaths[index2],
                                                            //                   ticketId: ticketList[index],
                                                            //                 )));
                                                          },
                                                          image: imageFilePaths[
                                                              index2],
                                                          // put a height and width because they are required
                                                          height: 50,
                                                          width: 50,
                                                          curve: Curves.easeIn,
                                                          fitWeb:
                                                              BoxFitWeb.cover,
                                                          onLoading:
                                                              const CircularProgressIndicator(
                                                            color: Colors
                                                                .indigoAccent,
                                                          ),
                                                          onError: const Icon(
                                                            Icons.error,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      )
                                                    // Padding(
                                                    //     padding:
                                                    //         const EdgeInsets
                                                    //             .all(8.0),
                                                    //     child: Image.network(
                                                    //       height: 50,
                                                    //       fit: BoxFit.cover,
                                                    //       imageFilePaths[
                                                    //           index2],
                                                    //     ),
                                                    //   )
                                                    : const Icon(
                                                        Icons.image,
                                                        color: black,
                                                        size: 50,
                                                      ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Row(children: [
                                        const Text('Re Assign: ',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(width: 100),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                builder: (context) {
                                                  return UpdateServiceProvider(
                                                      year: widget
                                                          .ticketData[index]
                                                              ['year']
                                                          .toString(),
                                                      month: widget
                                                          .ticketData[index]
                                                              ['month']
                                                          .toString(),
                                                      day: widget
                                                          .ticketData[index]
                                                              ['date']
                                                          .toString(),
                                                      ticketId: widget
                                                          .ticketList[index]);
                                                },
                                              ));
                                            },
                                            child: const Text('Re Assign'))
                                      ]),
                                      const SizedBox(height: 2),
                                      Row(children: [
                                        const Text('Revive: ',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(width: 100),
                                        ElevatedButton(
                                            onPressed: () {
                                              if (widget.ticketData[index]
                                                      ['status'] ==
                                                  'Close') {
                                                updateTicketStatus(
                                                    widget.ticketData[index]
                                                            ['year']
                                                        .toString(),
                                                    widget.ticketData[index]
                                                        ['month'],
                                                    widget.ticketData[index]
                                                        ['date'],
                                                    widget.ticketList[index]);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      backgroundColor:
                                                          Colors.red,
                                                      content: Center(
                                                        child: Text(
                                                            'Ticket Already Open'),
                                                      )),
                                                );
                                              }
                                            },
                                            child: const Text('Revive'))
                                      ]),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }))
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: const Card(
                        elevation: 5,
                        child: Center(
                          child: Text(
                            'No Tickets Found!',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    )
            ]),
    );
  }

  // Future<void> getYearList() async {
  //   // final provider = Provider.of<AllRoomProvider>(context, listen: false);
  //   // provider.setBuilderList([]);
  //   QuerySnapshot querySnapshot =
  //       await FirebaseFirestore.instance.collection('raisedTickets').get();
  //   if (querySnapshot.docs.isNotEmpty) {
  //     List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();
  //     yearList = tempData;
  //   }
  //   setState(() {});
  // }

  // Future<void> getMonthList() async {
  //   // final provider = Provider.of<AllRoomProvider>(context, listen: false);
  //   // provider.setBuilderList([]);
  //   for (var i = 0; i < yearList.length; i++) {
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('raisedTickets')
  //         .doc(yearList[i])
  //         .collection('months')
  //         .get();
  //     if (querySnapshot.docs.isNotEmpty) {
  //       List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();
  //       monthList = tempData;
  //     }
  //     setState(() {});
  //   }
  // }

  // Future<void> getDayList() async {
  //   // final provider = Provider.of<AllRoomProvider>(context, listen: false);
  //   // provider.setBuilderList([]);
  //   for (var i = 0; i < yearList.length; i++) {
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('raisedTickets')
  //         .doc(yearList[i])
  //         .collection('months')
  //         .doc(monthList[i])
  //         .collection('date')
  //         .get();
  //     if (querySnapshot.docs.isNotEmpty) {
  //       List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();
  //       dayList = tempData;
  //     }
  //     setState(() {});
  //   }
  // }

  // Future<void> getdata() async {
  //   try {
  //     ticketList.clear();
  //     int currentYear = DateTime.now().year;

  //     QuerySnapshot monthQuery = await FirebaseFirestore.instance
  //         .collection("raisedTickets")
  //         .doc(currentYear.toString())
  //         .collection('months')
  //         .get();
  //     List<dynamic> months = monthQuery.docs.map((e) => e.id).toList();
  //     for (int i = 0; i < months.length; i++) {
  //       QuerySnapshot dateQuery = await FirebaseFirestore.instance
  //           .collection("raisedTickets")
  //           .doc(currentYear.toString())
  //           .collection('months')
  //           .doc(months[i])
  //           .collection('date')
  //           .get();
  //       List<dynamic> dateList = dateQuery.docs.map((e) => e.id).toList();
  //       for (int j = 0; j < dateList.length; j++) {
  //         List<dynamic> temp = [];
  //         QuerySnapshot ticketQuery = await FirebaseFirestore.instance
  //             .collection("raisedTickets")
  //             .doc(currentYear.toString())
  //             .collection('months')
  //             .doc(months[i])
  //             .collection('date')
  //             .doc(dateList[j])
  //             .collection('tickets')
  //             // .where('work', isEqualTo: widget.workFilter) // Filter by work
  //             // .where('status', isEqualTo: widget.statusFilter) // Filter by work
  //             // .where('serviceProvider',
  //             //     isEqualTo: widget.serviceProvider) // Filter by work
  //             // .where('building',
  //             //     isEqualTo: widget.buildingFilter) // Filter by work
  //             // .where('floor', isEqualTo: widget.floorFilter) // Filter by work
  //             // .where('room', isEqualTo: widget.roomFilter) // Filter by work
  //             // .where('asset', isEqualTo: widget.statusFilter) // Filter by work
  //             // .where('user', isEqualTo: widget.userFilter) // Filter by work
  //             // .where('tickets',
  //             //     isEqualTo: widget.ticketFilter) // Filter by work
  //             .get();

  //         temp = ticketQuery.docs.map((e) => e.id).toList();
  //         // ticketList = ticketList + temp;

  //         if (temp.isNotEmpty) {
  //           ticketList.addAll(temp);
  //           for (int k = 0; k < temp.length; k++) {
  //             DocumentSnapshot ticketDataQuery = await FirebaseFirestore
  //                 .instance
  //                 .collection("raisedTickets")
  //                 .doc(currentYear.toString())
  //                 .collection('months')
  //                 .doc(months[i])
  //                 .collection('date')
  //                 .doc(dateList[j])
  //                 .collection('tickets')
  //                 .doc(temp[k])
  //                 .get();
  //             if (ticketDataQuery.exists) {
  //               Map<String, dynamic> mapData =
  //                   ticketDataQuery.data() as Map<String, dynamic>;
  //               asset = mapData['asset'] ?? "N/A";
  //               building = mapData['building'] ?? "N/A";
  //               floor = mapData['floor'] ?? "N/A";
  //               remark = mapData['remark'] ?? "N/A";
  //               room = mapData['room'] ?? "N/A";
  //               work = mapData['work'] ?? "N/A";
  //               serviceprovider = mapData['serviceProvider'] ?? "";
  //               widget.ticketData.add(mapData);
  //               // print('$mapData abc');
  //             }
  //           }
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     print("Error Fetching tickets: $e");
  //   }

  //   setState(() {});
  // }

  Widget ticketCard(
      IconData icons, String title, String ticketListData, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Icon(icons, color: Colors.deepPurple),
        // const SizedBox(width: 20),
        SizedBox(
          // height: MediaQuery.of(context).size.height,
          width: 110,
          child: Text(title,
              textAlign: TextAlign.start,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 20),
        Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: SizedBox(
            // height: MediaQuery.of(context).size.height,
            width: 200,
            child: Text(
              ticketListData,
              textAlign: TextAlign.justify,
            ),
          ),
        )
      ],
    );
  }

  Future<void> updateTicketStatus(
      String year, String month, String date, String ticketId) async {
    await FirebaseFirestore.instance
        .collection("raisedTickets")
        .doc(year)
        .collection('months')
        .doc(month)
        .collection('date')
        .doc(date)
        .collection('tickets')
        .doc(ticketId)
        .update({'status': 'Open'}).whenComplete(() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Center(
            child: Text('Ticket Revived'),
          ),
        ),
      );
    });
  }
}
