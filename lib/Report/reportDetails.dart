import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:ticket_management_system/Report/imageScreen.dart';
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
  @override
  void initState() {
    print('widget.ticketData: ${widget.ticketData}');
    // print(widget.)
    super.initState();
  }

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
              gradient: LinearGradient(colors: [lightMarron, marron])),
        ),
      ),
      body: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        widget.ticketData.isNotEmpty
            ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.95,
                width: MediaQuery.of(context).size.width * 0.99,
                child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: widget.ticketData.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            childAspectRatio: 0.8,
                            crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      List<String> imageFilePaths = List<String>.from(
                          widget.ticketData[index]['imageFilePaths'] ?? []);
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: widget.ticketData[index]['status'] == "Open"
                              ? Card(
                                  color: lightMarron,
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
                                                widget.ticketData[index]
                                                        ['tickets'] ??
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
                                                widget.ticketData[index]
                                                        ['floor']
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
                                                        ['name'] ??
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
                                              child: kIsWeb
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: ImageNetwork(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                              return ImageScreen(
                                                                pageTitle:
                                                                    'Report Page',
                                                                imageFiles:
                                                                    imageFilePaths,
                                                                initialIndex:
                                                                    index2,
                                                              );
                                                            }),
                                                          );
                                                        },
                                                        image: imageFilePaths[
                                                            index2],
                                                        height: 50,
                                                        width: 50,
                                                        curve: Curves.easeIn,
                                                        fitWeb: BoxFitWeb.cover,
                                                        onLoading: const Icon(
                                                          Icons.image,
                                                          color: black,
                                                          size: 50,
                                                        ),
                                                        onError: const Icon(
                                                          Icons.error,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    )
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
                                              style: const ButtonStyle(
                                                fixedSize:
                                                    WidgetStatePropertyAll(
                                                        Size(120, 4)),
                                                backgroundColor:
                                                    WidgetStatePropertyAll(
                                                        marron),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return UpdateServiceProvider(
                                                          day: widget
                                                              .ticketData[index]
                                                                  ['date']
                                                              .toString(),
                                                          ticketId:
                                                              widget.ticketData[
                                                                      index]
                                                                  ['tickets']);
                                                    },
                                                  ),
                                                );
                                              },
                                              child: const Text(
                                                'Re Assign',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ))
                                        ]),
                                        const SizedBox(height: 2),
                                        Row(children: [
                                          const Text('Revive: ',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(width: 120),
                                          ElevatedButton(
                                              style: const ButtonStyle(
                                                fixedSize:
                                                    WidgetStatePropertyAll(
                                                        Size(120, 4)),
                                                backgroundColor:
                                                    WidgetStatePropertyAll(
                                                        marron),
                                              ),
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
                                                      widget.ticketData[index]
                                                          ['tickets']);
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
                                              child: const Text(
                                                'Revive',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ))
                                        ]),
                                      ],
                                    ),
                                  ),
                                )
                              : Card(
                                  color: Colors.green.shade200,
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
                                                widget.ticketData[index]
                                                        ['tickets'] ??
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
                                                widget.ticketData[index]
                                                        ['floor']
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
                                                        ['name'] ??
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
                                              child: kIsWeb
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: ImageNetwork(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                              return ImageScreen(
                                                                pageTitle:
                                                                    'Report Page',
                                                                imageFiles:
                                                                    imageFilePaths,
                                                                initialIndex:
                                                                    index2,
                                                              );
                                                            }),
                                                          );
                                                        },
                                                        image: imageFilePaths[
                                                            index2],
                                                        height: 50,
                                                        width: 50,
                                                        curve: Curves.easeIn,
                                                        fitWeb: BoxFitWeb.cover,
                                                        onLoading: const Icon(
                                                          Icons.image,
                                                          color: black,
                                                          size: 50,
                                                        ),
                                                        onError: const Icon(
                                                          Icons.error,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    )
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
                                              style: const ButtonStyle(
                                                fixedSize:
                                                    WidgetStatePropertyAll(
                                                        Size(120, 4)),
                                                backgroundColor:
                                                    WidgetStatePropertyAll(
                                                        marron),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return UpdateServiceProvider(
                                                          day: widget
                                                              .ticketData[index]
                                                                  ['date']
                                                              .toString(),
                                                          ticketId:
                                                              widget.ticketData[
                                                                      index]
                                                                  ['tickets']);
                                                    },
                                                  ),
                                                );
                                              },
                                              child: const Text(
                                                'Re Assign',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ))
                                        ]),
                                        const SizedBox(height: 2),
                                        Row(children: [
                                          const Text('Revive: ',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(width: 120),
                                          ElevatedButton(
                                              style: const ButtonStyle(
                                                fixedSize:
                                                    WidgetStatePropertyAll(
                                                        Size(120, 4)),
                                                backgroundColor:
                                                    WidgetStatePropertyAll(
                                                        marron),
                                              ),
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
                                                      widget.ticketData[index]
                                                          ['tickets']);
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
                                              child: const Text(
                                                'Revive',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ))
                                        ]),
                                      ],
                                    ),
                                  ),
                                ));
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

  Widget ticketCard(
      IconData icons, String title, String ticketListData, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
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
              style: TextStyle(fontWeight: FontWeight.bold),
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
        .doc(date)
        .collection('tickets')
        .doc(ticketId)
        .update({'status': 'Open', 'isSeen': true}).whenComplete(() {
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
