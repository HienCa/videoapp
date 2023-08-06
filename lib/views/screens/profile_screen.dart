import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:videoapp/constants.dart';
import 'package:videoapp/controllers/profile_controller.dart';
import 'package:videoapp/views/screens/update_profile_screen.dart';

import 'friend_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

enum MenuOptions { option1, option2, option3 }

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    profileController.updateUserId(widget.uid);
  }

  void showPopupMenu(BuildContext context) {
    // Show the PopupMenuButton as you did before
    showMenu<MenuOptions>(
      context: context,
      position: const RelativeRect.fromLTRB(
          1000, 80, 10, 0), // Change the position as needed
      items: <PopupMenuEntry<MenuOptions>>[
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.option1,
          child: Text('Bạn bè'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.option2,
          child: Text('Cài đặt'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.option3,
          child: Text('Đăng xuất'),
        ),
      ],
      elevation: 8.0,
    ).then((selectedOption) {
      // Handle the selected option here
      if (selectedOption != null) {
        switch (selectedOption) {
          case MenuOptions.option1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FriendScreen()),
            );
            break;
          case MenuOptions.option2:
            // Do something for option 2.
            break;
          case MenuOptions.option3:
            authController.signOut();
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
          if (controller.user.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // print(controller.user);
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: backgroundColor,
              leading: const Icon(
                Icons.person_add_alt_1_outlined,
                color: Colors.black54,
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.menu,
                      color: Colors.black), // Add the menu icon here
                  onPressed: () {
                    // Show the PopupMenuButton when the menu icon is pressed
                    showPopupMenu(context);
                  },
                ),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: controller.user['profilePhoto'],
                                    height: 100,
                                    width: 100,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.error,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '@${controller.user['name']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: textColor),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      controller.user['following'],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: textColor),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Đang follow',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  color: Colors.black54,
                                  width: 1,
                                  height: 15,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      controller.user['followers'],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: textColor),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Followers',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  color: Colors.black54,
                                  width: 1,
                                  height: 15,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      controller.user['likes'],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: textColor),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Thích',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 140,
                                  height: 47,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey[300],
                                  ),
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {
                                        if (widget.uid ==
                                            authController.user.uid) {
                                          //chỉnh sửa hồ sơ
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdateProfile(
                                                          uid: authController
                                                              .user.uid)));
                                        } else {
                                          // chức năng kết bạn
                                          // controller.addFriend(widget.uid);
                                        }
                                      },
                                      child: widget.uid ==
                                              authController.user.uid
                                          ? const Text(
                                              'Sửa hồ sơ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: textColor),
                                            )
                                          : FutureBuilder<bool>(
                                              future: profileController
                                                  .isFriendRequestSent(widget
                                                      .uid), // Replace 'TARGET_USER_ID' with the actual user ID you want to check
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  // Show a loading indicator while waiting for the result
                                                  return const CircularProgressIndicator();
                                                } else if (snapshot.hasError) {
                                                  // Show an error message if there is an error
                                                  return Text(
                                                      'Error: Lỗi kết nối - ${snapshot.error}');
                                                } else {
                                                  // Use a ternary operator to display different texts based on the result
                                                  bool isRequestSent = snapshot
                                                          .data ??
                                                      false; // Use 'false' as default value if data is null
                                                  return isRequestSent
                                                      ? ElevatedButton(
                                                          onPressed: () {
                                                            controller
                                                                .cancelFriendRequestSent(
                                                                    widget.uid);
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .redAccent,
                                                            elevation: 2.0,
                                                          ),
                                                          child: const Text(
                                                            'Thu hồi',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        )
                                                      : ElevatedButton(
                                                          onPressed: () {
                                                            controller
                                                                .addFriend(
                                                                    widget.uid);
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .redAccent,
                                                            elevation: 2.0,
                                                          ),
                                                          child: const Text(
                                                            'kết bạn',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        );
                                                }
                                              }),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 140,
                                  height: 47,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey[300],
                                  ),
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {
                                        if (widget.uid ==
                                            authController.user.uid) {
                                          authController.signOut();
                                        } else {
                                          controller.followUser();
                                        }
                                      },
                                      child: Text(
                                        widget.uid == authController.user.uid
                                            ? 'Đăng xuất'
                                            : controller.user['isFollowing']
                                                ? 'Bỏ theo dõi'
                                                : 'Theo dõi',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: textColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            // video list
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.user['thumbnails'].length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1,
                                crossAxisSpacing: 5,
                              ),
                              itemBuilder: (context, index) {
                                String thumbnail =
                                    controller.user['thumbnails'][index];
                                return CachedNetworkImage(
                                  imageUrl: thumbnail,
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
