class Categoria {
  String _id;
  String _titulo;
  Categoria(this._id, this._titulo);
  Categoria.map(dynamic obj) {
    this._id = obj['id'];
    this._titulo = obj['titulo'];
  }
  Categoria.fromMap(Map<String, dynamic> map, String id) {
    this._id = id ?? '';
    this._titulo = map["titulo"];
  }
  String get id => _id;
  String get titulo => _titulo;
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map["titulo"] = _titulo;
    return map;
  }
}