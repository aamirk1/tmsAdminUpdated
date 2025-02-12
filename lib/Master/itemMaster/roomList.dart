import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_management_system/providers/roomProvider.dart';
import 'package:ticket_management_system/providers/screenChangeProvider.dart';
import 'package:ticket_management_system/utils/colors.dart';
import 'package:ticket_management_system/utils/loading_page.dart';

// ignore: must_be_immutable
class RoomList extends StatefulWidget {
  RoomList({super.key, required this.buildingId, required this.floorId});
  String buildingId;
  String floorId;

  @override
  State<RoomList> createState() => _RoomListState();
}

class _RoomListState extends State<RoomList> {
  TextEditingController roomNumberController = TextEditingController();
  List<String> roomNumberList = [];

  bool isLoading = true;
  Stream? _stream;
  Screenchangeprovider provider = Screenchangeprovider();
  @override
  void initState() {
    provider = Provider.of<Screenchangeprovider>(context, listen: false);
    _stream = FirebaseFirestore.instance
        .collection('buildingNumbers')
        .doc(widget.buildingId)
        .collection('floorNumbers')
        .doc(widget.floorId)
        .collection('roomNumbers')
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<AllRoomProvider>(context, listen: false);
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
                  width: MediaQuery.of(context).size.width * 0.10,
                  child: TextFormField(
                    textInputAction: TextInputAction.done,
                    expands: true,
                    maxLines: null,
                    controller: roomNumberController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      hintText: 'Add Room No',
                      hintStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              ElevatedButton(
                  onPressed: () {
                    storeData(roomNumberController.text).whenComplete(() {
                      roomNumberController.clear();
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
                            child: LoadingPage(),
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
                                      selected:
                                          index == provider.selectedroomIndex,
                                      selectedTileColor: lightMarron,
                                      onTap: () {
                                        provider.setRoomIndex(index);
                                        widget.buildingId;
                                        widget.floorId;

                                        provider.setRoomNumber(snapshot
                                            .data.docs[index]['roomNumber']);
                                        // provider.setIsFloorScreen(
                                        //     true);
                                        provider.isAssetScreen == true
                                            ? provider.setIsAssetScreen(false)
                                            : provider.setIsAssetScreen(true);

                                        provider.setIsWorkScreen(false);
                                      },
                                      title: Text(
                                        snapshot.data.docs[index]['roomNumber'],
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
  // Show confirmation dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text(
            'Are you sure you want to delete room number ${snapshot.data.docs[index]['roomNumber']}?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              // Call the deleteroomNumber function to delete the room number
              deleteroomNumber(snapshot.data.docs[index]['roomNumber']);
              Navigator.of(context).pop(); // Close the dialog after deletion
            },
          ),
        ],
      );
    },
  );
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

  Future storeData(String roomNumber) async {
    final provider = Provider.of<AllRoomProvider>(context, listen: false);
    await FirebaseFirestore.instance
        .collection('buildingNumbers')
        .doc(widget.buildingId)
        .collection('floorNumbers')
        .doc(widget.floorId)
        .collection('roomNumbers')
        .doc(roomNumber)
        .set({
      'roomNumber': roomNumber,
    });

    FirebaseFirestore.instance.collection('rooms').doc(roomNumber).set({
      'roomNumber': roomNumber,
    });
    provider.addSingleList({'roomNumber': roomNumber});
  }

  Future<void> deleteroomNumber(String roomNumber) async {
    final provider = Provider.of<AllRoomProvider>(context, listen: false);
    await FirebaseFirestore.instance
        .collection('buildingNumbers')
        .doc(widget.buildingId)
        .collection('floorNumbers')
        .doc(widget.floorId)
        .collection('roomNumbers')
        .doc(roomNumber)
        .delete();

    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomNumber)
        .delete();
    provider.removeData(roomNumberList.indexOf(roomNumber));
  }

  // void popupmessage(String msg) {
  //   final provider = Provider.of<AllRoomProvider>(context, listen: false);
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Center(
  //           child: AlertDialog(
  //             content: Text(
  //               msg,
  //               style: const TextStyle(fontSize: 14, color: Colors.green),
  //             ),
  //             actions: [
  //               TextButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                     roomNumberController.clear();
  //                     provider.setLoadWidget(false);
  //                   },
  //                   child: const Text(
  //                     'OK',
  //                     style: TextStyle(color: Colors.green),
  //                   ))
  //             ],
  //           ),
  //         );
  //       });
  // }
}
