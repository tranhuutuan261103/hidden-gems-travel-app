import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_app/models/comment.dart';
import 'package:travel_app/services/user_service.dart';

class CommentService {
  final String apiUrl = "http://192.168.206.118:3000/api/comments";
  UserService userService = UserService();

  Future<Map<String, dynamic>> createComment(
      String content, int star, String postId) async {
   String? token = await userService.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse('$apiUrl/create');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      'content': content,
      'star': star,
      'postId': postId,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create comment');
    }
  }

  Future<List<Comment>> getComments(String postId) async {
    String? token = await userService.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse('$apiUrl/$postId');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final rawData = response.body;
      print(
          'Raw response data: $rawData'); // Debug: Print the raw response body

      try {
        final data = jsonDecode(rawData);
        print('Decoded data: $data'); // Debug: Print the decoded response data

        if (data is Map<String, dynamic> && data['comments'] is List) {
          final comments = (data['comments'] as List)
              .map((comment) => Comment.fromJson(comment))
              .toList();
          return comments;
        } else {
          throw Exception('Unexpected response format');
        }
      } catch (e) {
        print('Error during JSON decoding: $e');
        throw Exception('Failed to decode JSON');
      }
    } else {
      print('Failed to fetch comments: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to get comments');
    }
  }
}
