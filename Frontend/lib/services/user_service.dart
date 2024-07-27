import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_app/models/user_model.dart';

class UserService {
  final String baseUrl =
      "http://192.168.206.118:3000/api/users"; // Update to your IP address

  Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      String token = responseBody['token'] ?? '';
      String role = responseBody['role'] ?? '';
      String id = responseBody['_id'] ?? '';
      String name = responseBody['name'] ?? '';
      List<String> postsFound =
          List<String>.from(responseBody['postsFound'] ?? []);
      List<String> postsUnlocked =
          List<String>.from(responseBody['postsUnlocked'] ?? []);
      double point = responseBody['points'] ?? 0.0;
      User user = User(
        email: email,
        token: token,
        role: role,
        id: id,
        name: name,
        postsFound: postsFound,
        postsUnlocked: postsUnlocked,
        point: point,
      );
      _saveToken(user.token);
      return user;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<User> register(
      String email, String password, String name, String role) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'name': name,
        'role': role,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      String token = responseBody['token'] ?? '';
      String role = responseBody['role'] ?? '';
      String id = responseBody['_id'] ?? '';
      String name = responseBody['name'] ?? '';
      List<String> postsFound =
          List<String>.from(responseBody['postsFound'] ?? []);
      List<String> postsUnlocked =
          List<String>.from(responseBody['postsUnlocked'] ?? []);
      double point = responseBody['points'] ?? 0.0;
      User user = User(
        email: email,
        token: token,
        role: role,
        id: id,
        name: name,
        postsFound: postsFound,
        postsUnlocked: postsUnlocked,
        point: point,
      );
      _saveToken(user.token);
      return user;
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<User> getUserInfo() async {
    String? token = await getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/info'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      String id = responseBody['_id'] ?? '';
      String name = responseBody['name'] ?? '';
      String email = responseBody['email'] ?? '';
      String role = responseBody['role'] ?? '';
      List<String> postsFound =
          List<String>.from(responseBody['postsFound'] ?? []);
      List<String> postsUnlocked =
          List<String>.from(responseBody['postsUnlocked'] ?? []);
      double point = responseBody['points'].toDouble() ?? 0.0;
      User user = User(
        email: email,
        token: token,
        role: role,
        id: id,
        name: name,
        postsFound: postsFound,
        postsUnlocked: postsUnlocked,
        point: point,
      );
      return user;
    } else {
      throw Exception('Failed to fetch user info');
    }
  }

  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }
}
