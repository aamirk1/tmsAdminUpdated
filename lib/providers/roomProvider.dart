// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

class AllRoomProvider extends ChangeNotifier {
  bool _loadWidget = false;
  bool get loadWidget => _loadWidget;

  List<dynamic> _roomList = [];
  List<dynamic> get roomList => _roomList;

  void addList(List<dynamic> list) {
    _roomList = roomList;
    notifyListeners();
  }

  void setBuilderList(List<String> value) {
    _roomList = value;
    // notifyListeners();
  }

  void addSingleList(Map<String, dynamic> value) {
    _roomList.add(value);
    notifyListeners();
  }

  void removeData(int value) {
    _roomList.removeAt(value);
    notifyListeners();
  }

  void setLoadWidget(bool value) {
    _loadWidget = value;
    notifyListeners();
  }
}
