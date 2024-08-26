import 'dart:convert';
import 'dart:io';

import 'package:flutter_mobile_command_tools/model/command_request_model.dart';
import 'package:flutter_mobile_command_tools/model/command_response_model.dart';
import 'package:flutter_mobile_command_tools/utils/FileUtils.dart';
import 'package:provider/provider.dart';

import '../global.dart';
import '../notifier/log_change_notifier.dart';

abstract class BaseRunCommand {
  ///检测命令路径
  bool checkCommandPath(String executable) {
    if (executable.isNotEmpty) {
      if (!FileUtils.isExistFile(executable)) {
        return false;
      }
    }
    return true;
  }

  ///处理参数
  List<String> checkArguments(List<String> arguments) {
    return arguments;
  }

  CommandResponseModel parseData(
      CommandRequestModel requestModel, ProcessResult processResult);

  ///执行命令
  dynamic runCommand(CommandRequestModel requestModel, {isSync = false}) async {
    if (checkCommandPath(requestModel.executable)) {
      List<String> arguments = requestModel.command.split(" ");
      arguments = checkArguments(arguments);

      Provider.of<LogChangeNotifier>(Global.navigatorKey.currentContext!,
              listen: false)
          .addLog("${requestModel.executable} ${arguments.join(" ")}");

      ProcessResult processResult;

      if (!isSync) {
        processResult = await Process.run(requestModel.executable, arguments,
            workingDirectory: requestModel.workingDirectory,
            runInShell: requestModel.runInShell,
            stdoutEncoding: Encoding.getByName("utf-8"));
      } else {
        processResult = Process.runSync(requestModel.executable, arguments,
            workingDirectory: requestModel.workingDirectory,
            runInShell: requestModel.runInShell,
            stdoutEncoding: Encoding.getByName("utf-8"));
      }
      CommandResponseModel commandResultModel =
          parseData(requestModel, processResult);
      if (!requestModel.isShowLog) {
        return commandResultModel;
      }
      if (commandResultModel.isSuccess) {
        Provider.of<LogChangeNotifier>(Global.navigatorKey.currentContext!,
                listen: false)
            .addLog(commandResultModel.data);
      } else {
        Provider.of<LogChangeNotifier>(Global.navigatorKey.currentContext!,
                listen: false)
            .addLog("错误信息：${commandResultModel.data}");
      }
      return commandResultModel;
    } else {
      throw "命令路径不存在";
    }
  }
}
