import 'package:flutter/material.dart';
import 'package:fluttergram/screens/add_post_screen.dart';
import 'package:fluttergram/screens/feed_Screen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  FeedScreen(),
  Text("search"),
  AddPostScreen(),
  Text("notif"),
  Text("profile"),
];
