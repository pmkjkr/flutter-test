class Ad {
  String title, contents, img;

  Ad(this.title, this.contents, this.img);

  factory Ad.fromJson(dynamic json) {
    return Ad(json['title'] as String, json['contents'] as String, json['img'] as String);
  }

  @override
  String toString() {
    return '{${this.img},${this.title},${this.contents}}';
  }
}