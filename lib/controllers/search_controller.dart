// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:videoapp/constants.dart';
import 'package:videoapp/models/user.dart';

class SearchControllerCustom extends GetxController {
  final Rx<List<User>> _searchedUsers = Rx<List<User>>([]);

  List<User> get searchedUsers => _searchedUsers.value;
  List<User> friendsList = []; // Danh sách các đối tượng User

  searchUser(String typedUser) async {
    if (typedUser.isEmpty) {
      _searchedUsers.bindStream(firestore
          .collection('users')
          .limit(20)
          .snapshots()
          .map((QuerySnapshot query) {
        List<User> retVal = [];
        for (var elem in query.docs) {
          retVal.add(User.fromSnap(elem));
        }
        return retVal;
      }));
    } else {
      _searchedUsers.bindStream(firestore
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: typedUser)
          .where('name',
              isLessThan: '${typedUser}z') // Adjust 'z' as needed for your data
          .snapshots()
          .map((QuerySnapshot query) {
        List<User> retVal = [];
        for (var elem in query.docs) {
          retVal.add(User.fromSnap(elem));
        }
        return retVal;
      }));
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

        friendsList = users;
      } else {
        friendsList = [];
      }
    } catch (e) {
      print('Error fetching received friend requests: $e');
    }
  }
}
