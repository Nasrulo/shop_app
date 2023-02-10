import 'package:flutter/material.dart';

class GoogleFacebookGuestWidget extends StatelessWidget {
  const GoogleFacebookGuestWidget({
    super.key,
    required this.title,
    required this.onTap,
    required this.icon,
    required this.color,
  });

  final String title;
  final Function() onTap;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Icon(
            icon,
            size: 50,
            color: color,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }
}