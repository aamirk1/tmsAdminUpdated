// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

class AllAssetProvider extends ChangeNotifier {
  bool _loadWidget = false;
  bool get loadWidget => _loadWidget;

  List<dynamic> _assetList = [];
  List<dynamic> get assetList => _assetList;

  void addList(List<dynamic> list) {
    _assetList = assetList;
    notifyListeners();
  }

  void setBuilderList(List<String> value) {
    _assetList = value;
    // notifyListeners();
  }

  void addSingleList(Map<String, dynamic> value) {
    _assetList.add(value);
    notifyListeners();
  }

  void removeData(int value) {
    _assetList.removeAt(value);
    notifyListeners();
  }

  void setLoadWidget(bool value) {
    _loadWidget = value;
    notifyListeners();
  }
}
