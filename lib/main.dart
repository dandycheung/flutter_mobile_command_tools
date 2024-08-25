import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_mobile_command_tools/constants.dart';
import 'package:flutter_mobile_command_tools/global.dart';
import 'package:flutter_mobile_command_tools/notifier/log_change_notifier.dart';
import 'package:flutter_mobile_command_tools/page/main_page.dart';
import 'package:flutter_mobile_command_tools/theme.dart';
import 'package:flutter_mobile_command_tools/utils/init_utils.dart';
import 'package:window_manager/window_manager.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';

Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig();
  await config.apply();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InitUtils.init({}); //等待配置初始化完成
  if (Platform.isMacOS) {
    await _configureMacosWindowUtils();
  }
  if (Platform.isWindows) {
    // Must add this line.
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = WindowOptions(
      center: true,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<LogChangeNotifier>(
          create: (_) => LogChangeNotifier()),
    ],
    child: MainWidget(),
  ));
}

class MainWidget extends StatelessWidget {
  final appTheme = AppTheme();

  @override
  Widget build(BuildContext context) {
    return !Platform.isMacOS
        ? FluentApp(
            title: Constants.APP_NAME,
            navigatorKey: Global.navigatorKey,
            themeMode: appTheme.mode,
            debugShowCheckedModeBanner: false,
            color: appTheme.color,
            theme: FluentThemeData(
              accentColor: appTheme.color,
              visualDensity: VisualDensity.standard,
              focusTheme: FocusThemeData(
                glowFactor: is10footScreen(context) ? 2.0 : 0.0,
              ),
            ),
            home: MainPage(),
          )
        : MacosApp(
            title: Constants.APP_NAME,
            navigatorKey: Global.navigatorKey,

            ///themeMode: ThemeMode.dark,
            debugShowCheckedModeBanner: false,
            home: MainPage(),
          );
  }
}
