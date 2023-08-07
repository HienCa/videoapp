import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:videoapp/controllers/auth_controller.dart';
import 'package:videoapp/views/screens/add_video_screen.dart';
import 'package:videoapp/views/screens/notification_screen.dart';
import 'package:videoapp/views/screens/profile_screen.dart';
import 'package:videoapp/views/screens/search_screen.dart';
import 'package:videoapp/views/screens/video_screen.dart';

List pages = [
  VideoScreen(),
  SearchScreen(),
  const AddVideoScreen(),
  const NotificationScreen(),
  ProfileScreen(uid: authController.user.uid),
];

// COLORS
const backgroundColor = Colors.white;
const textColor = Colors.black;
const unselectedItemColor = Colors.black45;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

// CONTROLLER
var authController = AuthController.instance;
