import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_command_tools/command/adb_command.dart';
import 'package:flutter_mobile_command_tools/notifier/devices_notifier.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../widgets/button_widget.dart';

class DeviceCenterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DevicesChangeNotifier(),
      builder: (context, child) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: MacosTextField(),
                ),
                MacosIconButton(
                    icon: Icon(CupertinoIcons.refresh),
                    onPressed: () {
                      AdbCommand command = AdbCommand();
                      command
                          .runCommand(Constants.ADB_CONNECT_DEVICES)
                          .then((value) {
                        if (value.data is List) {
                          if (value.data.length == 0) {
                            context.read<DevicesChangeNotifier>().isHidden =
                                true;
                          }
                          context.read<DevicesChangeNotifier>().deviceList =
                              value.data;
                          context.read<DevicesChangeNotifier>().isHidden =
                              false;
                        }
                      });
                    }),
              ],
            ),
            Expanded(
              child: Consumer(builder: (BuildContext context,
                  DevicesChangeNotifier devices, Widget? child) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Expanded(
                            child: Stack(
                          children: [
                            Text(devices.deviceList[index]),
                            Positioned(
                              child: Icon(Icons.check),
                              right: 0,
                            )
                          ],
                        ))
                      ],
                    );
                  },
                  itemCount: devices.deviceList.length,
                );
              }),
            ),

            ButtonWidget('当前Activity', () {
              ///context.read<LogChangeNotifier>().addLog("Hello,World");

              AdbCommand command = AdbCommand();
              command.runCommand(Constants.ADB_CURRENT_ACTIVITY);
            }),

            ButtonWidget('当前Fragment', () {
              ///context.read<LogChangeNotifier>().addLog("Hello,World");

              AdbCommand command = AdbCommand();
              command.runCommand(Constants.ADB_CURRENT_FRAGMENT);
            }),
          ],
        );
      },
    );
  }
}
