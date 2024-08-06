import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/components/my_drawer.dart';
import 'package:social_app/components/my_list_tile.dart';
import 'package:social_app/components/my_posts_button.dart';
import 'package:social_app/components/my_textfield.dart';
import 'package:social_app/database/firestore.dart';

class HomePage extends StatelessWidget {

  HomePage({super.key});

  final FirestoreDatabase database = FirestoreDatabase();
  final TextEditingController newPostController = TextEditingController();


  // post
  void postMessage() {
    if (newPostController.text.isNotEmpty) {
      String message = newPostController.text;
      database.addPost(message);
    }
    // clear
    newPostController.clear();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("H O M E"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          // textfield
          Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              children: [
                // textfield
                Expanded(
                  child: MyTextField(
                    hintText: "Say something...", 
                    obscureText: false, 
                    controller: newPostController),
                ),
                // post buttom
                PostsButton(onTap: postMessage),
              ],
            ),
          ),
          StreamBuilder(
            stream: database.getPostsStream(),
            builder: (context, snapshot) {
              // loading circle
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator()
                );
              }
              // get posts
              final posts = snapshot.data!.docs;

              // no data
              if (snapshot.data == null || posts.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text("No posts.. Post something!")
                  ),
                );
              }
              // return as a list
              return Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    // get each post 
                    final post = posts[index];
                    // get data from each post
                    String message = post['PostMessage'];
                    String userEmail = post['UserEmail'];
                    Timestamp timestamp = post['TimeStamp'];
                    // return as a list tile
                    return MyListTile(title: message, subtitle: userEmail);
                  }
                )              
              );
            }
          )
        ],
      ),
    );
  }

}