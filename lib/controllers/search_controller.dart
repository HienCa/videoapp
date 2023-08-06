import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:videoapp/constants.dart';
import 'package:videoapp/models/user.dart';

class SearchControllerCustom extends GetxController {
  final Rx<List<User>> _searchedUsers = Rx<List<User>>([]);

  List<User> get searchedUsers => _searchedUsers.value;

  searchUser(String typedUser) async {
    _searchedUsers.bindStream(firestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: typedUser)
        .snapshots()
        .map((QuerySnapshot query) {
      List<User> retVal = [];
      for (var elem in query.docs) {
        retVal.add(User.fromSnap(elem));
      }
      return retVal;
    }));
  }

  // final Rx<List<User>> _searchedFriend = Rx<List<User>>([]);
  
  // List<User> get searchedFriend => _searchedFriend.value;
  //   var uid = authController.user.uid;

  // searchFriend(String name) async {
  //   _searchedUsers.bindStream(firestore
  //       .collection('users')
  //       .doc(uid)
  //       .where('name', isGreaterThanOrEqualTo: name)
  //       .snapshots()
  //       .map((QuerySnapshot query) {
  //     List<User> retVal = [];
  //     for (var elem in query.docs) {
  //       retVal.add(User.fromSnap(elem));
  //     }
  //     return retVal;
  //   }));
  // }
}
