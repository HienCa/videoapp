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
  // ignore: library_private_types_in_public_api
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;
  bool showPlayPauseIcon = true; // Trạng thái hiển thị biểu tượng play/pause
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
      setState(() {
        isPlaying = false;
      });
    } else {
      videoPlayerController.play();
      setState(() {
        isPlaying = true;
      });
    }
    // Hiển thị biểu tượng sau 1 giây nếu video không đang phát
    if (!videoPlayerController.value.isPlaying) {
      setState(() {
        showPlayPauseIcon = true;
      });
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          showPlayPauseIcon = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Container(
        width: double.infinity,
        height: double.infinity * 0.8,
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: videoPlayerController.value.aspectRatio,
              child: VideoPlayer(videoPlayerController),
            ),
            Icon(
              videoPlayerController.value.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
              size: 48,
              color: Colors.white,
            ),
            VideoProgressIndicator(
              videoPlayerController,
              allowScrubbing: true, // Cho phép tua video
            ),
          ],
        ),
      ),
    );
  }
}
