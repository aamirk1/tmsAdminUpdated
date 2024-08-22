// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

class AllUserProvider extends ChangeNotifier {
  bool _loadWidget = false;
  bool get loadWidget => _loadWidget;

  List<dynamic> _userList = [];
  List<dynamic> get userList => _userList;

  void addList(List<dynamic> list) {
    _userList = userList;
    notifyListeners();
  }

  void setBuilderList(List<String> value) {
    _userList = value;
    // notifyListeners();
  }

  void addSingleList(Map<String, dynamic> value) {
    _userList.add(value);
    notifyListeners();
  }

  void removeData(int value) {
    _userList.removeAt(value);
    notifyListeners();
  }

  void setLoadWidget(bool value) {
    _loadWidget = value;
    notifyListeners();
  }
}
