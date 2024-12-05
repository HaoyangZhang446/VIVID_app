import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/novel_selector.dart';
import '../widgets/reading_view.dart';
import '../widgets/mode_switcher.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentChapter = 1; // 当前章节

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Row(
        children: [
          // 左侧小说选择导航栏
          NovelSelector(
            onChapterSelected: (chapter) {
              setState(() {
                _currentChapter = chapter; // 更新当前章节
              });
            },
          ),
          // 右侧阅读界面
          Expanded(
            child: ReadingView(
              mode: appState.currentMode,
              chapter: _currentChapter, // 根据当前章节动态加载内容
            ),
          ),
        ],
      ),
      // 底部模式切换栏
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[300]!, width: 1)),
        ),
        child: ModeSwitcher(
          onModeChange: (mode) {
            appState.changeMode(mode); // 切换模式
          },
        ),
      ),
    );
  }
}
