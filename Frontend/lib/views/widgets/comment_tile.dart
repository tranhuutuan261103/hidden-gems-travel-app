import 'package:flutter/material.dart';
import 'package:travel_app/models/comment.dart';

class CommentTile extends StatelessWidget {
  final Comment comment;

  const CommentTile({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.orangeAccent.withOpacity(0.1), // Màu gạch nhẹ
        borderRadius: BorderRadius.circular(10), // Bo góc
      ),
      padding: const EdgeInsets.all(10), // Padding bên trong container
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(backgroundImage: NetworkImage(comment.avatarUrl)),
          SizedBox(width: 10), // Thêm khoảng cách giữa avatar và nội dung
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.userName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: List.generate(comment.stars, (index) {
                    return const Icon(Icons.star,
                        color: Colors.amber, size: 20);
                  }),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 80,
                  child: Text(
                    comment.comment,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                    softWrap: true,
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(comment.date,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
