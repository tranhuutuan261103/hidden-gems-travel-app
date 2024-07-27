import 'package:flutter/material.dart';

class BottomNavItem {
  final Icon?
      icon; // Đã thay đổi thành nullable để có thể không cần thiết khi sử dụng constructor khác
  final String label;

  // Constructor mặc định với icon và label
  BottomNavItem({this.icon, required this.label});
}
