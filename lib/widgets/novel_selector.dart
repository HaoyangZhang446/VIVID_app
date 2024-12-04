import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class NovelSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Container(
      width: 200,
      color: Colors.grey[200],
      child: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          ListTile(
            title: Text('Novel Name 1'),
            onTap: () {
              // 模拟点击切换小说
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Switched to Novel Name 1')),
              );
              // 在这里可以实现切换小说逻辑，比如更新状态
              appState.changeMode(0); // 可切换模式作为测试
            },
          ),
          ListTile(
            title: Text('Novel Name 2'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Switched to Novel Name 2')),
              );
              appState.changeMode(0); // 切换模式作为示例
            },
          ),
        ],
      ),
    );
  }
}
