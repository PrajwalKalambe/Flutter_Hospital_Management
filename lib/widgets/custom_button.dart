import 'package:doctor_management/constants/color.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final VoidCallback onPressed;

  const CustomElevatedButton({
    Key? key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.borderRadius,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor, 
        backgroundColor: backgroundColor, 
        padding: const EdgeInsets.symmetric(vertical: 17), 
        textStyle: const TextStyle(fontSize: 22), 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius), 
          side: BorderSide(color: color.cyanLight, width: 5), 
        ),
      ),
      onPressed: onPressed,
      child: SizedBox(
        width: 310, 
        child: Text(
          label,
          textAlign: TextAlign.center, 
        ),
      ),
    );
  }
}
