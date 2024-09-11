import 'package:flutter/material.dart';

class Screenchangeprovider extends ChangeNotifier {
  String _buildingNumber = '';
  String _floorNumber = '';
  String _roomNumber = '';
  String _asset = '';

  bool _isFloorScreen = false;
  bool _isRoomScreen = false;
  bool _isAssetScreen = false;

  String get buildingNumber => _buildingNumber;
  String get floorNumber => _floorNumber;
  String get roomNumber => _roomNumber;
  String get asset => _asset;

  bool get isFloorScreen => _isFloorScreen;
  bool get isRoomScreen => _isRoomScreen;
  bool get isAssetScreen => _isAssetScreen;

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
}
