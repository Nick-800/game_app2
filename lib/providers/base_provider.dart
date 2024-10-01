import 'package:flutter/foundation.dart';

class BaseProvider with ChangeNotifier {
  bool busy = false;

  void setBusy(bool value) {
    busy = value;
    notifyListeners();
  }
}
