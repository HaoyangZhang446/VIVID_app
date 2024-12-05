import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class ModeSwitcher extends StatelessWidget {
  final Function(int) onModeChange;

  ModeSwitcher({required this.onModeChange});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return BottomNavigationBar(
      currentIndex: appState.currentMode,
      onTap: (index) {
        appState.changeMode(index);
      },
      type: BottomNavigationBarType.fixed, // 保证图标大小不因选中而变化
      selectedFontSize: 14, // 选中文字大小
      unselectedFontSize: 12, // 未选中文字大小
      selectedItemColor: Colors.deepOrange, // 选中状态的图标和文字颜色
      unselectedItemColor: Colors.grey, // 未选中状态的图标和文字颜色
      showUnselectedLabels: true, // 显示未选中文字
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.image, size: 28), // 调整图标大小
          label: 'Text + Visuals',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.text_fields, size: 28), // 调整图标大小
          label: 'Text Only',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.audiotrack, size: 28), // 调整图标大小
          label: 'Text + Audio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.videocam, size: 28), // 调整图标大小
          label: 'Multimodal',
        ),
      ],
    );
  }
}
