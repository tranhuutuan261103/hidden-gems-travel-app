import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:travel_app/models/category_model.dart';
import 'package:travel_app/services/user_service.dart';

class CategoryService {
  final String apiUrl = "http://192.168.206.118:3000/api/categories";
  UserService userService = UserService();

  Future<List<Category>> fetchCategories() async {
    String? token = await userService.getToken();
    if (token == null) {
      throw Exception('No token found, please login first.');
    }

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> categoryJson = json.decode(response.body);
      return categoryJson.map((json) => Category.fromJson(json)).toList();
    } else {
      var responseBody = json.decode(response.body);
      if (responseBody['message'] == 'Token invalid') {
        throw Exception('Token invalid');
      } else {
        throw Exception('Failed to load categories');
      }
    }
  }
}
