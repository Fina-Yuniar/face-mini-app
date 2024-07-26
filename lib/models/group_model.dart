class Group {
  final int? id;
  final String name;
  final String description;

  Group({this.id, required this.name, required this.description});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
