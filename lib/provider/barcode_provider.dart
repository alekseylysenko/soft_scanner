import 'package:flutter/foundation.dart';

class BarCodeProvider extends ChangeNotifier {
  String newCode = "";
  String newName = "";

  mutationCode(code) {
    newCode = code;
    notifyListeners();
  }
  mutationName(name) {
    newName = name;
    notifyListeners();
  }
}
