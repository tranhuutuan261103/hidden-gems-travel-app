import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:travel_app/models/post_model.dart';
import 'package:travel_app/services/post_service.dart';
import 'package:travel_app/services/user_service.dart';
import 'package:travel_app/views/screens/checkin_screen.dart';
import 'package:travel_app/views/screens/map_screen.dart';
import '../../models/comment.dart';
import '../../services/comment_service.dart';
import '../widgets/comment_tile.dart';

class LocationDetailScreen extends StatefulWidget {
  const LocationDetailScreen({super.key, required this.post});

  final Post post;

  @override
  State<LocationDetailScreen> createState() => _LocationDetailScreenState();
}

class _LocationDetailScreenState extends State<LocationDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  final List<Comment> _comments = [];
  final PageController _pageController = PageController();
  final UserService _userService = UserService();
  final CommentService _commentService = CommentService();
  double userPoints = 0.0;
  int _selectedStars = 5;

  @override
  void initState() {
    super.initState();
    _fetchComments();
    _fetchUserPoints();
  }

  void reloadCheckin() {
    setState(() {
      widget.post.isArrived = true;
    });
  }

  Future<void> _fetchComments() async {
    try {
      final comments = await _commentService.getComments(widget.post.id);
      setState(() {
        _comments.addAll(comments);
      });
    } catch (e) {
      print('Failed to fetch comments: $e');
    }
  }

  Future<void> _fetchUserPoints() async {
    try {
      final userInfo = await _userService.getUserInfo();
      setState(() {
        userPoints = userInfo.point;
      });
    } catch (e) {
      print('Failed to fetch user points: $e');
    }
  }

  Future<void> _addComment() async {
    final content = _commentController.text;
    final stars = _selectedStars;

    if (content.isEmpty) {
      return;
    }

    try {
      final newComment =
          await _commentService.createComment(content, stars, widget.post.id);
      _fetchComments();
      setState(() {
        _commentController.clear();
      });
    } catch (e) {
      print('Failed to add comment: $e');
    }
  }

  Future<void> unlockDestination(String postId) async {
    final postService = PostService();

    try {
      String message = await postService.unlockPost(postId);
      print(message); // "Unlocked post"
      // Reload the post state and user points after successful unlocking
      setState(() {
        widget.post.isUnlocked = true;
      });
      _fetchUserPoints();
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _showUnlockDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.orange[100],
          title: const Text('Xác nhận mở khóa',
              style: TextStyle(
                color: Colors.deepOrange,
              )),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn sẽ bị trừ 1000 điểm nếu mở khóa địa điểm này.'),
                Text('Bạn có chắc chắn muốn mở khóa không?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child:
                  const Text('OK', style: TextStyle(color: Colors.deepOrange)),
              onPressed: () {
                Navigator.of(context).pop();
                unlockDestination(widget.post.id);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 300,
                      color: Colors.grey[300],
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: widget.post.images.length,
                        itemBuilder: (context, index) {
                          return Image.network(
                            widget.post.images[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: SmoothPageIndicator(
                          controller: _pageController,
                          count: widget.post.images.length,
                          effect: const WormEffect(
                            dotHeight: 8,
                            dotWidth: 8,
                            activeDotColor: Colors.deepOrange,
                            dotColor: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.post.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 30,
                                color: Colors.yellow,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                widget.post.starAverage.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on_sharp,
                            size: 30,
                            color: Colors.deepOrange,
                          ),
                          !widget.post.isUnlocked
                              ? Stack(
                                  children: [
                                    const Text(
                                      '##########################',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                      softWrap: true,
                                    ),
                                    Positioned.fill(
                                      child: ClipRect(
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 5.0, sigmaY: 5.0),
                                          child: Text(
                                            '',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black
                                                  .withOpacity(0.0099999),
                                            ),
                                            softWrap: true,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  "${widget.post.latitude}, ${widget.post.longitude}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.orange[100],
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                const Text(
                                  'Thông tin',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  widget.post.content,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Positioned(
                            top: 0,
                            left: 0,
                            child: Icon(
                              Icons.push_pin,
                              color: Colors.deepOrange,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      widget.post.isUnlocked
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Đánh giá',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                for (var comment in _comments)
                                  CommentTile(comment: comment),
                                const SizedBox(height: 30),
                                _comments.isEmpty
                                    ? const Center(
                                        child: Text(
                                          'Chưa có đánh giá nào',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      )
                                    : Container(),
                                const SizedBox(height: 30),
                                widget.post.isArrived
                                    ? _buildCommentInput()
                                    : Container(),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 45,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                'Điểm: $userPoints',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8.0),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (widget.post.isUnlocked) {
            if (widget.post.isArrived) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MapScreen(
                          latitude: widget.post.latitude,
                          longitude: widget.post.longitude,
                        )),
              );
            } else {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CheckInScreen(
                          latitude: widget.post.latitude,
                          longitude: widget.post.longitude,
                          postId: widget.post.id,
                          onButtonPressed: reloadCheckin,
                        )),
              );
            }
          } else {
            _showUnlockDialog();
          }
        },
        backgroundColor: Colors.deepOrange,
        child: Icon(
          widget.post.isUnlocked
              ? widget.post.isArrived
                  ? Icons.directions
                  : Icons.location_history_rounded
              : Icons.lock,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildCommentInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Viết đánh giá của bạn',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                Icons.star,
                color: index < _selectedStars ? Colors.yellow : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _selectedStars = index + 1;
                });
              },
            );
          }),
        ),
        TextField(
          controller: _commentController,
          maxLines: 3,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Viết bình luận của bạn...',
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _addComment,
          child: const Text('Gửi đánh giá'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
        ),
      ],
    );
  }
}
