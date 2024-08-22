import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final isLoading = true.obs;
  final messageForSocietyMember = ''.obs;
  final userList = <String>[].obs;
  final selectedServiceProvider = Rx<String?>(null);
  final isMultiCheckbox = false.obs;
  final selectedWork = Rx<String?>(null);
  final selectedWorkList = <String>[].obs;
  final formKey = GlobalKey<FormState>();
  final _userData = {}.obs;

  Map get userData => _userData;

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

    _userData.value = {
      'userId': userId,
      'fullName': fullName,
      'fName': fname,
      'lName': lname,
      'mobile': mobile,
      'password': password,
      'role': role,
    };

    update();
  }

  Future<void> fetchData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('members').get();
    if (querySnapshot.docs.isNotEmpty) {
      List<String> tempData = querySnapshot.docs.map((e) => e.id).toList();
      userList.value = tempData;
      print('userList $userList');
    }
    update();
  }
}
