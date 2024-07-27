import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_app/models/category_model.dart';
import 'package:travel_app/models/post_model.dart';
import 'package:travel_app/services/category_service.dart';
import 'package:travel_app/services/post_service.dart';
import 'package:travel_app/views/screens/welcome_screen.dart';
import 'package:travel_app/views/widgets/category_widget.dart';
import '../widgets/location_item.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class HistoryScreen extends StatefulWidget {
  final String message;

  const HistoryScreen({
    super.key,
    required this.message,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  double? _selectedDistance = 2;
  int _selectedCategoryIndex = 0;
  final CategoryService _categoryService = CategoryService();
  final PostService _postService = PostService();
  late Future<List<Category>> _futureCategories = Future.value([]);
  List<Category> _categories = [];
  late Future<List<Post>> _futurePosts = Future.value([]);
  File? _selectedImage;
  late String address;
  GeoCode geoCode = GeoCode();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _getAddress();
  }

  void _fetchCategories() {
    _futureCategories = _categoryService.fetchCategories();
    _futureCategories.then((categories) {
      setState(() {
        _categories = [
              Category(id: 'all', name: 'Tất cả', iconName: 'apps_outlined')
            ] +
            categories;

        _futureCategories = Future.value(_categories);
        _fetchPosts();
      });
    });
  }

  void _fetchPosts() {
    String? categoryId;
    categoryId = _categories[_selectedCategoryIndex].id;
    double longitude = double.parse(widget.message.split(',')[1]);
    double latitude = double.parse(widget.message.split(',')[0]);
    setState(() {
      if (categoryId == 'all') {
        _futurePosts = _postService.fetchPosts(
          longitude: longitude,
          latitude: latitude,
          maxDistance: _selectedDistance,
          image: _selectedImage, // Truyền ảnh đã chọn vào hàm fetchPosts
        );
      } else {
        _futurePosts = _postService.fetchPosts(
          longitude: longitude,
          latitude: latitude,
          categoryId: categoryId,
          maxDistance: _selectedDistance,
          image: _selectedImage, // Truyền ảnh đã chọn vào hàm fetchPosts
        );
      }
    });
  }

  void _showInvalidTokenDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Phiên làm việc đã hết"),
          content: const Text("Vui lòng đăng nhập lại."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => WelcomeScreen(),
                  ),
                ); // Navigate to the welcome screen
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      _fetchPosts(); // Gọi fetchPosts sau khi chọn ảnh
      _selectedImage = null; // Khởi tạo ảnh đã chọn là null
    }
  }

  void _getAddress() {
    double longitude = double.parse(widget.message.split(',')[1]);
    double latitude = double.parse(widget.message.split(',')[0]);
    setState(() {
      address = 'Vị trí hiện tại';
    });

    geoCode
        .reverseGeocoding(latitude: latitude, longitude: longitude)
        .then((value) => {
              setState(() {
                address =
                    '${value.streetNumber}, ${value.streetAddress}, ${value.city}, ${value.countryName}' ??
                        '';
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 33, 33, 33),
      appBar: AppBar(
        title: Text(
          'Lịch sử',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 33, 33, 33),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              FutureBuilder<List<Post>>(
                future: _futurePosts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      if (snapshot.error.toString() ==
                          'Exception: Token invalid') {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _showInvalidTokenDialog();
                        });
                        return Container();
                      } else {
                        return const Center(
                          child: Text('Đã xảy ra lỗi'),
                        );
                      }
                    }
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: snapshot.data!.map((post) {
                          // Adding fake dates for the history
                          String date = _getFakeDate(post.id);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                date,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              location_item(
                                post: post,
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fake date generator
  String _getFakeDate(String postId) {
    List<String> dates = [
      '20/07/2024',
      '15/06/2024',
      '05/05/2024',
      '10/04/2024',
      '25/03/2024',
    ];
    int hash = postId.hashCode;
    return dates[hash % dates.length];
  }
}
