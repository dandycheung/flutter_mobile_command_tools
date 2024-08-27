import 'dart:io';

import 'package:flutter_mobile_command_tools/base/base_run_command.dart';
import 'package:flutter_mobile_command_tools/constants.dart';
import 'package:flutter_mobile_command_tools/enum/command_type.dart';
import 'package:flutter_mobile_command_tools/model/command_request_model.dart';
import 'package:flutter_mobile_command_tools/model/command_response_model.dart';
import 'package:flutter_mobile_command_tools/utils/platform_utils.dart';

class AdbRunCommand extends BaseRunCommand {
  ///检测adb的路径
  @override
  bool checkCommandPath(String executable) {
    if (Constants.adbPath == "") {
      return false;
    }
    return super.checkCommandPath(executable);
  }

  @override
  dynamic runCommand(CommandRequestModel requestModel, {isSync = false}) {
    if (requestModel.command.startsWith("adb")) {
      requestModel.command =
          requestModel.command.replaceFirst("adb", '').trim();
      requestModel.executable = Constants.adbPath;
    }
    return super.runCommand(requestModel, isSync: isSync);
  }

  /// 核实参数
  @override
  List<String> checkArguments(List<String> arguments) {
    arguments = arguments.map((e) {
      if (e.trim() == "grep") {
        return PlatformUtils.grepFindStr();
      }
      return e;
    }).toList();
    if (Constants.currentDevice.isNotEmpty) {
      if (arguments[0] != Constants.ADB_CONNECT_DEVICES &&
          arguments[0] != Constants.ADB_WIRELESS_DISCONNECT &&
          arguments[0] != Constants.ADB_WIRELESS_CONNECT &&
          arguments[0] != Constants.ADB_VERSION) {
        arguments = ["-s", Constants.currentDevice]..addAll(arguments);
      }
    }
    return arguments;
  }

