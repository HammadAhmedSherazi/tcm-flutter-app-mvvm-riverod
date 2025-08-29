class NoteDataModel {
  final int id;
  final String title;
  final String description;
  final DateTime createdAt;
  bool isSelect;


  NoteDataModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.isSelect = false

  });

  factory NoteDataModel.fromJson(Map<String, dynamic> json) {
    return NoteDataModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      isSelect: false
   
    );
  }
}
