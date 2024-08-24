import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_command_tools/mixin/mixin_main.dart';
import 'package:flutter_mobile_command_tools/notifier/center_widget_change_notifier.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';
import '../platform_menus.dart';
import 'macos_main_right_page.dart';
import 'main_center_page.dart';

class MainMacosWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainMacosWidgetState();
  }
}

class _MainMacosWidgetState extends State<MainMacosWidget> with MixinMain {
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformMenuBar(
      menus: menuBarItems(),
      child: MacosWindow(
          titleBar: TitleBar(
            decoration: BoxDecoration(
                color: MacosColors.controlBackgroundColor.withOpacity(0.8)),
            height: 45,
            title: Text(
              '工具',
              style: TextStyle(fontSize: 14),
            ),
          ),
          child: ChangeNotifierProvider<CenterWidgetChangeNotifier>(
            create: (_) => CenterWidgetChangeNotifier(),
            child: Row(
              children: [
                NavigationRail(
                  backgroundColor:
                  MacosColors.controlBackgroundColor.withOpacity(0.8),
                  onDestinationSelected: _onDestinationSelected,
                  elevation: 2,
                  destinations: destinations,
                  selectedIndex: pageIndex,
                ),
                Expanded(child: MacosMainRightPage(DeviceCenterPage()))
              ],
            ),
          )

          // sidebar: Sidebar(
          //   minWidth: 200,
          //   builder: (context, scrollController) {
          //     return SidebarItems(
          //       currentIndex: pageIndex,
          //       onChanged: (i) {
          //         if (kIsWeb && i == 10) {
          //         } else {
          //           setState(() => pageIndex = i);
          //         }
          //       },
          //       scrollController: scrollController,
          //       itemSize: SidebarItemSize.large,
          //       items: [
          //         SidebarItem(
          //           leading: MacosIcon(CupertinoIcons.device_phone_portrait),
          //           label: Text('设备'),
          //         ),
          //         SidebarItem(
          //           leading: MacosIcon(CupertinoIcons.arrow_counterclockwise),
          //           label: Text('连接'),
          //         ),
          //       ],
          //     );
          //   },
          //   bottom: const MacosListTile(
          //     leading: MacosIcon(CupertinoIcons.settings),
          //     title: Text('设置'),
          //   ),
          // ),
          // child: [
          //   MacosMainRightPage(DeviceCenterPage()),
          //   MacosMainRightPage(
          //     Text('thank you'),
          //   ),
          // ][pageIndex],
          ),
    );
  }

  final List<NavigationRailDestination> destinations = const [
    NavigationRailDestination(
        icon: Icon(CupertinoIcons.device_phone_portrait), label: Text("手机")),
    NavigationRailDestination(
        icon: Icon(CupertinoIcons.device_phone_portrait), label: Text("手机")),
  ];

  void _onDestinationSelected(int value) {
    setState(() {
      pageIndex = value;
    });
  }
}
