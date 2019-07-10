import 'dart:convert';

class ToDo {
  final String title;
  bool ok;

  ToDo({this.title, this.ok});

  factory ToDo.fromJson(Map<String, dynamic> json) {
    return ToDo(
      title: json['title'],
      ok: json['ok'],
    );
  }

  @override
  String toString() {
    return json.encode({
      'title': title,
      'ok': ok,
    });
  }
}
