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
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.view_column),
          label: 'Text + Video',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.text_fields),
          label: 'Text Only',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.video_library),
          label: 'Video Only',
        ),
      ],
    );
  }
}
