import 'package:flutter/material.dart';

class CameraChoiceWidget extends StatelessWidget {
  CameraChoiceWidget({
    super.key,
    required this.icon,
    required this.onTap,
    required this.radiusOnly,
  });
  final BorderRadiusGeometry? radiusOnly;
  final IconData? icon;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration:
            BoxDecoration(color: Colors.purple, borderRadius: radiusOnly),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            size: 25,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}