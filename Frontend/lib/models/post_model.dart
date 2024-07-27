import 'package:travel_app/models/category_model.dart';

class Post {
  String id;
  String title;
  String content;
  double longitude;
  double latitude;
  String address;
  List<String> images;
  Category category;
  String createdBy;
  double starAverage;
  double distance;
  bool isUnlocked;
  bool isArrived;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.longitude,
    required this.latitude,
    required this.address,
    required this.images,
    required this.category,
    required this.createdBy,
    required this.starAverage,
    required this.distance,
    required this.isUnlocked,
    required this.isArrived,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      title: json['title'],
      content: json['content'],
      longitude: json['longitude'].toDouble(),
      latitude: json['latitude'].toDouble(),
      address: json['address'],
      images: List<String>.from(json['images']),
      category: Category.fromJson(json['category']),
      createdBy: json['createdBy'],
      starAverage: json['star_average'].toDouble(),
      distance: json['distance'].toDouble(),
      isUnlocked: json['isUnlocked'],
      isArrived: json['isArrived'],
    );
  }
}
