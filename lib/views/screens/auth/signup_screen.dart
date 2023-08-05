
import 'package:flutter/material.dart';
import 'package:videoapp/constants.dart';
import 'package:videoapp/views/screens/auth/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Video CVG',
              style:  GoogleFonts.bungee(
                fontSize: 40,
                color: buttonColor,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Stack(
              children: [
                InkWell(
                  onTap: () {
                    authController.pickImage();
                    
                  },
                  child: ClipOval(
                    child: Image.asset(
                      "assets/images/user-default.png",
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: () => authController.pickImage(),
                    icon: const Icon(
                      Icons.add_a_photo,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _usernameController,
                style: const TextStyle(color: textColor),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.redAccent,
                  ),
                  label: Text("Tên người dùng",
                      style: TextStyle(color: Colors.black)),
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w300, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _emailController,
                style: const TextStyle(color: textColor),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.redAccent,
                  ),
                  label: Text("Email", style: TextStyle(color: Colors.black)),
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w300, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _passwordController,
                style: const TextStyle(color: textColor),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.redAccent,
                  ),
                  label:
                      Text("Mật khẩu", style: TextStyle(color: Colors.black)),
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w300, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 50,
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: InkWell(
                onTap: () => authController.registerUser(
                  _usernameController.text,
                  _emailController.text,
                  _passwordController.text,
                  authController.profilePhoto,
                ),
                child: const Center(
                  child: Text(
                    'ĐĂNG KÝ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Bạn đã có tài khoản rồi? ',
                  style: TextStyle(fontSize: 20, color: Colors.blueAccent),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  ),
                  child: Text(
                    'Đăng nhập',
                    style: TextStyle(fontSize: 20, color: buttonColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
