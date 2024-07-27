import 'package:flutter/material.dart';

class LocationProvider with ChangeNotifier {
  bool isLoading = false;

  void openLocationloading() {
    isLoading = true;
    notifyListeners();
  }

  void closeLocationloading() {
    isLoading = false;
    notifyListeners();
  }
}
