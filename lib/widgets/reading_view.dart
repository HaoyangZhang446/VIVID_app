import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReadingView extends StatefulWidget {
  final int mode; // 0: Text + Video, 1: Text only, 2: Video only
  final String? videoUrl; // External video URL

  ReadingView({required this.mode, this.videoUrl});

  @override
  ReadingViewState createState() => ReadingViewState();
}

class ReadingViewState extends State<ReadingView> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    // Initialize video controller with the provided video URL
    if (widget.videoUrl != null) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!))
        ..initialize().then((_) {
          setState(() {}); // Refresh the UI once the video is loaded
        })
        ..setLooping(true); // Enable looping
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mode == 0) {
      // Mode A: Text + Video
      return Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: Center(
                child: Text('Novel Text Content'),
              ),
            ),
          ),
          Expanded(
            child: _buildVideoPlayer(),
          ),
        ],
      );
    } else if (widget.mode == 1) {
      // Mode B: Text only
      return Container(
        color: Colors.white,
        child: Center(
          child: Text('Novel Text Content'),
        ),
      );
    } else {
      // Mode C: Video only
      return _buildVideoPlayer();
    }
  }

  Widget _buildVideoPlayer() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      return Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            ),
            SizedBox(height: 10),
            VideoProgressIndicator(_videoController!, allowScrubbing: true),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _videoController!.value.isPlaying
                      ? _videoController!.pause()
                      : _videoController!.play();
                });
              },
              child: Icon(
                _videoController!.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
