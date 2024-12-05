import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class NovelSelector extends StatelessWidget {
  final Function(int) onChapterSelected;

  NovelSelector({required this.onChapterSelected});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Container(
      width: 200,
      color: Colors.grey[200],
      child: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: 4, // 假设有 10 个章节
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Chapter ${index + 1}'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Switched to Chapter ${index + 1}')),
              );
              // 调用回调函数更新章节
              onChapterSelected(index + 1);
              appState.changeMode(0); // 设置模式，示例切换为 Mode 0
            },
          );
        },
      ),
    );
  }
}
