import 'package:flutter/foundation.dart';
import 'package:flutter_mobile_command_tools/constants.dart';

class DevicesChangeNotifier extends ChangeNotifier {
  List<String> _deviceList = [];
  List<bool> checkDeviceList = [];

  int _index = 0;

  List<String> get deviceList => _deviceList;

  set deviceList(List<String> value) {
    _deviceList = value;
    checkDeviceList = List.filled(_deviceList.length, false);
    index = 0;
  }

  int get index => _index;

  set index(int value) {
    _index = value;
    for (int i = 0; i < checkDeviceList.length; i++) {
      if (value == i) {
        checkDeviceList[value] = true;
        Constants.currentDevice = _deviceList[value];
      } else {
        checkDeviceList[i] = false;
      }
    }
    notifyListeners();
  }
}
