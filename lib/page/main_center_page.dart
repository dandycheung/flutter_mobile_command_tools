import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_command_tools/command/adb_command.dart';
import 'package:flutter_mobile_command_tools/notifier/devices_notifier.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../widgets/button_widget.dart';
import 'package:fluent_ui/src/controls/utils/divider.dart' as ListDivide;

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
                  child: ButtonWidget('获取所有设备', () {
                    AdbCommand command = AdbCommand();
                    command
                        .runCommand(Constants.ADB_CONNECT_DEVICES)
                        .then((value) {
                      if (value.data is List) {
                        if (value.data.length != 0) {
                          context.read<DevicesChangeNotifier>().deviceList =
                              value.data;
                        }
                      }
                    });
                  }),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Consumer(builder: (BuildContext context,
                  DevicesChangeNotifier devices, Widget? child) {
                return ListView.separated(
                  itemBuilder: (context, index) {
                    return MouseRegion(
                        // cursor: MouseCursor.uncontrolled,
                        cursor: SystemMouseCursors.click,
                        opaque: false,
                        child: Row(
                          children: [
                            Expanded(
                                child: Stack(
                              children: [
                                Text(devices.deviceList[index]),
                                Visibility(
                                  child: Positioned(
                                    child: Icon(Icons.check),
                                    right: 0,
                                  ),
                                  visible: devices.checkDeviceList[index],
                                )
                              ],
                            ))
                          ],
                        ));
                  },
                  itemCount: devices.deviceList.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return ListDivide.Divider();
                  },
                );
              }),
            ),
          ],
        );
      },
    );
  }
}

class DeviceCommandPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
  }
}
