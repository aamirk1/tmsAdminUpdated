import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ticket_management_system/Master/createUser/editUserForm.dart';
import 'package:ticket_management_system/Master/createUser/userDetails.dart';
import 'package:ticket_management_system/providers/userProvider.dart';
import 'package:ticket_management_system/providers/workProvider.dart';
import 'package:ticket_management_system/utils/colors.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key, required this.adminId});
  final String adminId;

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  TextEditingController workController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController selectedServiceProviderController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();
  int _selectedIndex = 0;
  List<String> workList = [];
  List<String> userData = [];
  String? selectedServiceProvider;
  bool isMultiCheckbox = false;
  String? selectedWork;
  List<String> selectedWorkList = [];
  bool isShowUserDetails = false;
  bool isLoading = true;
  @override
  void initState() {
    getWorks();
    fetchData().whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
    // Get.put(UserController()).isLoading.value = false;
    // print(userData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Card(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
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
                                const SizedBox(
                                  height: 4,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  child: Container(
                                    color: Colors.white,
                                    height: 60,
                                    width: MediaQuery.of(context).size.width *
                                        0.30,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter First Name';
                                        }
                                        return null;
                                      },
                                      textInputAction: TextInputAction.next,
                                      controller: fnameController,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 8,
                                        ),
                                        label: const Text('First Name'),
                                        hintText: 'Enter First Name',
                                        hintStyle:
                                            const TextStyle(fontSize: 12),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                    width: MediaQuery.of(context).size.width *
                                        0.30,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter Last Name';
                                        }
                                        return null;
                                      },
                                      textInputAction: TextInputAction.next,
                                      controller: lnameController,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 8,
                                        ),
                                        label: const Text('Last Name'),
                                        hintText: 'Enter Last Name',
                                        hintStyle:
                                            const TextStyle(fontSize: 12),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                      horizontal: 10, vertical: 4),
                                  child: Container(
                                    color: Colors.white,
                                    height: 60,
                                    width: MediaQuery.of(context).size.width *
                                        0.30,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter Mobile Number';
                                        }
                                        return null;
                                      },
                                      maxLength: 10,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      controller: mobileController,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 8,
                                        ),
                                        label: const Text('Mobile Number'),
                                        hintText: 'Enter Mobile Number',
                                        hintStyle:
                                            const TextStyle(fontSize: 12),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                      horizontal: 10, vertical: 4),
                                  child: Container(
                                    color: Colors.white,
                                    height: 60,
                                    width: MediaQuery.of(context).size.width *
                                        0.30,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter Password';
                                        }
                                        return null;
                                      },
                                      textInputAction: TextInputAction.next,
                                      controller: passwordController,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 8,
                                        ),
                                        label: const Text('Password'),
                                        hintText: 'Enter Password',
                                        hintStyle:
                                            const TextStyle(fontSize: 12),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: marron,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      storeData(
                                              fnameController.value.text,
                                              lnameController.value.text,
                                              mobileController.value.text,
                                              passwordController.value.text,
                                              selectedWorkList)
                                          .whenComplete(() async {
                                        await popupmessage(
                                            'User created successfully!!');
                                      });
                                    }
                                  },
                                  child: const Center(
                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Card(
                        elevation: 10,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SingleChildScrollView(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Consumer<AllUserProvider>(
                                      builder: (context, value, child) {
                                    return SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.7,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: userData.length,
                                          itemBuilder: (item, index) {
                                            return Column(
                                              children: [
                                                ListTile(
                                                  onTap: () {
                                                    _selectedIndex = index;
                                                    setState(() {
                                                      isShowUserDetails =
                                                          !isShowUserDetails;
                                                    });
                                                    // Get.to(
                                                    //   UserDetails(
                                                    //     adminId: widget.adminId,
                                                    //     userId: userData[index],
                                                    //   ),
                                                    // );
                                                  },
                                                  title: Text(
                                                    userData[index],
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  trailing: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
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
                                                                  EditUserForm(
                                                                userId:
                                                                    userData[
                                                                        index],
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
                                                          deleteUser(
                                                            userData[index],
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
                                          }),
                                    );
                                  })),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.75,
                            width: MediaQuery.of(context).size.width,
                            child: isShowUserDetails
                                ? UserDetails(
                                    userId: userData[_selectedIndex].toString(),
                                  )
                                : Container())),
                  ],
                ),
              ));
  }

  Future<void> deleteUser(String userId) async {
    final provider = Provider.of<AllUserProvider>(context, listen: false);
    await FirebaseFirestore.instance.collection('members').doc(userId).delete();
    provider.removeData(provider.userList.indexOf(userId));
  }

  Future<void> editUser(String userId) async {
    await FirebaseFirestore.instance.collection('members').doc(userId).delete();
  }

