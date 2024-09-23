// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

class AllworkListByAssets extends ChangeNotifier {
  bool _loadWidget = false;
  bool get loadWidget => _loadWidget;

  List<dynamic> _workListByAsset = [];
  List<dynamic> get workListByAsset => _workListByAsset;


  void addList(List<dynamic> list) {
    _workListByAsset = workListByAsset;
    notifyListeners();
  }

  void setBuilderList(List<String> value) {
    _workListByAsset = value;
    // notifyListeners();
  }

  void addSingleList(Map<String, dynamic> value) {
    _workListByAsset.add(value);
    notifyListeners();
  }

  void removeData(int value) {
    _workListByAsset.removeAt(value);
    notifyListeners();
  }

  void setLoadWidget(bool value) {
    _loadWidget = value;
    notifyListeners();
  }
}
