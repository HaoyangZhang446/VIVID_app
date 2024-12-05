import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/novel_selector.dart';
import '../widgets/reading_view.dart';
import '../widgets/mode_switcher.dart';
import '../main.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Row(
        children: [
          // 左侧小说选择导航栏
          NovelSelector(),
          // 右侧阅读界面
          Expanded(
            child: ReadingView(mode: appState.currentMode),
          ),
        ],
      ),
      // 增加一些外观效果
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[300]!, width: 1)),
        ),
        child: ModeSwitcher(onModeChange: (mode) {
          appState.changeMode(mode);
        }),
      ),
    );
  }
}
