import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobile_command_tools/notifier/center_widget_change_notifier.dart';
import 'package:flutter_mobile_command_tools/theme.dart';
import 'package:flutter_mobile_command_tools/widgets/hover_widget.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';
import '../platform_menus.dart';
import '../widgets/vertical_app_bar.dart';
import 'main_right_page.dart';
import 'main_center_page.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
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
          : NavigationView(
              content: _mainWidget(),
            ),
    );
  }

  Widget _mainWidget() {
    return ChangeNotifierProvider<CenterWidgetChangeNotifier>(
      create: (_) => CenterWidgetChangeNotifier(),
      child: VerticalTabs(
        initialIndex: pageIndex,
        tabs: [
          HoverIconWidget(
            hoverEnterColor: VerticalTabs.color,
            tipsMessage: "设备",
            child: Icon(
              CupertinoIcons.device_phone_portrait,
              size: 15,
            ),
          ),
          HoverIconWidget(
            hoverEnterColor: VerticalTabs.color,
            tipsMessage: "命令",
            child: Icon(
              CupertinoIcons.command,
              size: 15,
            ),
          ),
        ],
        contents: [
          MainRightPage(DeviceCenterPage()),
          MainRightPage(DeviceCommandPage())
        ],
        indicatorSide: IndicatorSide.start,
        tabsWidth: 50,
        onSelect: (index) {
          setState(() {
            pageIndex = index;
          });
        },
      ),
    );
  }
}
