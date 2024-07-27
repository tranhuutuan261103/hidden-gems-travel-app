import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_app/models/post_model.dart';

class PostVerticalWidget extends StatelessWidget {
  const PostVerticalWidget({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 220,
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade700,
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(post.images.isNotEmpty ? post.images.first : ''),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  post.isArrived
                      ? Icons.check_circle_sharp
                      : post.isUnlocked
                          ? Icons.lock_open
                          : Icons.lock,
                  color: Colors.deepOrange,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 150,
                  child: Text(
                    post.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      post.starAverage.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(
                      Icons.star,
                      color: Colors.deepOrange,
                      size: 16,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
