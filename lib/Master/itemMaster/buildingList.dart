import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_management_system/Master/itemMaster/editBuildingForm.dart';
import 'package:ticket_management_system/providers/buildingProvider.dart';
import 'package:ticket_management_system/utils/colors.dart';

class BuildingList extends StatefulWidget {
  const BuildingList({super.key});

  @override
  State<BuildingList> createState() => _BuildingListState();
}

class _BuildingListState extends State<BuildingList> {
  TextEditingController buildingNumberController = TextEditingController();
  List<String> buildingNumberList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData().whenComplete(() => setState(() {
          isLoading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
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
                          controller: buildingNumberController,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            hintText: 'Add Building No',
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
                          storeData(buildingNumberController.text)
                              .whenComplete(() {
                            popupmessage('Building No. added successfully!!');
                          });
                        },
                        child: const Text('Save')),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Consumer<AllBuildingProvider>(builder: (context, value, child) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Card(
                      elevation: 10,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: value.buildingList.length,
                                itemBuilder: (item, index) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                          value.buildingList[index],
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
                                                        EditBuildingForm(
                                                      buildingId: value
                                                          .buildingList[index],
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
                                                deletebuildingNumber(
                                                    value.buildingList[index]);
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
                    ),
                  );
                }),
              ],
            ),
    );
  }

  Future<void> fetchData() async {
    final provider = Provider.of<AllBuildingProvider>(context, listen: false);
    provider.setBuilderList([]);
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('buildingNumbers').get();
    if (querySnapshot.docs.isNotEmpty) {
      List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();
      buildingNumberList = tempData;
      provider.setBuilderList(buildingNumberList);
    }
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
                      fetchData().whenComplete(() {
                        Navigator.pop(context);
                        buildingNumberController.clear();
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
