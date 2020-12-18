class Post {
  String title, contents;
  int id, category_id, user_id;
  DateTime created_at;

  Post(this.title, this.contents, this.id, this.category_id, this.user_id, this.created_at);

  factory Post.fromJson(dynamic json) {
    return Post(json['title'] as String, json['contents'] as String, json['id'] as int, json['category_id'] as int, json['user_id'] as int, DateTime.parse(json['created_at'] as String));
  }

  @override
  String toString() {
    return '{${this.id},${this.title},${this.contents}}';
  }
}