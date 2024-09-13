import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_management_system/providers/buildingProvider.dart';
import 'package:ticket_management_system/providers/screenChangeProvider.dart';
import 'package:ticket_management_system/utils/colors.dart';

class BuildingList extends StatefulWidget {
  const BuildingList({super.key});

  @override
  State<BuildingList> createState() => _BuildingListState();
}

class _BuildingListState extends State<BuildingList> {
  TextEditingController buildingNumberController = TextEditingController();
  List<String> buildingNumberList = [];
  int selectedIndex = 0;
  bool isLoading = true;
  Stream? _stream;
  Screenchangeprovider provider = Screenchangeprovider();
  @override
  void initState() {
    provider = Provider.of<Screenchangeprovider>(context, listen: false);
    _stream =
        FirebaseFirestore.instance.collection('buildingNumbers').snapshots();
    // fetchData().whenComplete(() => setState(() {
    //       isLoading = false;
    //     }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // fetchData();
    return Scaffold(body:
        Consumer<Screenchangeprovider>(builder: (context, provider, child) {
      return Column(
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
                    controller: buildingNumberController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      hintText: 'Add Building Number',
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
                    storeData(buildingNumberController.text).whenComplete(() {
                      popupmessage('Building added successfully!!');
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
                                      selected: index == provider.selectedbuildingIndex,
                                      selectedTileColor: lightMarron,
                                      onTap: () {
                                        
                                        provider.setBuildingIndex(index);
                                        provider.setBuildingNumber(snapshot.data
                                            .docs[index]['buildingNumber']);
                                        // provider.setIsFloorScreen(
                                        //     true);
                                        provider.isFloorScreen == true
                                            ? provider.setIsFloorScreen(false)
                                            : provider.setIsFloorScreen(true);
                                        provider.setIsRoomScreen(false);
                                        provider.setIsAssetScreen(false);
                                      },
                                      title: Text(
                                        snapshot.data.docs[index]
                                            ['buildingNumber'],
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
                                              deletebuildingNumber(
                                                  snapshot.data.docs[index]
                                                      ['buildingNumber']);
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
      );
    }));
  }

  Future<void> deletebuildingNumber(String buildingNumber) async {
    final provider = Provider.of<AllBuildingProvider>(context, listen: false);
    await FirebaseFirestore.instance
        .collection('buildingNumbers')
        .doc(buildingNumber)
        .delete();
    provider.removeData(buildingNumberList.indexOf(buildingNumber));
  }

  Future storeData(String buildingNumber) async {
    final provider = Provider.of<AllBuildingProvider>(context, listen: false);
    provider.setBuilderList([]);
    try {
      await FirebaseFirestore.instance
          .collection('buildingNumbers')
          .doc(buildingNumber)
          .set({
        'buildingNumber': buildingNumber,
      });
      provider.addSingleList({'buildingNumber': buildingNumber});
      // ignore: nullable_type_in_catch_clause
    } catch (e) {
      if (kDebugMode) {
        print('Error storing data: $e');
      }
    }
  }

  void popupmessage(String msg) {
    final provider = Provider.of<AllBuildingProvider>(context, listen: false);
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
                      buildingNumberController.clear();
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
