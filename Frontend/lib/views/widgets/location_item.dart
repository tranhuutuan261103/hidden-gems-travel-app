import 'package:flutter/material.dart';
import 'package:travel_app/models/post_model.dart';
import 'package:travel_app/views/screens/location_screen.dart';

class location_item extends StatelessWidget {
  const location_item({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LocationDetailScreen(
              post: post,
            ),
          ),
        );
      },
      child: Container(
        height: 100,
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: Colors.grey[850],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: Row(
            children: [
              SizedBox(
                width: 150,
                height: 100,
                child: Image.network(
                  post.images[0],
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        post.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 2,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 15,
                              color: Colors.yellow,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              post.starAverage.toStringAsFixed(
                                  2), // Format to two decimal places
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                              softWrap: true,
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Icon(
                          post.isArrived
                              ? Icons.check_circle
                              : post.isUnlocked
                                  ? Icons.lock_open
                                  : Icons.lock,
                          size: 15,
                          color: Colors.red,
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
