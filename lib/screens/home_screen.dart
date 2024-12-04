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

    // 示例视频链接，可以根据需要替换成动态链接
    String videoUrl = "https://drive.googleusercontent.com/file/d/1g-5bY71FVBSXXlTUbTYAsPiNrV1jOxLM/view?usp=sharing";

    return Scaffold(
      body: Row(
        children: [
          // 左侧小说选择导航栏
          NovelSelector(),
          // 右侧阅读界面
          Expanded(
            child: ReadingView(
              mode: appState.currentMode,
              videoUrl: videoUrl,
            ),
          ),
        ],
      ),
      // 底部切换按钮
      bottomNavigationBar: ModeSwitcher(onModeChange: (mode) {
        appState.changeMode(mode);
      }),
    );
  }
}
