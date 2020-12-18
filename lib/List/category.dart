class Category {
  String name;
  int id;
  bool activated = false;

  Category(this.name, this.id);

  factory Category.fromJson(dynamic json) {
    return Category(json['name'] as String, json['id'] as int);
  }

  @override
  String toString() {
    return '{${this.name},${this.id}}';
  }
}