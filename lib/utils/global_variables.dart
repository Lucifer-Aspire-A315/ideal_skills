import 'package:flutter/material.dart';

import '../pages/add_post_page.dart';
import '../pages/feed_screen.dart';
import '../pages/search_page.dart';

const webScreenSize = 600;

const homeScreenItems = [
  FeedScreen(),
  SearchPage(),
  AddPost(),
  Text("likes"),
  Text("Account"),
];
