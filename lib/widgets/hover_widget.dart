import 'package:flutter/material.dart';

class HoverWidget extends StatefulWidget {
  final Color hoverEnterColor;
  final Color hoverExitColor;
  final Widget child;

  HoverWidget(
      {Key? key,
      required this.hoverEnterColor,
      this.hoverExitColor = Colors.transparent,
      required this.child})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HoverWidgetState();
  }
}

class _HoverWidgetState extends State<HoverWidget> {
  late Color backgroundColor;

  @override
  void initState() {
    super.initState();
    backgroundColor = widget.hoverExitColor;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) {
        setState(() {
          backgroundColor = widget.hoverEnterColor;
        });
      },
      onExit: (event) {
        setState(() {
          backgroundColor = widget.hoverExitColor;
        });
      },
      child: Container(
        color: backgroundColor,
        child: Row(
          children: [Expanded(child: widget.child)],
        ),
      ),
    );
  }
}
