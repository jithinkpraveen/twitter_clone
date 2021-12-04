import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter_clone/models/post_model.dart';
import 'package:twitter_clone/screen/auth/login_page.dart';
import 'package:twitter_clone/screen/home/add_tweet.dart';
import 'package:twitter_clone/screen/ui_elements/post.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _dbref = FirebaseDatabase.instance.reference();
  StreamSubscription? _postStream;
  bool loading = true;
  List<PostModel> posts = [];

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    addListner();
    super.initState();
  }

  @override
  void deactivate() {
    _postStream?.cancel();
    super.deactivate();
  }

  void addListner() {
    _postStream = _dbref.child("post").onValue.listen((event) {
      setState(() {
        loading = false;
      });
      if (event.snapshot.value == null) {
        setState(() {
          posts = [];
        });
      } else {
        Map data = event.snapshot.value;
        List postval = data.values.toList();
        List postkey = data.keys.toList();
        log(postkey.toString());
        log(postval.toString());
        List<PostModel> postsData = postval
            .map((e) => PostModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        for (var i = 0; i < postsData.length; i++) {
          postsData[i].firebaseKey = postkey[i];
        }
        setState(() {
          posts = postsData;
        });
      }
    });
  }

  void onDeletePost(PostModel post) {
    if (post.userName == _auth.currentUser?.email) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('are you sure you want to delete the post ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                _dbref.child("post/${post.firebaseKey}").remove();
                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(" You can only delete your posts")),
      );
    }
  }

  void onUpdatePost(PostModel post) {
    if (post.userName == _auth.currentUser?.email) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => AddTweet(post: post)));

      log("message");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(" You can only edit your posts")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                  child: Text(
                '${_auth.currentUser?.displayName}',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              )),
            ),
            ListTile(
              title: const Text('Log out'),
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('are you sure you want to Logout ?'),
                    // content: const Text('are you sure you want to logout'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(auth: _auth),
                              ),
                              (route) => false);
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const FaIcon(
          FontAwesomeIcons.twitter,
          color: Colors.blue,
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.auto_awesome_outlined,
                color: Colors.black,
              ))
        ],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.account_circle_outlined,
                color: Colors.black,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : posts.isEmpty
              ? const Center(child: Text("No Posts"))
              : ListView.separated(
                  itemBuilder: (context, i) {
                    return Post(
                      post: posts[i],
                      ondelete: onDeletePost,
                      onupdate: onUpdatePost,
                    );
                  },
                  separatorBuilder: (context, i) {
                    return const Divider(color: Colors.black54);
                  },
                  itemCount: posts.length),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddTweet()));
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedIconTheme: const IconThemeData(color: Colors.black26),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bubble_chart_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_add_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
