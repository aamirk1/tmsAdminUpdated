// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

class AllWorkProvider extends ChangeNotifier {
  bool _loadWidget = false;
  bool get loadWidget => _loadWidget;

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

  void addSingleList(Map<String, dynamic> value) {
    _workList.add(value);
    notifyListeners();
  }

  void removeData(int value) {
    _workList.removeAt(value);
    notifyListeners();
  }

  void setLoadWidget(bool value) {
    _loadWidget = value;
    notifyListeners();
  }
}
