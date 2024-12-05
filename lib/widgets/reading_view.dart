import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:just_audio/just_audio.dart';

class ReadingView extends StatefulWidget {
  final int mode; // 0: Text + Pictures, 1: Text Only, 2: Text + Audio, 3: Text + Video

  ReadingView({required this.mode});

  @override
  _ReadingViewState createState() => _ReadingViewState();
}

class _ReadingViewState extends State<ReadingView> {
  final ScrollController _scrollController = ScrollController();
  late VideoPlayerController _videoController;
  late AudioPlayer _audioPlayer;

  int _currentPictureIndex = 0;
  final List<String> _pictures = [
    'assets/picture1.png', // 替换为你的图片路径
    'assets/picture2.png',
    'assets/picture3.png',
  ];
  bool _isPlayingAudio = false;

  @override
  void initState() {
    super.initState();

    // 初始化视频播放器
    _videoController = VideoPlayerController.asset('assets/video_test.mp4')..initialize();

    // 初始化音频播放器
    _audioPlayer = AudioPlayer();
    _audioPlayer.setAsset('assets/1_part0.mp3');

    // 监听滚动事件，切换图片
    _scrollController.addListener(() {
      if (widget.mode == 0) {
        double progress = _scrollController.offset / _scrollController.position.maxScrollExtent;
        int newIndex = (progress * _pictures.length).floor();
        if (newIndex != _currentPictureIndex && newIndex < _pictures.length) {
          setState(() {
            _currentPictureIndex = newIndex;
          });
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant ReadingView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 停止音频播放并重置状态
    if (oldWidget.mode == 2 && widget.mode != 2) {
      _audioPlayer.stop();
      setState(() {
        _isPlayingAudio = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _videoController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

Future<void> _toggleAudioPlayback() async {
  print("in");
  print(_isPlayingAudio);
  try {
    if (_isPlayingAudio) {
      _audioPlayer.pause();
    } else {
      print("test1");
      _audioPlayer.play();
      print("test2");
    }
  } catch (e) {
    print("Error during playback toggle: $e");
  }

  // 使用 AudioPlayer 的状态监听来同步播放状态
  setState(() {
    _isPlayingAudio = _audioPlayer.playing;
  });

  print("out");
  print(_isPlayingAudio);
}


  @override
  Widget build(BuildContext context) {
    if (widget.mode == 0) {
      // 模式 A: Text + Pictures
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Long text content goes here...\n\n' * 20, // 替换为实际文本
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Image.asset(_pictures[_currentPictureIndex]),
          ),
        ],
      );
    } else if (widget.mode == 1) {
      // 模式 B: Text Only
      return SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Long text content goes here...\n\n' * 20,
          style: TextStyle(fontSize: 16),
        ),
      );
    } else if (widget.mode == 2) {
      // 模式 C: Text + Audio
      return Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Long text content goes here...\n\n' * 20,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: Icon(_isPlayingAudio ? Icons.pause : Icons.play_arrow),
              onPressed: _toggleAudioPlayback,
            ),
          ),
        ],
      );
    } else if (widget.mode == 3) {
      // 模式 D: Text + Video
      return Stack(
        children: [
          Center(
            child: _videoController.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  )
                : CircularProgressIndicator(),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  if (_videoController.value.isPlaying) {
                    _videoController.pause();
                  } else {
                    _videoController.play();
                  }
                });
              },
              child: Icon(
                _videoController.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            ),
          ),
        ],
      );
    } else {
      return Center(child: Text('Invalid mode'));
    }
  }
}
