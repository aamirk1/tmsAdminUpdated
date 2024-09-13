import 'package:flutter/material.dart';

class Screenchangeprovider extends ChangeNotifier {
  String _buildingNumber = '';
  String _floorNumber = '';
  String _roomNumber = '';
  String _asset = '';

  bool _isFloorScreen = false;
  bool _isRoomScreen = false;
  bool _isAssetScreen = false;

  int _selectedbuildingIndex = 0;
  int _selectedfloorIndex = 0;
  int _selectedroomIndex = 0;

  String get buildingNumber => _buildingNumber;
  String get floorNumber => _floorNumber;
  String get roomNumber => _roomNumber;
  String get asset => _asset;

  bool get isFloorScreen => _isFloorScreen;
  bool get isRoomScreen => _isRoomScreen;
  bool get isAssetScreen => _isAssetScreen;

  int get selectedbuildingIndex => _selectedbuildingIndex;
  int get selectedfloorIndex => _selectedfloorIndex;
  int get selectedroomIndex => _selectedroomIndex;

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

  void removeRoomIndex(int value) {
    // _selectedfloorIndex.removeAt(value);
    notifyListeners();
  }
}
