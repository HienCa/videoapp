// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants.dart';
import '../../models/user.dart';

class FriendScreen extends StatefulWidget {
  @override
  _FriendScreenState createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  List<String> receivedFriendRequests = [];
  List<User> usersInfo = []; // Danh sách các đối tượng User
  List<User> friendsList = []; // Danh sách các đối tượng User
  @override
  void initState() {
    super.initState();
    // Truy xuất dữ liệu từ Firestore trong hàm initState và lưu vào trường receivedFriendRequests
    fetchReceivedFriendRequests();
    fetchFriends();
  }

  Future<void> acceptFriendRequest(String id) async {
    try {
      // Thêm bạn bè vào danh sách của người dùng hiện tại
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authController.user.uid)
          .update({
        'friends': FieldValue.arrayUnion([id]),
      });

      // Thêm người dùng hiện tại vào danh sách bạn bè của người gửi yêu cầu
      await FirebaseFirestore.instance.collection('users').doc(id).update({
        'friends': FieldValue.arrayUnion([authController.user.uid]),
      });

      // Xóa yêu cầu kết bạn từ người gửi yêu cầu trong danh sách receivedFriendRequests
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authController.user.uid)
          .update({
        'receivedFriendRequests': FieldValue.arrayRemove([id]),
      });
      setState(() {
        fetchReceivedFriendRequests();
        fetchFriends();
      }); // Gọi setState để rebuild giao diện với danh sách rỗng
    } catch (e) {
      print('Error accepting friend request: $e');
    }
  }

  // thu hồi gửi lời mời kết bạn
  Future<void> cancelFriendRequestSent(String id) async {
    try {
      // Xóa yêu cầu kết bạn từ người gửi yêu cầu trong danh sách receivedFriendRequests
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authController.user.uid)
          .update({
        'receivedFriendRequests': FieldValue.arrayRemove([id]),
      });

      setState(() {
        fetchReceivedFriendRequests();
        fetchFriends();
      }); // Gọi setState để rebuild giao diện với danh sách rỗng
    } catch (e) {
      print('Error accepting friend request: $e');
    }
  }

  //hủy kết bạn
  Future<void> cancelFriend(String id) async {
    try {
      var currentUserRef =
          firestore.collection('users').doc(authController.user.uid);
      var currentUserDoc = await currentUserRef.get();

      var targetUserRef = firestore.collection('users').doc(id);
      var targetUserDoc = await targetUserRef.get();

      if (currentUserDoc.exists && targetUserDoc.exists) {
        if ((currentUserDoc.data()! as dynamic)['friends'].contains(id)) {
          await firestore
              .collection('users')
              .doc(authController.user.uid)
              .update({
            'friends': FieldValue.arrayRemove([id]),
          });
        }
        if ((targetUserDoc.data()! as dynamic)['friends']
            .contains(authController.user.uid)) {
          await firestore.collection('users').doc(id).update({
            'friends': FieldValue.arrayRemove([authController.user.uid]),
          });
        }
      }
      setState(() {
        fetchFriends();
        fetchReceivedFriendRequests();
      });
    } catch (e) {
      print('Error accepting friend request: $e');
    }
  }

  Future<void> fetchReceivedFriendRequests() async {
    try {
      String userUid = authController.user.uid;
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userUid)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        List<dynamic>? receivedRequests =
            snapshot.data()!['receivedFriendRequests'];
        receivedFriendRequests = receivedRequests?.cast<String>() ?? [];
        List<User> users = []; // Tạo danh sách User

        for (String userId in receivedFriendRequests) {
          DocumentSnapshot<Map<String, dynamic>> userSnapshot =
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .get();

          if (userSnapshot.exists && userSnapshot.data() != null) {
            // Tạo đối tượng User từ thông tin lấy được
            User user = User(
              uid: userId,
              name: userSnapshot.data()!['name'] ?? '',
              email: userSnapshot.data()!['email'] ?? '',
              profilePhoto: userSnapshot.data()!['profilePhoto'] ?? '',
            );
            users.add(user);
          }
        }

        setState(() {
          usersInfo = users;
        });
      } else {
        receivedFriendRequests = [];
        setState(() {}); // Gọi setState để rebuild giao diện với danh sách rỗng
      }
    } catch (e) {
      print('Error fetching received friend requests: $e');
    }
  }

  Future<void> fetchFriends() async {
    try {
      String userUid = authController.user.uid;
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userUid)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        List<dynamic>? friends = snapshot.data()!['friends'];
        friends = friends?.cast<String>() ?? [];
        List<User> users = []; // Tạo danh sách User

        for (String userId in friends) {
          DocumentSnapshot<Map<String, dynamic>> userSnapshot =
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .get();

          if (userSnapshot.exists && userSnapshot.data() != null) {
            // Tạo đối tượng User từ thông tin lấy được
            User user = User(
              uid: userId,
              name: userSnapshot.data()!['name'] ?? '',
              email: userSnapshot.data()!['email'] ?? '',
              profilePhoto: userSnapshot.data()!['profilePhoto'] ?? '',
            );
            users.add(user);
          }
        }

        setState(() {
          friendsList = users;
        });
      } else {
        friendsList = [];
        setState(() {}); // Gọi setState để rebuild giao diện với danh sách rỗng
      }
    } catch (e) {
      print('Error fetching received friend requests: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2, // Số lượng tab
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Danh sách kết bạn'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Bạn bè'),
                Tab(text: 'Lời mời kết bạn'),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(1.0),
            child: TabBarView(
              children: [
                // Nội dung cho tab 'Đã kết bạn'
                buildFriendList(),
                // Nội dung cho tab 'Lời mời'
                buildFriendRequestList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFriendRequestList() {
    // Nội dung của tab 'Lời mời'
    // Sử dụng ListView.builder để hiển thị danh sách lời mời kết bạn
    return ListView.builder(
      itemCount: usersInfo.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                usersInfo[index].profilePhoto,
              ),
            ),
            title: Text(
              usersInfo[index].name,
              style: const TextStyle(
                  fontSize: 18, color: textColor, fontWeight: FontWeight.bold),
            ),
            // ignore: sized_box_for_whitespace
            trailing: Container(
              width: 130,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      cancelFriendRequestSent(usersInfo[index].uid);
                    },
                    child: const Icon(
                      Icons.delete_rounded,
                      size: 34,
                      color: Colors.red,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      acceptFriendRequest(usersInfo[index].uid);
                    },
                    child: const Icon(
                      Icons.check_circle_rounded,
                      size: 34,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildFriendList() {
    // Nội dung của tab 'Đã kết bạn'
    // Sử dụng ListView.builder để hiển thị danh sách đã kết bạn
    return ListView.builder(
      itemCount: friendsList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                friendsList[index].profilePhoto,
              ),
            ),
            title: Text(
              friendsList[index].name,
              style: const TextStyle(
                  fontSize: 18, color: textColor, fontWeight: FontWeight.bold),
            ),
            // ignore: sized_box_for_whitespace
            trailing: Container(
              width: 95,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: TextButton(
                onPressed: () {
                  cancelFriend(friendsList[index].uid);
                },
                child: const Text(
                  'Hủy kết bạn',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
