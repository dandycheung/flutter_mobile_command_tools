import 'package:flutter/material.dart';
import 'package:flutter_mobile_command_tools/notifier/center_widget_change_notifier.dart';
import 'package:flutter_mobile_command_tools/widgets/log_widget.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';

class MacosMainRightPage extends StatefulWidget {
  final Widget centerWidget;

  const MacosMainRightPage(this.centerWidget, {Key? key}) : super(key: key);

  @override
  State<MacosMainRightPage> createState() => _MacosMainRightPageState();
}

class _MacosMainRightPageState extends State<MacosMainRightPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CenterWidgetChangeNotifier(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer(builder: (BuildContext context,
              CenterWidgetChangeNotifier notifier, Widget? child) {
            return Row(
              children: [
                Container(
                  width: notifier.centerWidth,
                  margin: EdgeInsets.all(10),
                  child: widget.centerWidget,
                ),
                GestureDetector(
                  onTapDown: (details) {
                    notifier.isClick = true;
                  },
                  onHorizontalDragUpdate: (details) {
                    print(
                        "onHorizontalDragUpdate---${details.globalPosition}---${details.localPosition}---${details.delta}");
                    // setState(() {
                    //   _left += details.delta.dx;
                    // });
                    notifier.centerWidth += details.delta.dx;
                  },
                  onHorizontalDragEnd: (details) {
                    notifier.isClick = false;
                  },
                  child: MouseRegion(
                      cursor: SystemMouseCursors.resizeLeftRight, // 手指光标
                      child: Row(
                        children: [
                          Container(
                            child: Column(),
                            width: 1,
                            color: notifier.isClick
                                ? MacosColors.linkColor
                                : MacosColors.quaternaryLabelColor,
                          )
                        ],
                      )),
                ),
              ],
            );
          }),
          Expanded(child: LogWidget())
        ],
      ),
    );
  }
}
