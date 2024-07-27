import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_app/services/user_service.dart';
import '../models/post_model.dart';

class PostService {
  final String apiUrl = "http://192.168.206.118:3000/api/posts";
  UserService userService = UserService();

  Future<List<Post>> fetchPosts({
    required double longitude,
    required double latitude,
    String? categoryId,
    double? maxDistance,
    int? limit,
    File? image,
    String? keywords,
  }) async {
    String? token = await userService.getToken();
    if (token == null) {
      throw Exception('Không tìm thấy token, vui lòng đăng nhập trước.');
    }

    final queryParams = {
      'longitude': longitude.toString(),
      'latitude': latitude.toString(),
    };

    if (categoryId != null) {
      queryParams['categoryId'] = categoryId.toString();
    }

    if (maxDistance != null) {
      queryParams['maxDistance'] = maxDistance.toString();
    }

    if (limit != null) {
      queryParams['limit'] = limit.toString();
    }

    if (keywords != null) {
      queryParams['keywords'] = keywords.toString();
    }

    final Uri url = Uri.parse(apiUrl).replace(queryParameters: queryParams);

    var request = http.MultipartRequest('GET', url)
      ..headers['Authorization'] = 'Bearer $token';

    if (image != null) {
      var stream = http.ByteStream(image.openRead());
      var length = await image.length();
      var multipartFile = http.MultipartFile('image', stream, length,
          filename: image.path.split('/').last);
      request.files.add(multipartFile);
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      List<dynamic> postJson = json.decode(responseBody);
      return postJson.map((json) => Post.fromJson(json)).toList();
    } else {
      var decodedResponse = json.decode(responseBody);
      if (decodedResponse['message'] == 'Token invalid') {
        throw Exception('Token không hợp lệ');
      } else {
        throw Exception('Tải bài viết thất bại');
      }
    }
  }

  Future<void> createPost({
    required String title,
    required String content,
    required String address,
    required double longitude,
    required double latitude,
    required String categoryId,
    required List<File> images,
  }) async {
    String? token = await userService.getToken();
    if (token == null) {
      throw Exception('Không tìm thấy token, vui lòng đăng nhập trước.');
    }

    var request = http.MultipartRequest('POST', Uri.parse('$apiUrl/create'))
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['title'] = title
      ..fields['content'] = content
      ..fields['address'] = address
      ..fields['longitude'] = longitude.toString()
      ..fields['latitude'] = latitude.toString()
      ..fields['categoryId'] = categoryId;

    for (File image in images) {
      var stream = http.ByteStream(image.openRead());
      var length = await image.length();
      var multipartFile = http.MultipartFile('images', stream, length,
          filename: image.path.split('/').last);
      request.files.add(multipartFile);
    }

    var response = await request.send();
    if (response.statusCode != 200) {
      var responseBody = await response.stream.bytesToString();
      var decodedResponse = json.decode(responseBody);
      if (decodedResponse['message'] == 'Token invalid') {
        throw Exception('Token không hợp lệ');
      } else {
        throw Exception('Tạo bài viết thất bại');
      }
    }
  }

  Future<String> unlockPost(String postId) async {
    String? token = await userService.getToken();
    if (token == null) {
      throw Exception('Không tìm thấy token, vui lòng đăng nhập trước.');
    }

    final Uri url = Uri.parse('$apiUrl/$postId/unlocked');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['message'] == 'Unlocked post') {
        return 'Đã mở khóa bài viết';
      } else {
        throw Exception('Phản hồi không mong muốn: ${response.body}');
      }
    } else {
      throw Exception('Mở khóa bài viết thất bại');
    }
  }

  Future<String> checkinPost(
      String postId, double longitude, double latitude) async {
    String? token = await userService.getToken();
    if (token == null) {
      throw Exception('Không tìm thấy token, vui lòng đăng nhập trước.');
    }

    final Uri url = Uri.parse('$apiUrl/$postId/arrived');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'longitude': longitude,
        'latitude': latitude,
      }),
    );

    if (response.statusCode == 200) {
      return 'Đã check-in thành công';
    } else {
      var decodedResponse = json.decode(response.body);
      if (decodedResponse['message'] == 'Token invalid') {
        throw Exception('Token không hợp lệ');
      } else {
        throw Exception('Check-in thất bại');
      }
    }
  }

  // New method to fetch a post by its ID
  Future<Post> fetchPostById(String postId) async {
    String? token = await userService.getToken();
    if (token == null) {
      throw Exception('Không tìm thấy token, vui lòng đăng nhập trước.');
    }

    final Uri url = Uri.parse('$apiUrl/$postId');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return Post.fromJson(responseBody);
    } else {
      var decodedResponse = json.decode(response.body);
      if (decodedResponse['message'] == 'Token invalid') {
        throw Exception('Token không hợp lệ');
      } else {
        throw Exception('Tải bài viết thất bại');
      }
    }
  }
}
