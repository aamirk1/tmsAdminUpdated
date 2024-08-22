import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
class ReportDetails extends StatefulWidget {
  const ReportDetails({super.key});

  @override
  State<ReportDetails> createState() => _ReportDetailsState();
}

class _ReportDetailsState extends State<ReportDetails> {
  List<String> columnName = [
    'Date',
    'TAT',
    'Ticket No',
    'Status',
    'Work',
    'Building',
    'Floor',
    'Room',
    'Asset',
    'User',
    'Service Provider',
    'Remarks',
    // 'Picture',
    'Re-Assign (From/To)',
    'Revive',
  ];
  List<List<String>> rowData = [];
  String asset = '';
  String floor = '';
  String building = '';
  String room = '';
  String date = '';
  String work = '';
  String service = '';
  String tat = '';
  String status = '';
  String user = '';
  String remark = '';
  String picture = '';
  String assign = '';
  String revive = '';

  List<String> ticketList = [];

  List<String> serviceProvider = [];

  String? selectedServiceProvider;

  List<String> ticketNumberList = [];
  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Report Details'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                padding: const EdgeInsets.all(2.0),
                height: MediaQuery.of(context).size.height * 0.75,
                width: MediaQuery.of(context).size.width * 0.99,
                child: DataTable2(
                  minWidth: 5500,
                  border: TableBorder.all(color: Colors.black),
                  headingRowColor: const WidgetStatePropertyAll(Colors.purple),
                  headingTextStyle:
                      const TextStyle(color: Colors.white, fontSize: 50.0),
                  columnSpacing: 3.0,
                  columns: List.generate(columnName.length, (index) {
                    return DataColumn2(
                      fixedWidth: 150,
                      // fixedWidth: index == 10 ? 300 : 110,
                      label: Align(
                        alignment: Alignment.center,
                        child: Text(
                          columnName[index],
                          style: const TextStyle(
                              // overflow: TextOverflow.ellipsis,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }),
                  rows: List.generate(
                    growable: true,
                    rowData.length, //change column name to row data
                    (index1) => DataRow2(
                      cells: List.generate(columnName.length, (index2) {
                        return DataCell(Padding(
                          padding: const EdgeInsets.only(bottom: 2.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              rowData[index1][index2].toString(),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ));
                      }),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(context, MaterialPageRoute(builder: (context) {
      //       return const UpdateServiceProvider();
      //     }));
      //   },
      //   backgroundColor: Colors.deepPurple,
      //   child: const Icon(Icons.add, color: white),
      // ),
    );
  }

  Future<void> getdata() async {
    Map<String, dynamic> data = Map();

    for (var i = 0; i < ticketList.length; i++) {
      List<String> allData = [];
      // if (kDebugMode) {
      //   print('lll${ticketList[i]}');
      // }
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('raisedTickets')
          .doc(ticketList[i])
          .get();

      if (documentSnapshot.data() != null) {
        data = documentSnapshot.data() as Map<String, dynamic>;

        asset = data['asset'] ?? '';
        building = data['building'] ?? '';
        date = data['date'] ?? '';
        floor = data['floor'] ?? '';
        room = data['room'] ?? '';
        service = data['serviceProvider'] ?? '';
        work = data['work'] ?? '';
        tat = data['tat'] ?? 'tat';
        status = data['open'] ?? 'open';
        user = data['user'] ?? 'user11';
        remark = data['remark'] ?? 'remark';
        // picture = data['picture'] ?? 'picture';
        assign = data['assign'] ?? 'assign';
        revive = data['revive'] ?? 'revive';
      }
      allData.add(date);
      allData.add(tat);
      allData.add(ticketList[i]);
      allData.add(status);
      allData.add(work);
      allData.add(building);
      allData.add(floor);
      allData.add(room);
      allData.add(asset);
      allData.add(user);
      allData.add(service);
      allData.add(remark);
      // allData.add(picture);
      allData.add(assign);
      allData.add(revive);
      rowData.add(allData);
    }
  }
}

