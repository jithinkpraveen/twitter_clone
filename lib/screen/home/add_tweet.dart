import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/models/post_model.dart';

class AddTweet extends StatefulWidget {
  // final DatabaseReference dbRef;
  final PostModel? post;
  const AddTweet({Key? key, this.post}) : super(key: key);

  @override
  _AddTweetState createState() => _AddTweetState();
}

class _AddTweetState extends State<AddTweet> {
  final _dbref = FirebaseDatabase.instance.reference();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _buttonEnable = false;
  final TextEditingController _controller = TextEditingController();

  void addTweet() async {
    PostModel post = PostModel(
        comments: [],
        displayname: _auth.currentUser?.displayName,
        likes: 0,
        post: _controller.text,
        repost: 0,
        topic: "Topic name",
        profilePic: _auth.currentUser?.photoURL,
        userName: _auth.currentUser?.email);
    // add post //
    try {
      setState(() {
        _buttonEnable = false;
      });
      // _controller.clear();

      if (widget.post == null) {
        await _dbref.child("post").push().set(post.toJson());
        Navigator.pop(context);
      } else {
        await _dbref
            .child("post/${widget.post?.firebaseKey}")
            .set(post.toJson());
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _buttonEnable = true;
      });
      log("push error", error: e);
    }
    post.toJson();
  }

  @override
  void initState() {
    if (widget.post != null) {
      _controller.text = widget.post!.post ?? "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          SizedBox(
            height: 10,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                color: Colors.blue,
                padding: EdgeInsets.zero,
                height: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                disabledColor: Colors.blue[200],
                onPressed: !_buttonEnable
                    ? null
                    : () {
                        addTweet();
                      },
                child: const Text(
                  "Tweet",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: TextField(
            autofocus: true,
            controller: _controller,
            onChanged: (String? val) {
              if ((val?.length ?? 0) > 0) {
                setState(() {
                  _buttonEnable = true;
                });
              } else {
                setState(() {
                  _buttonEnable = false;
                });
              }
            },
            maxLines: 100,
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
      ),
    );
  }
}
