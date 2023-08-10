import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:videoapp/constants.dart';
import 'package:videoapp/views/widgets/custom_icon.dart';

import 'confirm_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIdx = 0;
  pickVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    if (video != null) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ConfirmScreen(
            videoFile: File(video.path),
            videoPath: video.path,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (idx) {
          setState(() {
            pageIdx = idx;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: backgroundColor,
        selectedItemColor: Colors.red,
        unselectedItemColor: unselectedItemColor,
        currentIndex: pageIdx,
        items:  [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Trang chủ',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 30),
            label: 'Tìm kiếm',
          ),
          BottomNavigationBarItem(
            // icon: CustomIcon(),
            icon: IconButton(
              onPressed: () => pickVideo(
                  ImageSource.gallery, context), 
              icon: const CustomIcon(),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.people, size: 30),
            label: 'Bạn bè',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30),
            label: 'Hồ sơ',
          ),
        ],
      ),
      body: pages[pageIdx],
    );
  }
}
