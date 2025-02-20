import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_management_system/providers/roomProvider.dart';
import 'package:ticket_management_system/providers/screenChangeProvider.dart';
import 'package:ticket_management_system/utils/colors.dart';
import 'package:ticket_management_system/utils/loading_page.dart';

// ignore: must_be_immutable
class WorkListByAsset extends StatefulWidget {
  WorkListByAsset(
      {super.key,
      required this.buildingId,
      required this.floorId,
      required this.roomId,
      required this.assetId,
      required this.workList});
  String buildingId;
  String floorId;
  String roomId;
  String assetId;

  List<dynamic> workList = [];

  @override
  State<WorkListByAsset> createState() => _WorkListByAssetState();
}

class _WorkListByAssetState extends State<WorkListByAsset> {
  // TextEditingController workController = TextEditingController();
  TextEditingController workListByAssetController = TextEditingController();
  List<String> workListByAssetList = [];

  bool isLoading = true;
  Stream? _stream;
  String? selectedWork;
  List<String> selectedWorkList = [];
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
        .doc(widget.roomId)
        .collection('assets')
        .where('asset', isEqualTo: widget.assetId)
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
                  child: customDropDown(
                    'Select Work',
                    true,
                    widget.workList,
                    "Search Work",
                  ),
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await storeData(selectedWorkList[0]).whenComplete(() {
                      selectedWorkList.clear();
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
                          return const Center(child: Text('No data found'));
                        } else {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (item, index) {
                                return Column(
                                  children: [
                                    ListTile(
                                      // onTap: () {
                                      //   // provider.setIsFloorScreen(
                                      //   //     true);
                                      //   provider.isAssetScreen == true
                                      //       ? provider.setIsWorkScreen(false)
                                      //       : provider.setIsWorkScreen(true);
                                      // },
                                      title: Text(
                                        snapshot.data.docs[index]
                                            ['workListByAsset'],
                                        // snapshot.data['workListByAsset'],
                                        style: const TextStyle(
                                            color: Colors.black),
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

  storeData(workListByAsset) async {
    // var assetList = await FirebaseFirestore.instance
    //     .collection('assets')
    //     .where('asset', isEqualTo: widget.assetId)
    //     .get();

    // if (assetList.docs.isNotEmpty) {
    //   for (var doc in assetList.docs) {
    //     print("✅ Updating Firestore document: ${doc.reference.path}");
    //     await doc.reference
    //         .set({'workListByAsset': workListByAsset}, SetOptions(merge: true));
    //   }
    //   print("🎉 Firestore update successful!");
    // } else {
    //   print("⚠️ No matching asset found for assetId: ${widget.assetId}");
    // }

    // await FirebaseFirestore.instance
    //     .collection('buildingNumbers')
    //     .doc(widget.buildingId)
    //     .collection('floorNumbers')
    //     .doc(widget.floorId)
    //     .collection('roomNumbers')
    //     .doc(widget.roomId)
    //     .collection('assets')
    //     .doc(widget.assetId)
    //     .update({'asset': widget.assetId, 'workListByAsset': workListByAsset});

    var assetDocRef = FirebaseFirestore.instance
        .collection('buildingNumbers')
        .doc(widget.buildingId)
        .collection('floorNumbers')
        .doc(widget.floorId)
        .collection('roomNumbers')
        .doc(widget.roomId)
        .collection('assets')
        .doc(widget.assetId);

    try {
      var docSnapshot = await assetDocRef.get();

      if (docSnapshot.exists) {
        await assetDocRef.update(
            {'asset': widget.assetId, 'workListByAsset': workListByAsset});
      } else {
        print('Document does not exist. Creating it now...');
        await assetDocRef.set(
            {'asset': widget.assetId, 'workListByAsset': workListByAsset},
            SetOptions(merge: true));
      }
    } catch (e) {
      print('Error updating Firestore document: $e');
    }

    // FirebaseFirestore.instance.collection('rooms').doc(workListByAsset).set({
    //   'workListByAsset': workListByAsset,
    // });
    // provider.addSingleList({'workListByAsset': workListByAsset});
  }

  Future<void> deleteworkListByAsset(String workListByAsset) async {
    final provider = Provider.of<AllRoomProvider>(context, listen: false);
    await FirebaseFirestore.instance
        .collection('buildingNumbers')
        .doc(widget.buildingId)
        .collection('floorNumbers')
        .doc(widget.floorId)
        .collection('roomNumbers')
        .doc(widget.roomId)
        .collection('assets')
        .doc(widget.assetId)
        .collection('workListByAssets')
        .doc(workListByAsset)
        .delete();

    provider.removeData(workListByAssetList.indexOf(workListByAsset));
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

  Widget customDropDown(String title, bool isMultiCheckbox,
      List<dynamic> customDropDownList, String hintText) {
    return Card(
      elevation: 5.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: black,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(
            3.0,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              height: 25,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  dropdownSearchData: DropdownSearchData(
                    searchController: workListByAssetController,
                    searchInnerWidgetHeight: 20,
                    searchInnerWidget: const SizedBox(
                      height: 50, //: 42,
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            // Expanded(
                            //   child: SizedBox(
                            //     width: 90,
                            //     child: TextFormField(
                            //       expands: true,
                            //       maxLines: null,
                            //       controller: workListByAssetController,
                            //       decoration: InputDecoration(
                            //         isDense: true,
                            //         contentPadding: const EdgeInsets.symmetric(
                            //           horizontal: 5,
                            //           vertical: 4,
                            //         ),
                            //         hintText: hintText,
                            //         hintStyle: const TextStyle(
                            //           fontSize: 11,
                            //         ),
                            //         border: OutlineInputBorder(
                            //           borderRadius: BorderRadius.circular(
                            //             4,
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //       left: 2.0, right: 1, top: 6, bottom: 5),
                            //   child: ElevatedButton(
                            //     style: ElevatedButton.styleFrom(
                            //         backgroundColor: marron,
                            //         minimumSize: Size(
                            //           MediaQuery.of(context).size.width * 0.04,
                            //           50,
                            //         ),
                            //         shape: RoundedRectangleBorder(
                            //           borderRadius: BorderRadius.circular(6),
                            //         )),
                            //     onPressed: () {
                            //       Navigator.pop(context);
                            //     },
                            //     child: const Text(
                            //       'Done',
                            //       style: TextStyle(
                            //         fontSize: 12,
                            //         color: white,
                            //       ),
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ),
                  ),
                  value: selectedWork,
                  isExpanded: true,
                  onMenuStateChange: (isOpen) {
                    setState(() {});
                  },
                  hint: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: black,
                    ),
                  ),
                  items: isMultiCheckbox
                      ? customDropDownList.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            enabled: false,
                            child: StatefulBuilder(
                              builder: (context, menuSetState) {
                                bool isSelected =
                                    selectedWorkList.contains(item);

                                return InkWell(
                                  onTap: () async {
                                    switch (isSelected) {
                                      case true:
                                        selectedWorkList.remove(item);
                                        break;
                                      case false:
                                        selectedWorkList.add(item);
                                        break;
                                    }

                                    setState(() {});
                                    menuSetState(() {});
                                  },
                                  child: SizedBox(
                                    height: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        isSelected
                                            ? const Icon(
                                                Icons.check_box_outlined,
                                                size: 20,
                                              )
                                            : const Icon(
                                                Icons.check_box_outline_blank,
                                                size: 20,
                                              ),
                                        const SizedBox(width: 3),
                                        Expanded(
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList()
                      : customDropDownList
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  color: black,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                          .toList(),
                  style: const TextStyle(fontSize: 10, color: Colors.blue),
                  dropdownStyleData: const DropdownStyleData(
                    maxHeight: 300,
                  ),
                  onChanged: (value) {
                    selectedWork = value;
                  },
                  iconStyleData: const IconStyleData(
                    iconDisabledColor: Colors.blue,
                    iconEnabledColor: Colors.blue,
                  ),
                  buttonStyleData: const ButtonStyleData(
                    elevation: 5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
