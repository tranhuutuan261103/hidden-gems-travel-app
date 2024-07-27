class Category {
  String id;
  String name;
  String iconName;

  Category({required this.id, required this.name, required this.iconName});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      name: json['name'],
      iconName: json['icon'],
    );
  }
}
