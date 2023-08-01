import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

typedef TogglePlayPauseCallback = void Function();

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
    //  this.onTogglePlayPause
  }) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;

  bool isPlaying = false;
  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl.toString()))
          ..initialize().then((_) {
            setState(() {
              videoPlayerController.play();
              videoPlayerController.setLooping(true);
              videoPlayerController.setVolume(1);
            
            });
          });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  void _togglePlayPause() {
    if (videoPlayerController.value.isPlaying) {
      videoPlayerController.pause();
    } else {
      videoPlayerController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: AspectRatio(
          aspectRatio: videoPlayerController.value.aspectRatio,
          child: VideoPlayer(videoPlayerController),
        ),
      ),
    );
  }
}
