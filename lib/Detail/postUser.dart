class PostUser {
  String name, email;
  int id;

  PostUser(this.name, this.email, this.id);

  factory PostUser.fromJson(dynamic json) {
    return PostUser(json['name'] as String, json['email'] as String, json['id'] as int);
  }
}