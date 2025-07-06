class NoteModel {
  final String id;
  final String text;

  NoteModel({required this.id, required this.text});

  Map<String, dynamic> toMap() => {'text': text};

  factory NoteModel.fromMap(String id, Map<String, dynamic> map) {
    return NoteModel(id: id, text: map['text'] ?? '');
  }
}
