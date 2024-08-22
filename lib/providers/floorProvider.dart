// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

class AllFloorProvider extends ChangeNotifier {
  bool _loadWidget = false;
  bool get loadWidget => _loadWidget;

  List<dynamic> _floorList = [];
  List<dynamic> get floorList => _floorList;

  void addList(List<dynamic> list) {
    _floorList = floorList;
    notifyListeners();
  }

  void setBuilderList(List<String> value) {
    _floorList = value;
    // notifyListeners();
  }

  void addSingleList(Map<String, dynamic> value) {
    _floorList.add(value);
    notifyListeners();
  }

  void removeData(int value) {
    _floorList.removeAt(value);
    notifyListeners();
  }

  void setLoadWidget(bool value) {
    _loadWidget = value;
    notifyListeners();
  }
}
