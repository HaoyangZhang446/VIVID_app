import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'package:video_player/video_player.dart';
import 'package:just_audio/just_audio.dart';

class ReadingView extends StatefulWidget {
  final int mode; // 0: Text + Pictures, 1: Text Only, 2: Text + Audio, 3: Text + Video
  final int chapter; // 当前章节

  ReadingView({required this.mode, required this.chapter});

  @override
  _ReadingViewState createState() => _ReadingViewState();
}

class _ReadingViewState extends State<ReadingView> {
  final ScrollController _scrollController = ScrollController();
  late VideoPlayerController _videoController;
  late AudioPlayer _audioPlayer;

  String _textContent = '';
  List<String> _pictures = [];
  int _currentPictureIndex = 0;
  bool _isPlayingAudio = false;

  @override
  void initState() {
    super.initState();

    // 初始化播放器
    _videoController = VideoPlayerController.asset('assets/video_test.mp4')..initialize();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setAsset('assets/1_part0.mp3');

    // 加载章节内容
    _loadChapterContent();

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

    // 如果章节改变，重新加载内容
    if (oldWidget.chapter != widget.chapter) {
      _loadChapterContent();
    }

    // 停止音频播放并重置状态
    if (oldWidget.mode == 2 && widget.mode != 2) {
      _audioPlayer.stop();
      setState(() {
        _isPlayingAudio = false;
      });
    }
  }

  Future<void> _loadChapterContent() async {
    // 加载文本内容
    String chapterText = await rootBundle.loadString('assets/chapters/${widget.chapter}.txt');
    // 加载图片路径
    List<String> chapterPictures = [
      'assets/chapter${widget.chapter}/pictures/picture1.png',
      'assets/chapter${widget.chapter}/pictures/picture2.png',
      'assets/chapter${widget.chapter}/pictures/picture3.png',
    ];

    setState(() {
      _textContent = chapterText;
      _pictures = chapterPictures;
      _currentPictureIndex = 0;
    });
  }

  Future<void> _toggleAudioPlayback() async {
    if (_isPlayingAudio) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }

    setState(() {
      _isPlayingAudio = _audioPlayer.playing;
    });
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
                _textContent,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: _pictures.isNotEmpty
                ? Image.asset(_pictures[_currentPictureIndex])
                : Center(child: Text('No pictures available')),
          ),
        ],
      );
    } else if (widget.mode == 1) {
      // 模式 B: Text Only
      return SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          _textContent,
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
              _textContent,
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
