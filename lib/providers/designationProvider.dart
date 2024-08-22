// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

class AllDesignationProvider extends ChangeNotifier {
  bool _loadWidget = false;
  bool get loadWidget => _loadWidget;

  List<dynamic> _designationList = [];
  List<dynamic> get designationList => _designationList;

  void addList(List<dynamic> list) {
    _designationList = designationList;
    notifyListeners();
  }

  void setBuilderList(List<String> value) {
    _designationList = value;
    // notifyListeners();
  }

  void addSingleList(Map<String, dynamic> value) {
    _designationList.add(value);
    notifyListeners();
  }

  void removeData(int value) {
    _designationList.removeAt(value);
    notifyListeners();
  }

  void setLoadWidget(bool value) {
    _loadWidget = value;
    notifyListeners();
  }
}
