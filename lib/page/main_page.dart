import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_command_tools/mixin/mixin_main.dart';
import 'package:flutter_mobile_command_tools/notifier/center_widget_change_notifier.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';
import '../platform_menus.dart';
import 'main_right_page.dart';
import 'main_center_page.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> with MixinMain {
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformMenuBar(
      menus: menuBarItems(),
      child: Platform.isMacOS
          ? MacosWindow(
              titleBar: TitleBar(
                decoration: BoxDecoration(
                    color: MacosColors.controlBackgroundColor.withOpacity(0.8)),
                height: 45,
                title: Text(
                  '工具',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              child: _mainWidget())
          : _mainWidget(),
    );
  }

  Widget _mainWidget() {
    return NavigationView(
        content: ChangeNotifierProvider<CenterWidgetChangeNotifier>(
      create: (_) => CenterWidgetChangeNotifier(),
      child: Row(
        children: [
          NavigationRail(
            minWidth: 50,
            backgroundColor:
                MacosColors.controlBackgroundColor.withOpacity(0.8),
            onDestinationSelected: _onDestinationSelected,
            elevation: 2,
            destinations: destinations,
            selectedIndex: pageIndex,
          ),
          Expanded(
              child: [
            MainRightPage(DeviceCenterPage()),
            MainRightPage(DeviceCommandPage())
          ][pageIndex])
        ],
      ),
    ));
  }

  final List<NavigationRailDestination> destinations = const [
    NavigationRailDestination(
        icon: Icon(
          CupertinoIcons.device_phone_portrait,
          size: 15,
        ),
        label: Text("手机")),
    NavigationRailDestination(
        icon: Icon(
          CupertinoIcons.command,
          size: 15,
        ),
        label: Text("命令")),
  ];

  void _onDestinationSelected(int value) {
    setState(() {
      pageIndex = value;
    });
  }
}
