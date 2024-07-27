import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_app/models/category_model.dart';
import 'package:travel_app/models/post_model.dart';
import 'package:travel_app/models/retrieve_model.dart';
import 'package:travel_app/services/category_service.dart';
import 'package:travel_app/services/post_service.dart';
import 'package:travel_app/services/retrieve_service.dart';
import 'package:travel_app/views/screens/welcome_screen.dart';
import 'package:travel_app/views/widgets/category_widget.dart';
import 'package:travel_app/views/widgets/retrieve_widget.dart';
import '../widgets/location_item.dart';

class CoordinatesScreen extends StatefulWidget {
  final String message;

  const CoordinatesScreen({
    super.key,
    required this.message,
  });

  @override
  State<CoordinatesScreen> createState() => _CoordinatesScreenState();
}

class _CoordinatesScreenState extends State<CoordinatesScreen> {
  double? _selectedDistance = 20;
  int _selectedCategoryIndex = 0;
  final CategoryService _categoryService = CategoryService();
  final PostService _postService = PostService();
  late Future<List<Category>> _futureCategories = Future.value([]);
  List<Category> _categories = [];
  late Future<List<Post>> _futurePosts = Future.value([]);
  File? _selectedImage;
  late String address;
  GeoCode geoCode = GeoCode();
  final RetrieveService _retrieveService = RetrieveService();
  List<String> _keyWords = [];
  final TextEditingController _keywordsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _getAddress();
  }

  void _setKeyWords(List<String> keyWords) {
    setState(() {
      _keyWords = keyWords;
      _keywordsController.text = _keyWords.join(', ');
      _fetchPosts();
    });
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
          keywords: _keywordsController.text.isEmpty
              ? null
              : _keywordsController.text,
        );
      } else {
        _futurePosts = _postService.fetchPosts(
          longitude: longitude,
          latitude: latitude,
          categoryId: categoryId,
          maxDistance: _selectedDistance,
          image: _selectedImage, // Truyền ảnh đã chọn vào hàm fetchPosts
          keywords: _keywordsController.text.isEmpty
              ? null
              : _keywordsController.text,
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

  void showDistanceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.grey[850],
              title: const Center(
                child: Text(
                  'Khoảng cách tìm kiếm',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 87, 51),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              content: Container(
                height: 300,
                width: 300,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDistance = 20;
                        });
                      },
                      child: Container(
                        width: 350,
                        height: 350,
                        decoration: BoxDecoration(
                          color: _selectedDistance! >= 20
                              ? Colors.grey[800]
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.fromBorderSide(
                            BorderSide(
                              width: 2,
                              color: _selectedDistance! >= 20
                                  ? Color.fromARGB(255, 255, 87, 51)
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDistance = 10;
                        });
                      },
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: _selectedDistance! >= 10
                              ? Colors.grey[800]
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.fromBorderSide(
                            BorderSide(
                              width: 2,
                              color: _selectedDistance! >= 10
                                  ? Color.fromARGB(255, 255, 87, 51)
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDistance = 2;
                        });
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: _selectedDistance! >= 2
                              ? Colors.grey[800]
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.fromBorderSide(
                            BorderSide(
                              width: 2,
                              color: _selectedDistance! >= 2
                                  ? Color.fromARGB(255, 255, 87, 51)
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: Text(
                        '$_selectedDistance KM',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
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
              }),
              value.streetAddress == null
                  ? setState(() {
                      address = 'Vị trí hiện tại';
                    })
                  : setState(() {
                      address =
                          '${value.streetNumber}, ${value.streetAddress}, ${value.city}, ${value.countryName}' ??
                              '';
                    })
            });

    if (address.split(',')[0] == null) {
      setState(() {
        address = 'Vị trí hiện tại';
      });
    }
  }

  Future<void> _showLinkDialog() async {
    TextEditingController linkController = TextEditingController();
    bool isLoading = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.grey[850],
              title: const Text(
                'Nhập link',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 87, 51),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 255, 87, 51),
                        ),
                      ),
                    )
                  : TextField(
                      controller: linkController,
                      decoration: const InputDecoration(
                        hintText: "Nhập link tại đây",
                        hintStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 255, 87, 51),
                          ),
                        ),
                      ),
                      cursorColor: Color.fromARGB(255, 255, 87, 51),
                      style: const TextStyle(color: Colors.white),
                    ),
              actions: isLoading
                  ? []
                  : [
                      TextButton(
                        child: const Text(
                          "OK",
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 87, 51)),
                        ),
                        onPressed: () async {
                          String url = linkController.text;
                          if (url.isNotEmpty) {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              RetrieveResult result = await _retrieveService
                                  .fetchRetrieveResult(url, 'platform');
                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ResultScreen(
                                    result: result,
                                    setKeyWords: _setKeyWords,
                                  ),
                                ),
                              );
                            } catch (e) {
                              // Xử lý lỗi khi gọi API
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to retrieve data: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                      ),
                      TextButton(
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.grey),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 33, 33, 33),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        backgroundColor: Color.fromARGB(255, 33, 33, 33),
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  hintText: address,
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.location_on_outlined,
                    color: Color.fromARGB(255, 255, 87, 51),
                    size: 18,
                  ),
                ),
                enabled: false,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50))),
                    child: TextField(
                      controller: _keywordsController,
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.grey),
                        hintText: 'Bạn muốn tới đâu ?',
                        border: InputBorder.none,
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.link_outlined,
                              color: Color.fromARGB(255, 255, 87, 51)),
                          onPressed: () {
                            _showLinkDialog();
                          },
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.camera_alt_outlined,
                              color: Color.fromARGB(255, 255, 87, 51)),
                          onPressed: () {
                            _pickImage();
                          },
                        ),
                      ),
                      cursorColor: Color.fromARGB(255, 255, 87, 51),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      onSubmitted: (value) {
                        _fetchPosts();
                        _keywordsController.clear();
                      },
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDistanceDialog(context);
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[850],
                    ),
                    width: 45,
                    height: 45,
                    child: Image.asset(
                      'assets/images/distance.png',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Danh mục',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder<List<Category>>(
                future: _futureCategories,
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
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: snapshot.data!.asMap().entries.map((entry) {
                          int idx = entry.key;
                          Category category = entry.value;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategoryIndex = idx;
                              });
                              _fetchPosts();
                            },
                            child: CategoryWidget(
                              icon: category.iconName,
                              label: category.name,
                              isSelected: idx == _selectedCategoryIndex,
                            ),
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
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Địa điểm',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
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
                          return location_item(
                            post: post,
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
}
