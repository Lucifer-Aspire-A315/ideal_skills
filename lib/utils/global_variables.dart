import 'package:flutter/material.dart';

import '../pages/add_post_page.dart';
import '../pages/feed_screen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  FeedScreen(),
  Text("search"),
  AddPost(),
  Text("likes"),
  Text("Account"),
];
