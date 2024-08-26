import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_management_system/Master/itemMaster/editRoomForm.dart';
import 'package:ticket_management_system/providers/roomProvider.dart';
import 'package:ticket_management_system/utils/colors.dart';

class RoomList extends StatefulWidget {
  const RoomList({super.key});

  @override
  State<RoomList> createState() => _RoomListState();
}

class _RoomListState extends State<RoomList> {
  TextEditingController roomNumberController = TextEditingController();
  List<String> roomNumberList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData().whenComplete(
      () => setState(
        () {
          isLoading = false;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AllRoomProvider>(context, listen: false);
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                      width: 5,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          storeData(roomNumberController.text).whenComplete(() {
                            popupmessage('Room No. added successfully!!');
                          });
                        },
                        child: const Text('Save')),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Consumer<AllRoomProvider>(builder: (context, value, child) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Card(
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: value.roomList.length,
                              itemBuilder: (item, index) {
                                return Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        value.roomList[index],
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
                                                      EditRoomForm(
                                                    roomId:
                                                        value.roomList[index],
                                                  ),
                                                ),
                                              ).whenComplete(() {
                                                provider.setLoadWidget(false);
                                              });
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              deleteroomNumber(
                                                  value.roomList[index]);
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
                              }),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
    );
  }

  Future storeData(String roomNumber) async {
    final provider = Provider.of<AllRoomProvider>(context, listen: false);
    await FirebaseFirestore.instance
        .collection('roomNumbers')
        .doc(roomNumber)
        .set({
      'roomNumber': roomNumber,
    });
    provider.addSingleList({'roomNumber': roomNumber});
  }

  Future<void> fetchData() async {
    final provider = Provider.of<AllRoomProvider>(context, listen: false);
    provider.setBuilderList([]);
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('roomNumbers').get();
    if (querySnapshot.docs.isNotEmpty) {
      List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();
      roomNumberList = tempData;
      provider.setBuilderList(roomNumberList);
    }
  }

  Future<void> deleteroomNumber(String roomNumber) async {
    final provider = Provider.of<AllRoomProvider>(context, listen: false);
    await FirebaseFirestore.instance
        .collection('roomNumbers')
        .doc(roomNumber)
        .delete();
    provider.removeData(roomNumberList.indexOf(roomNumber));
  }

  void popupmessage(String msg) {
    final provider = Provider.of<AllRoomProvider>(context, listen: false);
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
                      fetchData().whenComplete(() {
                        Navigator.pop(context);
                        roomNumberController.clear();
                        provider.setLoadWidget(false);
                      });
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
