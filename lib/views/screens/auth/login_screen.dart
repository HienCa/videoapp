import 'package:flutter/material.dart';
import 'package:videoapp/constants.dart';
import 'package:videoapp/views/screens/auth/signup_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                "assets/images/logo.jpg",
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'VIDEO CVG',
              style: GoogleFonts.bungee(
                fontSize: 24,
                color: buttonColor,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 25,
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
              height: 25,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
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
                onTap: () => authController.loginUser(
                  _emailController.text,
                  _passwordController.text,
                ),
                child: const Center(
                  child: Text(
                    'ĐĂNG NHẬP',
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
                
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SignupScreen(),
                    ),
                  ),
                  child: const Text(
                    'Bạn chưa có tài khoản? ',
                    style: TextStyle(fontSize: 20, color: Colors.blueAccent),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SignupScreen(),
                    ),
                  ),
                  child: Text(
                    'Đăng ký',
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
