import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_management_system/Master/work/editWorkForm.dart';
import 'package:ticket_management_system/providers/workProvider.dart';
import 'package:ticket_management_system/utils/colors.dart';

class ListOfWork extends StatefulWidget {
  const ListOfWork({super.key});

  @override
  State<ListOfWork> createState() => _ListOfWorkState();
}

class _ListOfWorkState extends State<ListOfWork> {
  TextEditingController workController = TextEditingController();
  bool isLoading = true;
  List<String> workList = [];
  Stream? _stream;
  @override
  void initState() {
    _stream = FirebaseFirestore.instance.collection('works').snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.40,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      color: Colors.white,
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.30,
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        expands: true,
                        maxLines: null,
                        controller: workController,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          hintText: 'Add Work',
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
                        storeData(workController.text).whenComplete(() {
                          popupmessage('Work added successfully!!');
                        });
                      },
                      child: const Text('Save')),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.60,
            width: MediaQuery.of(context).size.width * 0.40,
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
                                        snapshot.data.docs[index]['work'],
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
                                                      EditWorkForm(
                                                    workId: snapshot.data
                                                        .docs[index]['work'],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              deleteWork(snapshot
                                                  .data.docs[index]['work']);
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

  Future<void> fetchData() async {
    final provider = Provider.of<AllWorkProvider>(context, listen: false);
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('works').get();
    if (querySnapshot.docs.isNotEmpty) {
      List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();
      workList = tempData;
    }

    provider.setBuilderList(workList);
  }

  Future<void> deleteWork(String work) async {
    final provider = Provider.of<AllWorkProvider>(context, listen: false);
    await FirebaseFirestore.instance.collection('works').doc(work).delete();

    provider.removeData(provider.workList.indexOf(work));
  }

  Future storeData(String work) async {
    final provider = Provider.of<AllWorkProvider>(context, listen: false);
    await FirebaseFirestore.instance.collection('works').doc(work).set({
      'work': work,
    });
    provider.addSingleList({
      'work': work,
    });
  }

  Future updateData(String work) async {
    final provider = Provider.of<AllWorkProvider>(context, listen: false);
    await FirebaseFirestore.instance.collection('works').doc(work).set({
      'work': work,
    });
    provider.addSingleList({
      'work': work,
    });
  }

  void popupmessage(String msg) {
    final provider = Provider.of<AllWorkProvider>(context, listen: false);
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
                        workController.clear();
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
