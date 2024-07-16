import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:ideal_skills/utils/colors.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var name, photo;
  final TextEditingController searchController = TextEditingController();
  bool isShowUser = false;
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: "search for user",
          ),
          onFieldSubmitted: (String _) {
            print(_);
            setState(() {
              isShowUser = true;
            });
          },
        ),
      ),
      body: isShowUser
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  // .where('username',
                  //     isGreaterThanOrEqualTo: searchController.text)
                  // .orderBy(
                  //   searchController.text,
                  // )
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  itemCount: (snapshot.data as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    snapshot.data!.docs[index].data().forEach((key, value) {
                      if (key.contains('username')) {
                        name = value;
                      }
                      if (key.contains("photoUrl")) {
                        photo = value;
                      }
                    });
                    print("hello");
                    print(name);
                    print(photo);
                    return ListTile(
                      leading: CircleAvatar(
                        foregroundColor: Colors.cyanAccent,
                        backgroundImage: NetworkImage(
                          photo!.toString(),
                          // snapshot.data!.docs[index]
                          //     .data()
                          //     .containsKey("username")
                          //     .toString(),

                          // (snapshot.data as dynamic).docs[index]['photoUrl'],
                        ),
                      ),
                      title: Text(
                        name!.toString(),
                        // snapshot.data!.docs[index]
                        //     .data()
                        //     .containsKey("photoUrl")
                        //     .toString(),

                        // (snapshot.data as dynamic).docs[index]['username'],
                      ),
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return MasonryGridView.count(
                  crossAxisCount: 3,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) => Image.network(
                    (snapshot.data! as dynamic).docs[index]['postUrl'],
                  ),
                );
              }),
    );
  }
}
