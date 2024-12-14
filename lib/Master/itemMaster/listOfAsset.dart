import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_management_system/providers/assetsProvider.dart';
import 'package:ticket_management_system/providers/screenChangeProvider.dart';
import 'package:ticket_management_system/utils/colors.dart';
import 'package:ticket_management_system/utils/loading_page.dart';

// ignore: must_be_immutable
class ListOfAsset extends StatefulWidget {
  ListOfAsset(
      {super.key,
      required this.buildingId,
      required this.floorId,
      required this.roomId});
  String buildingId;
  String floorId;
  String roomId;

  @override
  State<ListOfAsset> createState() => _ListOfAssetState();
}

class _ListOfAssetState extends State<ListOfAsset> {
  TextEditingController assetController = TextEditingController();
  bool isLoading = true;
  List<String> assetList = [];

  List<String> workList = [];
  bool isWorkScreen = false;

  Screenchangeprovider provider = Screenchangeprovider();
  Stream? _stream;
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
        .snapshots();
    // fetchData().whenComplete(() => setState(() {
    //       isLoading = false;
    //     }));
    getWorks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // fetchData();
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
                    controller: assetController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      hintText: 'Add Asset',
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
                    storeData(assetController.text).whenComplete(() {
                      assetController.clear();
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
                                      selected:
                                          index == provider.selectedAssetIndex,
                                      selectedTileColor: lightMarron,
                                      onTap: () {
                                        provider.setAssetIndex(index);
                                        widget.buildingId;
                                        widget.floorId;
                                        widget.roomId;

                                        provider.setAssetNumber(
                                            snapshot.data.docs[index]['asset']);
                                        provider.isWorkScreen == true
                                            ? provider.setIsWorkScreen(false)
                                            : provider.setIsWorkScreen(true);
                                      },
                                      title: Text(
                                        snapshot.data.docs[index]['asset'],
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
                                              deleteAsset(snapshot
                                                  .data.docs[index]['asset']);
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

  Future<void> deleteAsset(String asset) async {
    final provider = Provider.of<AllAssetProvider>(context, listen: false);
    await FirebaseFirestore.instance
        .collection('buildingNumbers')
        .doc(widget.buildingId)
        .collection('floorNumbers')
        .doc(widget.floorId)
        .collection('roomNumbers')
        .doc(widget.roomId)
        .collection('assets')
        .doc(asset)
        .delete();
    // print('successfully deleted');
    await FirebaseFirestore.instance.collection('assets').doc(asset).delete();
    // provider.removeData(assetList.indexOf(asset));
    provider.removeData(assetList.indexOf(asset));
    print('successfully deletedw');
  }

  void addAsset() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: [
              Center(
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            color: Colors.white,
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: TextFormField(
                              textInputAction: TextInputAction.done,
                              expands: true,
                              maxLines: null,
                              controller: assetController,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                hintText: 'Add Asset',
                                hintStyle: const TextStyle(fontSize: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                     
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel')),
                            ElevatedButton(
                                onPressed: () {
                                  storeData(assetController.text)
                                      .whenComplete(() {
                                    assetController.clear();
                                  });
                                },
                                child: const Text('Save'))
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  Future storeData(String asset) async {
    final provider = Provider.of<AllAssetProvider>(context, listen: false);
    await FirebaseFirestore.instance
        .collection('buildingNumbers')
        .doc(widget.buildingId)
        .collection('floorNumbers')
        .doc(widget.floorId)
        .collection('roomNumbers')
        .doc(widget.roomId)
        .collection('assets')
        .doc(asset)
        .set({'asset': asset, 'workListByAsset': 'Work not assign'});
    FirebaseFirestore.instance
        .collection('assets')
        .doc(asset)
        .set({'asset': asset, 'workListByAsset': 'Work not assign'});

    provider.addSingleList({
      'asset': asset,
    });
  }

  Future<void> getWorks() async {
    // final provider = Provider.of<AllWorkProvider>(context, listen: false);
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('works').get();
    if (querySnapshot.docs.isNotEmpty) {
      List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();
      workList = tempData;
    }

    provider.setBuilderList(workList);
    print('workList $workList');
  }
}
