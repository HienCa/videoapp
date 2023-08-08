import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:videoapp/views/widgets/text_input_field.dart';
import 'package:video_player/video_player.dart';
import 'package:videoapp/controllers/upload_video_controller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ConfirmScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;
  const ConfirmScreen({
    Key? key,
    required this.videoFile,
    required this.videoPath,
  }) : super(key: key);

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late VideoPlayerController controller;
  final TextEditingController _songController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();

  bool _isLoading = false;

  UploadVideoController uploadVideoController =
      Get.put(UploadVideoController());

  @override
  void initState() {
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videoFile);
    });
    controller.initialize().then((_) {
      setState(() {});
      controller.play();
      controller.setVolume(1);
      controller.setLooping(true);
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void _uploadVideo() async {
    setState(() {
      _isLoading = true;
    });

    // Upload video logic here
    await uploadVideoController.uploadVideo(
        _songController.text, _captionController.text, widget.videoPath);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: VideoPlayer(controller),
                ),
                const SizedBox(
                  height: 30,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: MediaQuery.of(context).size.width - 20,
                        child: TextInputField(
                          controller: _songController,
                          labelText: 'Tên bài hát',
                          icon: Icons.music_note,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: MediaQuery.of(context).size.width - 20,
                        child: TextInputField(
                          controller: _captionController,
                          labelText: 'Tiêu đề',
                          icon: Icons.closed_caption,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _uploadVideo,
                        child: const Text(
                          'Chia sẻ!',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // if (_isLoading)
                //   Container(
                //     color: Colors.black.withOpacity(0.5),
                //     child: const Center(
                //       child: CircularProgressIndicator(
                //         // Thay SpinKitFadingCircle bằng CircularProgressIndicator
                //         valueColor:
                //             AlwaysStoppedAnimation<Color>(Colors.redAccent),
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: SpinKitHourGlass(
                  color: Colors.redAccent,
                  size: 100,
                  duration: Duration(milliseconds: 1000),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
