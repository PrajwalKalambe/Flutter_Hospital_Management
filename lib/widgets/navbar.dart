import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  CustomBottomNavBar({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.map((item) {
            return _buildNavBarItem(
              context,
              item['icon'],
              isSelected: item['isSelected'] ?? false,
              onPressed: item['onPressed'],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNavBarItem(BuildContext context, IconData icon, {bool isSelected = false, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Icon(
        icon,
        size: 28,
        color: isSelected ? const Color.fromARGB(255, 73, 70, 70) : const Color.fromARGB(255, 0, 0, 0),
      ),
    );
  }
}


