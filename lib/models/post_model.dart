class PostModel {
  String? post;
  String? userName;
  String? displayname;
  String? topic;
  int likes;
  int repost;
  String? profilePic;
  List<String> comments;
  String? firebaseKey;

  PostModel(
      {this.comments = const [],
      this.displayname,
      this.likes = 0,
      this.post,
      this.repost = 0,
      this.topic,
      this.userName,
      this.profilePic,
      this.firebaseKey});

  factory PostModel.fromJson(Map<String, dynamic> data) {
    return PostModel(
      comments: data['comments'] ?? [],
      displayname: data['name'] ?? "Unknown",
      likes: data['likes'] ?? 0,
      post: data['post'] ?? "error getting post",
      repost: data['repost'] ?? 0,
      profilePic: data['profile'],
      topic: data['topic'] ?? "sample Topic",
      userName: data['userName'] ?? "@userName",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "comments": comments,
      "name": displayname,
      "likes": likes,
      "repost": repost,
      "profile": profilePic,
      "topic": topic,
      "post": post,
      "userName": userName
    };
  }
}
