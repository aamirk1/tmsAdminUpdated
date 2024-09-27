import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportProvider extends ChangeNotifier {
  List<String> _buildingNumberList = [];
  List<String> _floorNumberList = [];
  List<String> _ticketNumberList = [];
  List<String> _roomNumberList = [];
  List<String> _assetList = [];
  List<String> _allWorkData = [];
  List<String> _serviceProviders = [];

  List<String> get buildingNumberList => _buildingNumberList;
  List<String> get floorNumberList => _floorNumberList;
  List<String> get ticketNumberList => _ticketNumberList;
  List<String> get roomNumberList => _roomNumberList;
  List<String> get assetNumberList => _assetList;
  List<String> get workNumberList => _allWorkData;
  List<String> get serviceProviders => _serviceProviders;

  String? _selectStatus;
  String? _selectedBuilding;
  String? _selectedFloor;
  String? _selectedRoom;
  String? _selectedWork;
  String? _selectedTicket;
  String? _selectedServiceProvider;
  String? _selectedAsset;

  String? get selectedStatus => _selectStatus;
  String? get selectedBuilding => _selectedBuilding;
  String? get selectedFloor => _selectedFloor;
  String? get selectedRoom => _selectedRoom;
  String? get selectedWork => _selectedWork;
  String? get selectedTicket => _selectedTicket;
  String? get selectedService => _selectedServiceProvider;
  String? get selectedAsset => _selectedAsset;

  void building(String value) {
    _selectedBuilding = value;
    notifyListeners();
  }

  void status(String value) {
    _selectStatus = value;
    notifyListeners();
  }

  void floor(String value) {
    _selectedFloor = value;
    notifyListeners();
  }

  void room(String value) {
    _selectedRoom = value;
    notifyListeners();
  }

  void work(String value) {
    _selectedWork = value;
    notifyListeners();
  }

  void ticket(String value) {
    _selectedTicket = value;
    notifyListeners();
  }

  void serviceProvider(String value) {
    _selectedServiceProvider = value;
    notifyListeners();
  }

  void asset(String value) {
    _selectedAsset = value;
    notifyListeners();
  }

  Future<void> fetchBuildingNumbers() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('buildingNumbers').get();
    if (querySnapshot.docs.isNotEmpty) {
      _buildingNumberList = querySnapshot.docs.map((e) => e.id).toList();
      notifyListeners();
    }
  }

  Future<void> fetchFloorNumbers() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('floors').get();
    if (querySnapshot.docs.isNotEmpty) {
      _floorNumberList = querySnapshot.docs.map((e) => e.id).toList();
      notifyListeners();
    }
    // Set<String> uniqueFloorSet = {};

    // for (var building in _buildingNumberList) {
    //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
    //       .collection('buildingNumbers')
    //       .doc(building)
    //       .collection('floorNumbers')
    //       .get();
    //   if (querySnapshot.docs.isNotEmpty) {
    //     uniqueFloorSet.addAll(querySnapshot.docs.map((e) => e.id).toList());
    //   }
    // }
    // _floorNumberList = uniqueFloorSet.toList();
    // notifyListeners();
  }

  Future<void> fetchTicketNumbers() async {
    List<String> dates = [];
    List<String> tickets = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('raisedTickets').get();

    if (querySnapshot.docs.isNotEmpty) {
      dates = querySnapshot.docs.map((e) => e.id).toList();
    }
    for (var date in dates) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('raisedTickets')
          .doc(date)
          .collection('tickets')
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        // Access the document's data as a Map
        tickets = querySnapshot.docs.map((e) => e.id).toList();
      }
    }

    _ticketNumberList = tickets.toList();
    notifyListeners();
  }

  Future<void> fetchRoomNumbers() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('rooms').get();
    if (querySnapshot.docs.isNotEmpty) {
      _roomNumberList = querySnapshot.docs.map((e) => e.id).toList();
      notifyListeners();
    }
    // Set<String> uniqueRoomSet = {};
    // for (var building in _buildingNumberList) {
    //   for (var floor in _floorNumberList) {
    //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
    //         .collection('buildingNumbers')
    //         .doc(building)
    //         .collection('floorNumbers')
    //         .doc(floor)
    //         .collection('roomNumbers')
    //         .get();
    //     if (querySnapshot.docs.isNotEmpty) {
    //       uniqueRoomSet.addAll(querySnapshot.docs.map((e) => e.id).toList());
    //     }
    //   }
    // }
    // _roomNumberList = uniqueRoomSet.toList();
    // notifyListeners();
  }

  Future<void> fetchAssets() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('assets').get();
    if (querySnapshot.docs.isNotEmpty) {
      _assetList = querySnapshot.docs.map((e) => e.id).toList();
      notifyListeners();
    }
    // Set<String> uniqueAssetSet = {};
    // for (var building in _buildingNumberList) {
    //   for (var floor in _floorNumberList) {
    //     for (var room in _roomNumberList) {
    //       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
    //           .collection('buildingNumbers')
    //           .doc(building)
    //           .collection('floorNumbers')
    //           .doc(floor)
    //           .collection('roomNumbers')
    //           .doc(room)
    //           .collection('assets')
    //           .get();
    //       if (querySnapshot.docs.isNotEmpty) {
    //         uniqueAssetSet.addAll(querySnapshot.docs.map((e) => e.id).toList());
    //       }
    //     }
    //   }
    // }
    // _assetList = uniqueAssetSet.toList();
    // notifyListeners();
  }

  Future<void> fetchWorkList() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('works').get();
    if (querySnapshot.docs.isNotEmpty) {
      _allWorkData = querySnapshot.docs.map((e) => e.id).toList();
      notifyListeners();
    }
  }

  Future<void> fetchServiceProvider() async {
    try {
      // Clear existing data
      _serviceProviders = [];

      // Fetch document IDs from 'members' collection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('members')
          .where('role', isNotEqualTo: null)
          .get();

      List<String> tempData = [];
      if (querySnapshot.docs.isNotEmpty) {
        tempData = querySnapshot.docs.map((e) => e.id).toList();
      }

      // Fetch each document and add to serviceProviders
      for (var id in tempData) {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('members')
            .doc(id)
            .get();

        if (documentSnapshot.exists) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          if (data.containsKey('fullName')) {
            _serviceProviders.add(data['fullName']);
          }
        }
      }

      // Notify listeners after updating the list
      notifyListeners();
    } catch (e) {
      // Handle any errors (optional)
      print('Error fetching service providers: $e');
    }
  }

  void resetSelections() {
    _selectStatus = null;
    _selectedFloor = null;
    _selectedTicket = null;
    _selectedRoom = null;
    _selectStatus = null;
    _selectedBuilding = null;
    _selectedFloor = null;
    _selectedRoom = null;
    _selectedWork = null;
    _selectedAsset = null;
    _selectedServiceProvider = null;
    notifyListeners();
  }
}