  ///解析数据
  @override
  CommandResponseModel parseData(
      CommandRequestModel requestModel, ProcessResult processResult) {
    if (processResult.stderr != "") {
      if (processResult.stderr
          .toString()
          .contains("more than one device/emulator")) {
        return CommandResponseModel(false, "当前设备大于等于两个,请先手动获取设备");
      }
      return CommandResponseModel(false, processResult.stderr);
    }
    String data = processResult.stdout;
    switch (requestModel.commandType) {
      case CommandType.adb_devices:
        if (data.contains("List of devices attached")) {
          List<String> devices = data.split(PlatformUtils.getLineBreak());
          List<String> currentDevices = [];
          devices.forEach((element) {
            if (element.isNotEmpty && element != "List of devices attached") {
              if (!element.contains("offline") &&
                  !element.contains("unauthorized")) {
                currentDevices.add(element.split("\t")[0]);
              } else {
                currentDevices.add(element);
              }
            }
          });
          if (currentDevices.length > 0) {
            return CommandResponseModel(true, currentDevices);
          } else {
            return CommandResponseModel(false, "无设备连接");
          }
        } else {
          return CommandResponseModel(false, data);
        }
      case CommandType.adb_current_activity:
        String result =
            data.split(" ")[data.split(" ").length - 1].replaceAll("}", "");
        return CommandResponseModel(true, result);
      case CommandType.adb_current_fragment:
        List<String> values = data.split('\n');
        bool isVisibleFragment = false;
        List<String> listFragment = [];
        for (int i = values.length - 1; i > 0; i--) {
          //处理9.0版本手机顶级activity信息过滤改为mResumedActivity
          if (values[i].contains("mHidden=false")) {
            isVisibleFragment = true;
          }

          if (!isVisibleFragment) {
            continue;
          }
          if (values[i].contains("id=") &&
              values[i].contains("Fragment") &&
              !values[i].contains("#")) {
            print(values[i]);
            List<String> listActivity = values[i].split(" ");
            listActivity.removeWhere((e) => e.isEmpty);
            listFragment.add(
                listActivity[0].substring(0, listActivity[0].indexOf("{")));
            isVisibleFragment = false;
          }
          if (values[i].contains("error:")) {
            return CommandResponseModel(false, values[i]);
          }
        }
        if (listFragment.isNotEmpty) {
          return CommandResponseModel(true, listFragment.join("->"));
        }
        return CommandResponseModel(false, "无信息");
      case CommandType.adb_current_package:
        return CommandResponseModel(true, data);
      // case Constants.ADB_GET_PACKAGE:
      //   List<String> values = data.split('\n');
      //   for (int i = values.length - 1; i > 0; i--) {
      //     //处理9.0版本手机顶级activity信息过滤改为mResumedActivity
      //     if (values[i].contains("mFocusedActivity") ||
      //         values[i].contains("mResumedActivity") ||
      //         values[i].contains("mCurrentFocus")) {
      //       int a = values[i].indexOf("u0");
      //       int b = values[i].indexOf('/');
      //       String packageName = values[i].substring(a + 3, b);
      //       LogUtils.printLog(packageName);
      //       return CommandResponseModel(true, packageName);
      //     }
      //     if (values[i].contains("error:")) {
      //       return CommandResponseModel(false, values[i]);
      //     }
      //   }
      //   return CommandResponseModel(false, "无信息");
      // case Constants.ADB_GET_THIRD_PACKAGE:
      // case Constants.ADB_GET_SYSTEM_PACKAGE:
      // case Constants.ADB_GET_FREEZE_PACKAGE:
      //   List<String> packageNameList = data.split(PlatformUtils.getLineBreak());
      //   List<String> packageNameFilter = [];
      //   packageNameList.forEach((element) {
      //     if (element.isNotEmpty) {
      //       packageNameFilter.add(element.replaceAll("package:", ""));
      //     }
      //   });
      //   return CommandResponseModel(true, packageNameFilter);
      // case Constants.ADB_IP:
      //   String ip = data.split(":")[1].split(" ")[0];
      //   return CommandResponseModel(true, ip);
      // case Constants.ADB_WIRELESS_CONNECT:
      //   if (data.contains("already") ||
      //       data.contains("failed") ||
      //       data.contains("cannot")) {
      //     //表示已经连接上了
      //     return CommandResponseModel(false, data);
      //   } else {
      //     return CommandResponseModel(
      //         true, data.replaceAll("connected to ", "").trim()); //移除换行符号
      //   }
      // case Constants.ADB_WIRELESS_DISCONNECT:
      //   if (data.contains("error")) {
      //     return CommandResponseModel(false, data);
      //   }
      //   return CommandResponseModel(
      //       true, data.replaceAll("disconnected ", "").trim());
      // case Constants.ADB_PULL_CRASH:
      //   if (data.isEmpty) {
      //     return CommandResponseModel(false, "无crash日志");
      //   } else {
      //     List<String> crashList = data.split(PlatformUtils.getLineBreak());
      //     List<String> times = [];
      //     crashList.forEach((element) {
      //       if (element.contains("data_app_crash")) {
      //         times.add(element.split("data_app_crash")[0].trim());
      //       }
      //     });
      //     if (times.length > 0) {
      //       return CommandResponseModel(true, times);
      //     }
      //     return CommandResponseModel(false, "无app crash日志");
      //   }
      // case Constants.ADB_SEARCH_ALL_FILE_PATH:
      //   if (data.isEmpty) {
      //     return CommandResponseModel(false, "该目录无文件或者当前就是文件");
      //   } else {
      //     if (data.contains("No such file or directory")) {
      //       return CommandResponseModel(false, data);
      //     }
      //     List<String> crashList = data.split(PlatformUtils.getLineBreak());
      //     List<String> times = [];
      //     crashList.forEach((element) {
      //       if (!element.startsWith("/") && element.isNotEmpty) {
      //         times.add(element.trim());
      //       }
      //     });
      //     if (times.length > 0) {
      //       return CommandResponseModel(true, times);
      //     }
      //     return CommandResponseModel(false, "该目录无文件或者当前就是文件");
      //   }
      // case Constants.ADB_APK_PATH:
      //   return CommandResponseModel(
      //       true,
      //       data
      //           .replaceAll("package:", "")
      //           .replaceAll(PlatformUtils.getLineBreak(), ""));
      // case Constants.AAPT_GET_APK_INFO:
      //   String value = "";
      //   List<String> line =
      //       data.replaceAll("\'", "").split(PlatformUtils.getLineBreak());
      //   for (int i = 0; i < line.length; i++) {
      //     //package: name='me.weishu.exp' versionCode='341' versionName='鏄嗕粦闀溌?.4.1' platformBuildVersionName='鏄嗕粦闀溌?.4.1' compileSdkVersion='28' compileSdkVersionCodename='9'
      //     //如果想不存在乱码，先重定向到txt里面去。
      //     if (line[i].startsWith("package")) {
      //       List<String> apkInfo = line[i].substring(8).split(' ');
      //       value = value + "packageName：${apkInfo[1].substring(5)}\n";
      //       value = value + "versionCode：${apkInfo[2].split('=')[1]}\n";
      //       value = value + "versionName：${apkInfo[3].split('=')[1]}\n";
      //       continue;
      //     } else if (line[i].startsWith("application-label:")) {
      //       value = value + "appName：${line[i].split(':')[1]}\n";
      //       continue;
      //     } else if (line[i].startsWith("launchable-activity")) {
      //       value = value +
      //           "launchActivity：${line[i].substring(20).split(' ')[1].split('=')[1]}\n";
      //       continue;
      //     }
      //   }
      //   return CommandResponseModel(true, value);
      // case Constants.ADB_GET_PACKAGE_INFO_MAIN_ACTIVITY:
      //   List<String> line =
      //       data.replaceAll("\'", "").split(PlatformUtils.getLineBreak());
      //   int index = line.indexOf("      android.intent.action.MAIN:");
      //   String value = line[index + 1].trim().split(" ")[1];
      //   return CommandResponseModel(true, value);
    }
    //return CommandResponseModel(true, data);
  }
}
