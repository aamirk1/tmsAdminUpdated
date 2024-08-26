import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_management_system/Master/itemMaster/editAssetForm.dart';
import 'package:ticket_management_system/providers/assetsProvider.dart';
import 'package:ticket_management_system/utils/colors.dart';

class ListOfAsset extends StatefulWidget {
  const ListOfAsset({super.key});

  @override
  State<ListOfAsset> createState() => _ListOfAssetState();
}

class _ListOfAssetState extends State<ListOfAsset> {
  TextEditingController assetController = TextEditingController();
  bool isLoading = true;
  List<String> assetList = [];
  @override
  void initState() {
    fetchData().whenComplete(() => setState(() {
          isLoading = false;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // fetchData();
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
                      width: 5,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          storeData(assetController.text).whenComplete(() {
                            popupmessage('Asset added successfully!!');
                          });
                        },
                        child: const Text('Save')),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Consumer<AllAssetProvider>(builder: (context, value, child) {
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
                              itemCount: value.assetList.length,
                              itemBuilder: (item, index) {
                                return Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        value.assetList[index],
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
                                                      EditAssetForm(
                                                    assetId: value
                                                        .assetList[index],
                                                  ),
                                                ),
                                              ).whenComplete(() {
                                                setState(() {
                                                  fetchData();
                                                  isLoading = false;
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
                                              deleteAsset(
                                                  value.assetList[index]);
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

  Future<void> fetchData() async {
    final provider = Provider.of<AllAssetProvider>(context, listen: false);
    provider.setBuilderList([]);
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('assets').get();
    if (querySnapshot.docs.isNotEmpty) {
      List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();
      assetList = tempData;
      provider.setBuilderList(assetList);
    }
  }

  Future<void> deleteAsset(String asset) async {
    final provider = Provider.of<AllAssetProvider>(context, listen: false);
    await FirebaseFirestore.instance.collection('assets').doc(asset).delete();
    // print('successfully deleted');

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
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(10),
                        //   child: Container(
                        //       color: Colors.white,
                        //       height: 40,
                        //       width: MediaQuery.of(context).size.width * 0.25,
                        //       child: Column(children: [
                        //         TextFormField(
                        //           expands: true,
                        //           maxLines: null,
                        //           controller: serviceProviderController,
                        //           decoration: InputDecoration(
                        //             isDense: true,
                        //             contentPadding: const EdgeInsets.symmetric(
                        //               horizontal: 10,
                        //               vertical: 8,
                        //             ),
                        //             hintText: 'Search flat no...',
                        //             hintStyle: const TextStyle(fontSize: 12),
                        //             border: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(8),
                        //             ),
                        //           ),
                        //         ),
                        //       ])),
                        // ),
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
                                    popupmessage('Asset added successfully!!');
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
    await FirebaseFirestore.instance.collection('assets').doc(asset).set({
      'asset': asset,
    });

    provider.addSingleList({
      'asset': asset,
    });
  }

  void popupmessage(String msg) {
    final provider = Provider.of<AllAssetProvider>(context, listen: false);
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
                        assetController.clear();
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
