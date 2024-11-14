// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

class AllServiceProviderProvider extends ChangeNotifier {
  bool _loadWidget = false; // Track loading state
  bool get loadWidget => _loadWidget;

  List<String> _serviceProviderList = []; // List to store service provider names
  List<String> get serviceProviderList => _serviceProviderList;

  // Set the list of service providers
  void setServiceProviderList(List<String> value) {
    _serviceProviderList = value;
    notifyListeners(); // Notify listeners to update UI
  }

  // Add a single service provider to the list
  void addSingleServiceProvider(String value) {
    _serviceProviderList.add(value);
    notifyListeners(); // Notify listeners to update UI
  }

  // Remove a service provider by index
  void removeServiceProvider(int index) {
    _serviceProviderList.removeAt(index);
    notifyListeners(); // Notify listeners to update UI
  }

  // Clear the entire service provider list
  void clearServiceProviderList() {
    _serviceProviderList.clear();
    notifyListeners(); // Notify listeners to update UI
  }

  // Set the loading state (e.g., when fetching data from a database)
  void setLoadWidget(bool value) {
    _loadWidget = value;
    notifyListeners(); // Notify listeners to update UI
  }
}
