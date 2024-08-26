import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_management_system/providers/userProvider.dart';
import 'package:ticket_management_system/utils/colors.dart';

class EditUserForm extends StatefulWidget {
  const EditUserForm({super.key, required this.fullName});
  final String fullName;

  @override
  State<EditUserForm> createState() => _EditUserFormState();
}

class _EditUserFormState extends State<EditUserForm> {
  TextEditingController workController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController selectedServiceProviderController =
      TextEditingController();
  bool isLoading = true;
  String messageForSocietyMember = '';
  List<String> userList = [];
  List<String> workList = [];
  String? selectedServiceProvider;
  bool isMultiCheckbox = false;
  String? selectedWork;
  List<String> selectedWorkList = [];
  List<dynamic> role = [];
  List<dynamic> roleList = [];
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    fetchData(widget.fullName).whenComplete(() => setState(() {
          selectedWorkList = roleList.map((e) => e.toString()).toList();
          isLoading = false;
        }));
    getWorks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Center(
              child: Text('User Form', style: TextStyle(color: Colors.white))),
          flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
            colors: [lightMarron, Color.fromRGBO(97, 4, 4, 0.875)],
          )))),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          height: MediaQuery.of(context).size.height * 0.80,
          width: MediaQuery.of(context).size.width * 0.60,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      child: Container(
                        color: Colors.white,
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.30,
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: fnameController,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            label: const Text('First Name'),
                            hintText: 'Enter First Name',
                            hintStyle: const TextStyle(fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      child: Container(
                        color: Colors.white,
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.30,
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: lnameController,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            label: const Text('Last Name'),
                            hintText: 'Enter Last Name',
                            hintStyle: const TextStyle(fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      child: Container(
                        color: Colors.white,
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.30,
                        child: TextFormField(
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          controller: mobileController,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            label: const Text('Mobile Number'),
                            hintText: 'Enter Mobile Number',
                            hintStyle: const TextStyle(fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      child: Container(
                        color: Colors.white,
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.30,
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: passwordController,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            label: const Text('Password'),
                            hintText: 'Enter Password',
                            hintStyle: const TextStyle(fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customDropDown(
                          'Select Work',
                          true,
                          workList,
                          "Search Work",
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: marron,
                          fixedSize: Size(
                            MediaQuery.of(context).size.width * 0.30,
                            45,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          updateData(
                                  fnameController.text,
                                  lnameController.text,
                                  mobileController.text,
                                  passwordController.text,
                                  selectedWorkList)
                              .whenComplete(() async {
                            await popupmessage('User Updated successfully!!');
                          });
                        }
                      },
                      child: const Center(
                        child: Text(
                          'Update User',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateData(String fname, String lname, String mobile,
      String password, List<String> role) async {
    String firstInitial = fname[0][0].trim().toUpperCase();
    String lastInitial = lname[0][0].trim().toUpperCase();
    String mobileLastFour = mobile.substring(mobile.length - 4);
    String fullName = '$fname $lname';

    String userId = '$firstInitial$lastInitial$mobileLastFour';
    final provider = Provider.of<AllUserProvider>(context, listen: false);
    await FirebaseFirestore.instance
        .collection('members')
        .doc(widget.fullName)
        .set({
      'userId': userId,
      'fullName': fullName,
      'fName': fname,
      'lName': lname,
      'mobile': mobile,
      'password': password,
      'role': role,
    });
    provider.addSingleList({'fullName': fullName});
  }

  Future<void> popupmessage(String msg) async {
    final provider = Provider.of<AllUserProvider>(context, listen: false);
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
                      fetchData(widget.fullName).whenComplete(() {
                        Navigator.pop(context);
                        Navigator.pop(context);

                        fnameController.clear();
                        lnameController.clear();
                        mobileController.clear();
                        passwordController.clear();
                        selectedServiceProvider = null;
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

  Future<void> getWorks() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('works').get();
    if (querySnapshot.docs.isNotEmpty) {
      List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();
      setState(() {
        workList = tempData;
      });
    }
  }

  Future<void> fetchData(String userId) async {
    final provider = Provider.of<AllUserProvider>(context, listen: false);
    DocumentSnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('members')
        .doc(userId)
        .get();
    if (querySnapshot.exists && querySnapshot.data() != null) {
      Map<String, dynamic> data = querySnapshot.data() as Map<String, dynamic>;
      fnameController.text = data['fName'] ?? '';
      lnameController.text = data['lName'] ?? '';
      mobileController.text = data['mobile'] ?? '';
      passwordController.text = data['password'] ?? '';
      role = data['role'] ?? 'No Roles';
    }

    provider.setBuilderList(userList);
    roleList = role;
    // print('roleList : $roleList');
  }

  Widget customDropDown(String title, bool isMultiCheckbox,
      List<String> customDropDownList, String hintText) {
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
              width: MediaQuery.of(context).size.width * 0.30,
              height: 40,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  dropdownSearchData: DropdownSearchData(
                    searchController: workController,
                    searchInnerWidgetHeight: 20,
                    searchInnerWidget: SizedBox(
                      height: 60, //: 42,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              width: 250,
                              height: 40,
                              child: TextFormField(
                                expands: true,
                                maxLines: null,
                                controller: workController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 2,
                                  ),
                                  hintText: hintText,
                                  hintStyle: const TextStyle(
                                    fontSize: 11,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      8,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 4, top: 5, bottom: 5),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: marron,
                                    fixedSize: Size(
                                      MediaQuery.of(context).size.width * 0.08,
                                      40,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Done',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: white,
                                  ),
                                ),
                              ),
                            )
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
                  // selectedItemBuilder: (context) {
                  //   return [
                  //     Text(
                  //       title,
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.w400,
                  //         fontSize: 11,
                  //         color: white,
                  //       ),
                  //       textAlign: TextAlign.left,
                  //     ),
                  //   ];
                  // },
                  hint: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  items: isMultiCheckbox
                      ? customDropDownList.map((item) {
                          // selectedWorkList =
                          //     roleList.map((e) => e.toString()).toList();
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

  Widget customShowBox(List<String> buildList, double widhtSize) {
    return Container(
      margin: const EdgeInsets.only(
        left: 35.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          5.0,
        ),
        border: Border.all(
          color: black,
        ),
      ),
      height:
          buildList.length > 3 ? MediaQuery.of(context).size.height * 0.15 : 50,
      width: MediaQuery.of(context).size.width * widhtSize,
      child: Column(
        children: [
          GridView.builder(
              itemCount: buildList.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3.5,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 3.0,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {},
                  child: Card(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          2.0,
                        ),
                        border: Border.all(
                          color: purple,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          buildList[index],
                          style: const TextStyle(
                              fontSize: 12,
                              color: black,
                              fontWeight: FontWeight.bold),
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
}
