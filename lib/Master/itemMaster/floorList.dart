import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_management_system/Master/itemMaster/editFloorForm.dart';
import 'package:ticket_management_system/providers/floorProvider.dart';
import 'package:ticket_management_system/utils/colors.dart';

class FloorList extends StatefulWidget {
  const FloorList({super.key});

  @override
  State<FloorList> createState() => _FloorListState();
}

class _FloorListState extends State<FloorList> {
  TextEditingController floorNumberController = TextEditingController();
  List<String> floorNumberList = [];

  bool isLoading = true;
  Stream? _stream;
  @override
  void initState() {
    _stream = FirebaseFirestore.instance.collection('floorNumbers').snapshots();
    super.initState();
    // fetchData().whenComplete(() => setState(() {
    //       isLoading = false;
    //     }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: Container(
                  color: Colors.white,
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.14,
                  child: TextFormField(
                    textInputAction: TextInputAction.done,
                    expands: true,
                    maxLines: null,
                    controller: floorNumberController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      hintText: 'Add Floor No',
                      hintStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              ElevatedButton(
                  onPressed: () {
                    storeData(floorNumberController.text).whenComplete(() {
                      popupmessage('Floor No. added successfully!!');
                    });
                  },
                  child: const Text('Save')),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.25,
            child: Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: StreamBuilder(
                      stream: _stream,
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.docs.isEmpty) {
                          return const Text('No data found');
                        } else {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (item, index) {
                                return Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        snapshot.data.docs[index]
                                            ['floorNumber'],
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              color: black,
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditFloorForm(
                                                    floorId: snapshot
                                                            .data.docs[index]
                                                        ['floorNumber'],
                                                  ),
                                                ),
                                              ).whenComplete(() {
                                                setState(() {
                                                  // fetchData();
                                                  // isLoading = false;
                                                });
                                              });
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              deletefloorNumber(snapshot.data
                                                  .docs[index]['floorNumber']);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      color: Colors.black,
                                    )
                                  ],
                                );
                              });
                        }
                      }),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future storeData(String floorNumber) async {
    final provider = Provider.of<AllFloorProvider>(context, listen: false);
    await FirebaseFirestore.instance
        .collection('floorNumbers')
        .doc(floorNumber)
        .set({
      'floorNumber': floorNumber,
    });
    provider.addSingleList({'floorNumber': floorNumber});
  }

  Future<void> deletefloorNumber(String floorNumber) async {
    final provider = Provider.of<AllFloorProvider>(context, listen: false);
    await FirebaseFirestore.instance
        .collection('floorNumbers')
        .doc(floorNumber)
        .delete();
    provider.removeData(floorNumberList.indexOf(floorNumber));
  }

  void popupmessage(String msg) {
    final provider = Provider.of<AllFloorProvider>(context, listen: false);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: AlertDialog(
              content: Text(
                msg,
                style: const TextStyle(fontSize: 14, color: Colors.green),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      floorNumberController.clear();
                      provider.setLoadWidget(false);
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.green),
                    ))
              ],
            ),
          );
        });
  }
}
