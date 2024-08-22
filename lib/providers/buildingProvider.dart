// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

class AllBuildingProvider extends ChangeNotifier {
  bool _loadWidget = false;
  bool get loadWidget => _loadWidget;

  List<dynamic> _buildingList = [];
  List<dynamic> get buildingList => _buildingList;

  void addList(List<dynamic> list) {
    _buildingList = buildingList;
    notifyListeners();
  }

  void setBuilderList(List<String> value) {
    _buildingList = value;
    // notifyListeners();
  }

  void addSingleList(Map<String, dynamic> value) {
    _buildingList.add(value);
    notifyListeners();
  }

  void removeData(int value) {
    _buildingList.removeAt(value);
    notifyListeners();
  }

  void setLoadWidget(bool value) {
    _loadWidget = value;
    notifyListeners();
  }
}
