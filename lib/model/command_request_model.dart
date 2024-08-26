import 'package:flutter_mobile_command_tools/enum/command_type.dart';

class CommandRequestModel {
  String command;
  CommandType commandType;
  bool isShowLog;
  String executable = "";
  bool runInShell = false;
  String? workingDirectory;

  CommandRequestModel(this.command, this.commandType,
      {this.isShowLog = true,
      this.executable = "",
      this.workingDirectory,
      this.runInShell = false});

  @override
  String toString() {
    return 'CommandRequestModel{command: $command, commandType: $commandType, isShowLog: $isShowLog, executable: $executable, runInShell: $runInShell, workingDirectory: $workingDirectory}';
  }
}
