// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    Key? key,
    required this.icon,
    required this.label,
    required this.isSelected,
  }) : super(key: key);

  final String icon;
  final String label;
  final bool isSelected;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isSelected
                  ? Color.fromARGB(255, 255, 87, 51)
                  : Colors.grey[850],
              shape:
                  BoxShape.circle, // Sử dụng BoxShape.circle để tạo hình tròn
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                getIconData(icon),
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontSize: 11,
            ),
          )
        ],
      ),
    );
  }
}
