import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;

  // @override
  // void initState() {
  //   super.initState();
  //   videoPlayerController = VideoPlayerController.network(widget.videoUrl)
  //     ..initialize().then((value) {
  //       videoPlayerController.play();
  //       videoPlayerController.setVolume(1);
  //     });
  // }

 @override
void initState() {
  super.initState();
  // Convert the String videoUrl to a Uri object using Uri.parse
  final videoUri = Uri.parse(widget.videoUrl);

  videoPlayerController = VideoPlayerController.networkUrl(
    videoUri,
    httpHeaders: {}, // You can pass any HTTP headers if needed.
  );

  // Rest of your code remains the same...
}

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: VideoPlayer(videoPlayerController),
    );
  }
}
