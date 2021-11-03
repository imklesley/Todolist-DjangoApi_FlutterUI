/// id : 8
/// body : "Funfou"
/// created : "2021-11-01T05:22:22.600911Z"
/// updated : "2021-11-01T05:43:20.964979Z"

class Note {
  late int _id;
  late String _body;

  Note({
    required int id,
    required String body,
  }) {
    _id = id;
    _body = body;
  }

  Note.fromJson(dynamic json) {
    _id = json['id'];
    _body = json['body'];
  }

  int get id => _id;

  String get body => _body;

  set body(String newValue) {
    _body = newValue;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['body'] = _body;

    return map;
  }
}
