import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_gemini/flutter_gemini.dart' as gemini;
import 'package:google_generative_ai/google_generative_ai.dart' as ai;
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:travel_app/models/category_model.dart';
import 'package:travel_app/services/category_service.dart';
import 'package:travel_app/services/post_service.dart';
import 'package:travel_app/services/user_service.dart';
import 'package:travel_app/views/screens/add_succsess.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final List<String> images = [];
  String location = "Đang lấy vị trí...";
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool isAIloading = false;
  bool isLoading = false;
  List<Category> categories = [];
  Category? selectedCategory;

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _fetchCategories();
  }

  void _determinePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      location = "${position.latitude}, ${position.longitude}";
    });
  }

  void _fetchCategories() async {
    CategoryService categoryService = CategoryService();
    try {
      List<Category> fetchedCategories =
          await categoryService.fetchCategories();
      setState(() {
        categories = fetchedCategories;
        selectedCategory = categories.isNotEmpty ? categories[0] : null;
      });
    } catch (e) {
      log('Error fetching categories: $e');
    }
  }

  void _addImage() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      setState(() {
        images.add(photo.path);
      });
    }
  }

  void _editContentWithAI() async {
    // setState(() {
    //   isAIloading = true;
    // });
    final apiKey = 'AIzaSyCjnJ0PKitfDl5wMpWYruwuozz6CjHD1xc';
    final model = ai.GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

    List<ai.DataPart> imageParts = [];
    for (String imagePath in images) {
      try {
        File imageFile = File(imagePath);
        Uint8List imageData = await imageFile.readAsBytes();
        imageParts.add(ai.DataPart('image/jpeg', imageData));
      } catch (e) {
        log('Failed to load image: $imagePath, Error: $e');
      }
    }

    String title = titleController.text;
    String content = contentController.text;
    String detailedPrompt =
        "Dựa vào các hình ảnh được cung cấp, hãy viết một bài review chi tiết về địa điểm du lịch dựa vào tiêu đề '$title'. Bài viết nên tập trung vào không khí chung của địa điểm, các đặc điểm nổi bật và những cảm xúc mà địa điểm này mang lại cho du khách. Nếu có hình ảnh về đồ ăn, hãy mô tả về hương vị và trải nghiệm ẩm thực tại đây. Đề cập đến màu sắc và bố cục tổng quát của địa điểm, sử dụng nội dung của tôi: $content. đã được cung cấp và số lượng ảnh là ${images.length} để làm giàu cho bài viết. Hãy đảm bảo rằng bài review cung cấp thông tin hữu ích và thú vị cho những ai có ý định khám phá địa điểm này. Và ngôn ngữ của câu trả lời dựa vào ngôn ngữ của phần nội dung của tôi. Đặc biệt không được chỉ ra địa điểm cụ thể. Tôi chỉ cần khoảng 150 từ thôi";
    ai.TextPart prompt = ai.TextPart(detailedPrompt);

    try {
      final response = await model.generateContent([
        ai.Content.multi([prompt, ...imageParts])
      ]);

      List<String> words = response.text!.split(' ');
      int index = 0;
      setState(() {
        contentController.clear();
      });
      Timer.periodic(Duration(milliseconds: 150), (timer) {
        if (index < words.length) {
          setState(() {
            contentController.text += words[index] + ' ';
          });
          index++;
        } else {
          timer.cancel(); // Stop the timer when all words have been displayed
          setState(() {
            isAIloading = false;
          });
        }
      });
    } catch (e) {
      log('Error with AI content generation: $e');
      if (e.toString().contains(
          'GenerativeAIException: Candidate was blocked due to safety')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Nội dung không phù hợp, hãy thử lại.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  IconData getIconData(String iconName) {
    switch (iconName) {
      case 'travel_explore':
        return Icons.travel_explore;
      case 'hotel':
        return Icons.hotel;
      case 'local_dining':
        return Icons.local_dining;
      case 'train_outlined':
        return Icons.train_outlined;
      case 'beach_access_rounded':
        return Icons.beach_access_rounded;
      case 'apps_outlined':
        return Icons.apps_outlined;
      default:
        return Icons.error;
    }
  }

  Future<void> _postContent() async {
    if (titleController.text.isEmpty ||
        contentController.text.isEmpty ||
        images.isEmpty ||
        selectedCategory == null ||
        location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin trước khi đăng bài.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    PostService postService = PostService();
    try {
      List<File> imageFiles = images.map((path) => File(path)).toList();

      await postService.createPost(
        title: titleController.text,
        content: contentController.text,
        address: 'Không rõ',
        longitude: location.split(',').length > 1
            ? double.parse(location.split(',')[1])
            : 0,
        latitude: location.split(',').length > 1
            ? double.parse(location.split(',')[0])
            : 0,
        categoryId: selectedCategory?.id ?? '',
        images: imageFiles,
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SuccessScreen()),
      );
    } catch (e) {
      log('Error posting content: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Có lỗi xảy ra khi đăng bài. Vui lòng thử lại.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _showCategoryDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Icon(
                    getIconData(categories[index].iconName),
                    color: Color.fromARGB(255, 255, 87, 51),
                  ),
                  title: Text(
                    categories[index].name,
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    setState(() {
                      selectedCategory = categories[index];
                    });
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF222222),
      appBar: AppBar(
        title: Text('Đăng bài'),
        backgroundColor: Color(0xFF222222),
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[850],
                    ),
                    height: 250,
                    child: PageView.builder(
                      itemCount: images.length + 1,
                      itemBuilder: (context, index) {
                        if (index == images.length) {
                          return Center(
                            child: IconButton(
                              icon: const Icon(
                                Icons.add_a_photo,
                                size: 50,
                                color: Color.fromARGB(255, 255, 87, 51),
                              ),
                              onPressed: _addImage,
                            ),
                          );
                        } else {
                          return Image.file(File(images[index]));
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Tiêu đề',
                      labelStyle:
                          TextStyle(color: Color.fromARGB(255, 255, 87, 51)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: _showCategoryDialog,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  getIconData(selectedCategory?.iconName ?? ''),
                                  color: Color.fromARGB(255, 255, 87, 51),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  selectedCategory?.name ?? 'Chọn danh mục',
                                  style: const TextStyle(
                                      color: Colors.deepOrange, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: Color.fromARGB(255, 255, 87, 51),
                        size: 30,
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: contentController,
                    style: TextStyle(color: Colors.white),
                    maxLines: 10,
                    decoration: const InputDecoration(
                      labelText: 'Nội dung',
                      labelStyle:
                          TextStyle(color: Color.fromARGB(255, 255, 87, 51)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: _postContent,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 255, 87, 51),
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          '                         Đăng bài                       ',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 255, 87, 51)),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _editContentWithAI,
        child: Icon(Icons.auto_awesome),
        backgroundColor: Colors.greenAccent,
        tooltip: 'Chỉnh sửa bằng AI',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
