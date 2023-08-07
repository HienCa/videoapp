import 'package:flutter/material.dart';
import 'package:videoapp/controllers/search_controller.dart';
import 'package:get/get.dart';
import 'package:videoapp/models/user.dart';
import 'package:videoapp/views/screens/profile_screen.dart';
import 'package:videoapp/constants.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchControllerCustom searchController =
      Get.put(SearchControllerCustom());

  final TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    searchController.searchUser("");
  }

  List<User> friendsList = [];
  // Danh sách các đối tượng User
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: TextFormField(
            controller: _textEditingController,
            decoration: const InputDecoration(
              filled: false,
              hintText: 'Tìm kiếm người dùng...',
              hintStyle: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onChanged: (value) {
              searchController.searchUser(value);
            },
            onFieldSubmitted: (value) {
              searchController.searchUser(value);
            },
          ),
        ),
        body: searchController.searchedUsers.isEmpty
            ? const Center(
                child: Text(
                  'Tìm kiếm người dùng!',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: searchController.searchedUsers.length,
                itemBuilder: (context, index) {
                  User user = searchController.searchedUsers[index];
                  return InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(uid: user.uid),
                      ),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          user.profilePhoto,
                        ),
                      ),
                      title: Text(
                        user.name,
                        style: const TextStyle(
                            fontSize: 18,
                            color: textColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
      );
    });
  }
}
