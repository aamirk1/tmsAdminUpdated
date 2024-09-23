import 'package:flutter/material.dart';

class Screenchangeprovider extends ChangeNotifier {
  String _buildingNumber = '';
  String _floorNumber = '';
  String _roomNumber = '';
  String _asset = '';
  String _work = '';

  bool _isFloorScreen = false;
  bool _isRoomScreen = false;
  bool _isAssetScreen = false;
  bool _isWorkScreen = false;

  int _selectedbuildingIndex = 0;
  int _selectedfloorIndex = 0;
  int _selectedroomIndex = 0;
  int _selectedAssetIndex = 0;

  String get buildingNumber => _buildingNumber;
  String get floorNumber => _floorNumber;
  String get roomNumber => _roomNumber;
  String get asset => _asset;
  String get work => _work;

  bool get isFloorScreen => _isFloorScreen;
  bool get isRoomScreen => _isRoomScreen;
  bool get isAssetScreen => _isAssetScreen;
  bool get isWorkScreen => _isWorkScreen;

  int get selectedbuildingIndex => _selectedbuildingIndex;
  int get selectedfloorIndex => _selectedfloorIndex;
  int get selectedroomIndex => _selectedroomIndex;
  int get selectedAssetIndex => _selectedAssetIndex;

  void setBuildingNumber(String value) {
    _buildingNumber = value;
    notifyListeners();
  }

  void setFloorNumber(String value) {
    _floorNumber = value;
    notifyListeners();
  }

  void setRoomNumber(String value) {
    _roomNumber = value;
    notifyListeners();
  }

  void setAssetNumber(String value) {
    _asset = value;
    notifyListeners();
  }

  void setWorkNumber(String value) {
    _work = value;
    notifyListeners();
  }

// boolean variable

  void setIsFloorScreen(bool value) {
    _isFloorScreen = value;
    notifyListeners();
  }

  void setIsRoomScreen(bool value) {
    _isRoomScreen = value;
    notifyListeners();
  }

  void setIsAssetScreen(bool value) {
    _isAssetScreen = value;
    notifyListeners();
  }

    void setIsWorkScreen(bool value) {
    _isWorkScreen = value;
    notifyListeners();
  }

  // index
  void setBuildingIndex(int value) {
    _selectedbuildingIndex = value;
    notifyListeners();
  }

  void setFloorIndex(int value) {
    _selectedfloorIndex = value;
    notifyListeners();
  }

  void removeFloorIndex(int value) {
    // _selectedfloorIndex = null;
    notifyListeners();
  }

  void setRoomIndex(int value) {
    _selectedroomIndex = value;
    notifyListeners();
  }

  void setAssetIndex(int value) {
    _selectedAssetIndex = value;
    notifyListeners();
  }

  void removeRoomIndex(int value) {
    // _selectedfloorIndex.removeAt(value);
    notifyListeners();
  }



  // fetch worklist
  List<dynamic> _workList = [];
  List<dynamic> get workList => _workList;

  void addList(List<dynamic> list) {
    _workList = workList;
    notifyListeners();
  }

  void setBuilderList(List<String> value) {
    _workList = value;
    // notifyListeners();
  }

}
