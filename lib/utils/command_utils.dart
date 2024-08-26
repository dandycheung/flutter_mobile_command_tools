import 'package:flutter_mobile_command_tools/enum/command_type.dart';
import 'package:flutter_mobile_command_tools/model/command_request_model.dart';

///存储所有指令
class CommandUtils {
  /// 获取所有设备
  static CommandRequestModel getAndroidDevices({bool isShowLog = true}) {
    return _getModel("adb devices", CommandType.adb_devices,
        isShowLog: isShowLog);
  }

  static CommandRequestModel getCurrentActivity({bool isShowLog = true}) {
    return _getModel("adb shell dumpsys window | grep mCurrentFocus",
        CommandType.adb_current_activity,
        isShowLog: isShowLog);
  }

  static CommandRequestModel getCurrentFragment({bool isShowLog = true}) {
    return _getModel(
        "adb shell dumpsys  activity top", CommandType.adb_current_fragment,
        isShowLog: isShowLog);
  }

  static CommandRequestModel _getModel(String command, CommandType commandType,
      {bool isShowLog = true}) {
    return CommandRequestModel(command, commandType, isShowLog: isShowLog);
  }
}
