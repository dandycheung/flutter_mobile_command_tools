import 'package:flutter/foundation.dart';

class CenterWidgetChangeNotifier extends ChangeNotifier {
  double _centerWidth = 200;
  bool _isClick = false;

  double get centerWidth => _centerWidth;

  set centerWidth(double value) {
    _centerWidth = value;
    notifyListeners();
  }

  bool get isClick => _isClick;

  set isClick(bool value) {
    _isClick = value;
    notifyListeners();
  }
}
