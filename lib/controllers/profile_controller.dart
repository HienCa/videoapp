import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:videoapp/models/user.dart' as model;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:videoapp/constants.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;

  final Rx<String> _uid = "".obs;
  late Rx<File?> _pickedImage = Rx<File?>(null);

  File? get profilePhoto => _pickedImage.value;

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      Get.snackbar('Upload Avatar', 'Bạn đã tải lên avatar thành công!');
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
    print("111111111111111111111111111111111111111111");
  }

  updateUserId(String uid) {
    _uid.value = uid;
    print(uid);
    print("111111111111111111111111111111111111111111");
    getUserData();
  }

  getCurrentUserData() async {
    try {
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(_uid.value).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null && userData is Map<String, dynamic>) {
          String name = userData['name'] ?? '';
          String email = userData['email'] ?? '';
          String profilePhoto = userData['profilePhoto'] ?? '';
          return model.User(
            name: name,
            email: email,
            uid: _uid.value,
            profilePhoto: profilePhoto,
          );
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null; // Return null in case of any error
    }
  }

  getUserData() async {
    List<String> thumbnails = [];
    var myVideos = await firestore
        .collection('videos')
        .where('uid', isEqualTo: _uid.value)
        .get();

    for (int i = 0; i < myVideos.docs.length; i++) {
      thumbnails.add((myVideos.docs[i].data() as dynamic)['thumbnail']);
    }

    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(_uid.value).get();
    final userData = userDoc.data()! as dynamic;
    String? name = userData?['name'];
    String? profilePhoto = userData?['profilePhoto'];
    int likes = 0;
    int followers = 0;
    int following = 0;
    bool isFollowing = false;

    for (var item in myVideos.docs) {
      likes += (item.data()['likes'] as List).length;
    }
    var followerDoc = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .get();
    var followingDoc = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('following')
        .get();
    followers = followerDoc.docs.length;
    following = followingDoc.docs.length;

    firestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.uid)
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });

    _user.value = {
      'followers': followers.toString(),
      'following': following.toString(),
      'isFollowing': isFollowing,
      'likes': likes.toString(),
      'profilePhoto': profilePhoto,
      'name': name,
      'thumbnails': thumbnails,
    };
    update();
  }

  // Future<bool> isFollowed(String uid) async {
  //   //uid là uid cần check
  //   var doc = await firestore
  //       .collection('users')
  //       .doc(uid)
  //       .collection('followers')
  //       .doc(authController.user.uid)
  //       .get();

  //   if (!doc.exists) {
  //     return false;
  //   }
  //   return true;
  // }

  followUser() async {
    var doc = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.uid)
        .get();

    if (!doc.exists) {
      await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user.uid)
          .set({});
      await firestore
          .collection('users')
          .doc(authController.user.uid)
          .collection('following')
          .doc(_uid.value)
          .set({});
      _user.value.update(
        'followers',
        (value) => (int.parse(value) + 1).toString(),
      );
    } else {
      await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user.uid)
          .delete();
      await firestore
          .collection('users')
          .doc(authController.user.uid)
          .collection('following')
          .doc(_uid.value)
          .delete();
      _user.value.update(
        'followers',
        (value) => (int.parse(value) - 1).toString(),
      );
    }
    _user.value.update('isFollowing', (value) => !value);
    update();
  }

  // lấy danh sách lời mười kết bạn
  Future<List<Map<String, dynamic>>> getReceivedFriendRequests() async {
    String currentUserId = authController.user.uid;

    // Lấy danh sách receivedFriendRequests từ tài liệu của người dùng hiện tại
    var userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();

    List<String> receivedFriendRequests = [];
    if (userDoc.exists) {
      receivedFriendRequests =
          (userDoc.data()?['receivedFriendRequests'] as List<dynamic>)
              .cast<String>();
    }

    // Truy vấn thông tin user dựa vào các ID có trong receivedFriendRequests
    List<Map<String, dynamic>> usersInfo = [];
    for (String userId in receivedFriendRequests) {
      var userQuery = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userQuery.exists) {
        usersInfo.add(userQuery.data() as Map<String, dynamic>);
      }
    }

    return usersInfo;
  }

  Future<bool> isFriendRequestSent(String id) async {
    var userDoc =
        await FirebaseFirestore.instance.collection('users').doc(id).get();

    if (userDoc.exists) {
      var sentFriendRequests = userDoc.data()?['receivedFriendRequests'] ?? [];

      return sentFriendRequests.contains(authController.user.uid);
    }

    return false;
  }

  // thu hồi gửi lời mời kết bạn
  Future<void> cancelFriendRequestSent(String id) async {
    var currentUserRef = firestore.collection('users').doc(id);
    var currentUserDoc = await currentUserRef.get();

    if (currentUserDoc.exists) {
      if ((currentUserDoc.data()! as dynamic)['receivedFriendRequests']
          .contains(authController.user.uid)) {
        await firestore.collection('users').doc(id).update({
          'receivedFriendRequests':
              FieldValue.arrayRemove([authController.user.uid]),
        });
      }
    }
    update();
  }

  Future<void> addFriend(String id) async {
    var userSendDocRef =
        firestore.collection('users').doc(authController.user.uid);
    var userSendDoc = await userSendDocRef.get();

    var userTargetDocRef = firestore.collection('users').doc(id);
    var userTargetDoc = await userTargetDocRef.get();

    if (userSendDoc.exists && userTargetDoc.exists) {
      // Check if they are not already friends
      var checkFriend = await firestore
          .collection('users')
          .doc(id)
          .collection('friends')
          .doc(authController.user.uid)
          .get();

      if (!checkFriend.exists) {
        var sentFriendRequests =
            userTargetDoc.data()?['receivedFriendRequests'] ?? [];

        sentFriendRequests = [
          ...sentFriendRequests,
          authController.user.uid
        ]; // uid là uid người gửi

        await userTargetDocRef.set({
          'receivedFriendRequests': sentFriendRequests,
        }, SetOptions(merge: true));
      }
    }

    update();
  }

  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  updateProfileUser(String uid, String name, File? profilePhoto) async {
    var doc = await firestore.collection('users').doc(_uid.value).get();
    String downloadUrl = "";
    print(_uid + name + profilePhoto.toString());
    try {
      if (!doc.exists) {
        // Tạo tài liệu người dùng mặc định nếu không tồn tại
        await firestore.collection('users').doc(_uid.value).set({});
      }

      if (profilePhoto != null) {
        // Xóa ảnh cũ nếu có
        await _deleteOldProfilePhoto(doc);

        // Tải ảnh mới lên Firebase Storage và nhận URL
        downloadUrl = await _uploadToStorage(profilePhoto);
        // Cập nhật tên và URL hình đại diện vào tài liệu người dùng
        await firestore
            .collection('users')
            .doc(_uid.value)
            .update({'name': name, 'profilePhoto': downloadUrl});
      } else {
        // Cập nhật tên và URL hình đại diện vào tài liệu người dùng
        await firestore
            .collection('users')
            .doc(_uid.value)
            .update({'name': name});
      }

      // Get the reference to the 'videos' collection
      CollectionReference videosCollection = firestore.collection('videos');

      // Query all videos where 'uid' matches the current user's UID
      QuerySnapshot videoQuerySnapshot =
          await videosCollection.where('uid', isEqualTo: _uid.value).get();

      // Loop through the query results and update the 'name' field for each video
      for (DocumentSnapshot videoSnapshot in videoQuerySnapshot.docs) {
        String videoId = videoSnapshot.id;
        // Replace 'new_name_here' with the new name you want to set for each video
        String newName = name;

        // Update the 'name' field for the video
        await videosCollection
            .doc(videoId)
            .update({'username': newName, 'name': videoId});

        print('Updated name for video with ID: $videoId');
      }

      update();
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Đăng ký thất bại!',
        e.message ?? 'Có lỗi xãy.',
      );
    } catch (e) {
      Get.snackbar(
        'Cập nhật thất bại!',
        e.toString(),
      );
    }
  }

// Phương thức để xóa ảnh khỏi Firebase Storage
  _deleteOldProfilePhoto(DocumentSnapshot doc) async {
    if (doc.exists && doc.data() != null) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String oldDownloadUrl = data['profilePhoto'];
      if (oldDownloadUrl.isNotEmpty) {
        try {
          // Tạo tham chiếu đến file trong Firebase Storage
          Reference storageRef =
              FirebaseStorage.instance.refFromURL(oldDownloadUrl);

          // Kiểm tra URL tải xuống để kiểm tra sự tồn tại của tệp
          await storageRef.getDownloadURL();

          // Nếu không xảy ra lỗi, tệp tồn tại và có thể xóa
          await storageRef.delete();
        } catch (e) {
          // Xử lý lỗi nếu tệp không tồn tại hoặc có lỗi khác
          print("Error deleting file: $e");
        }
      }
    }
  }
}
