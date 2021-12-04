import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter_clone/models/post_model.dart';

class Post extends StatefulWidget {
  final PostModel post;
  final Function onupdate;
  final Function ondelete;
  const Post(
      {Key? key,
      required this.post,
      required this.ondelete,
      required this.onupdate})
      : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 50),
                const Icon(
                  Icons.contact_support_rounded,
                  color: Colors.black54,
                ),
                const SizedBox(width: 5),
                Text(
                  "${widget.post.topic}  ",
                  style: const TextStyle(
                      color: Colors.black45, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Follow Topic",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.close_outlined),
                  color: Colors.grey[400],
                  iconSize: 19,
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${widget.post.displayname}  ",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${widget.post.userName} . 23h",
                            style: const TextStyle(),
                          ),
                          const Spacer(),
                          PopupMenuButton(
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.grey,
                              ),
                              onSelected: (value) {
                                if (value == 1) {
                                  widget.onupdate(widget.post);
                                } else {
                                  widget.ondelete(widget.post);
                                }
                              },
                              itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      child: Text("Edit"),
                                      value: 1,
                                    ),
                                    const PopupMenuItem(
                                      child: Text("Delete"),
                                      value: 2,
                                    )
                                  ])
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(widget.post.post ?? "error"),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              // widget.onupdate(widget.post);
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.comment,
                              color: Colors.grey,
                              size: 19,
                            ),
                          ),
                          Text(
                            "${widget.post.comments.length}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: const FaIcon(
                              FontAwesomeIcons.retweet,
                              color: Colors.grey,
                              size: 19,
                            ),
                          ),
                          Text(
                            "${widget.post.repost}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: const FaIcon(
                              FontAwesomeIcons.heart,
                              color: Colors.grey,
                              size: 19,
                            ),
                          ),
                          Text(
                            "${widget.post.likes}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: const FaIcon(
                              FontAwesomeIcons.shareAlt,
                              color: Colors.grey,
                              size: 19,
                            ),
                          ),
                          const Spacer()
                        ],
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