// Store User Data

  Future<void> popupmessage(String msg) async {
    Get.defaultDialog(
      middleText: msg,
      actions: [
        TextButton(
          onPressed: () async {
            Get.back();
            Get.back();
            fnameController.clear();
            lnameController.clear();
            mobileController.clear();
            passwordController.clear();
            selectedServiceProvider = null;
          },
          child: const Text(
            'OK',
            style: TextStyle(color: Colors.green),
          ),
        ),
      ],
    );
  }

  Future<void> getWorks() async {
    final provider = Provider.of<AllWorkProvider>(context, listen: false);
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('works').get();
    if (querySnapshot.docs.isNotEmpty) {
      List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();
      workList = tempData;
    }

    provider.setBuilderList(workList);
    print('workList $workList');
  }

  // Future<void> fetchData() async {
  //   QuerySnapshot querySnapshot =
  //       await FirebaseFirestore.instance.collection('members').get();
  //   if (querySnapshot.docs.isNotEmpty) {
  //     List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();
  //     Get.put(UserController()).userList.value = tempData;
  //     print(Get.put(UserController()).userList);
  //   }
  // }

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
              width: MediaQuery.of(context).size.width * 0.25,
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
                              width: 230,
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
                                      4,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 2.0, right: 2, top: 6, bottom: 5),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: marron,
                                    minimumSize: Size(
                                      MediaQuery.of(context).size.width * 0.04,
                                      50,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    )),
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    storeData(
                                            fnameController.value.text,
                                            lnameController.value.text,
                                            mobileController.value.text,
                                            passwordController.value.text,
                                            selectedWorkList)
                                        .whenComplete(() async {
                                      await popupmessage(
                                          'User created successfully!!');
                                    });
                                  }
                                },
                                child: const Text(
                                  'Save',
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

  Future<void> storeData(String fname, String lname, String mobile,
      String password, List<String> role) async {
    String firstInitial = fname[0][0].trim().toUpperCase();
    String lastInitial = lname[0][0].trim().toUpperCase();
    String mobileLastFour = mobile.substring(mobile.length - 4);
    String fullName = '$fname $lname';

    String userId = '$firstInitial$lastInitial$mobileLastFour';

    await FirebaseFirestore.instance.collection('members').doc(userId).set({
      'userId': userId,
      'fullName': fullName,
      'fName': fname,
      'lName': lname,
      'mobile': mobile,
      'password': password,
      'role': role,
    });

    // _userData.value = {
    //   'userId': userId,
    //   'fullName': fullName,
    //   'fName': fname,
    //   'lName': lname,
    //   'mobile': mobile,
    //   'password': password,
    //   'role': role,
    // };

    // setState(() {});
  }

  Future<void> fetchData() async {
    final provider = Provider.of<AllUserProvider>(context, listen: false);
    provider.setBuilderList([]);
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('members').get();
    if (querySnapshot.docs.isNotEmpty) {
      List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();
      userData = tempData;
    }
    setState(() {});
    print('userList $userData');
  }
}
