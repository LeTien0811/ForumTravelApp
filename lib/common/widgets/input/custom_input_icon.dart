import 'package:flutter/material.dart';
// Giả sử AppColors đã được định nghĩa và có màu 'blue' và 'lightGray'
import 'package:travel_torum_app/core/config/theme/app_colors.dart';

class CustomInputsIcon extends StatefulWidget{
  final ValueChanged<String> onChanged;
  final String label;
  final double ? width;
  final double ? height;
  final IconData? icon; // <-- THÊM THUỘC TÍNH ICON

  const CustomInputsIcon({
    required this.onChanged,
    required this.label,
    this.width,
    this.height,
    this.icon, // <-- THÊM ICON VÀO CONSTRUCTOR
    super.key
  });

  @override
  State<CustomInputsIcon> createState() => _CustomInputsIcon();
}

class _CustomInputsIcon extends State<CustomInputsIcon> {
  String _currentInput = '';

  void _handleInputChange(String value) {
    setState(() {
      _currentInput = value;
    });

    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: TextField(
        onChanged: _handleInputChange,
        decoration: InputDecoration(
          prefixIcon: widget.icon != null
              ? Icon(widget.icon, color: AppColors.blue)
              : null,
          
          filled: true,
          fillColor: AppColors.gray,
          
          labelText: widget.label,
          
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            )
          ),
          
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.blue,
              width: 1,
            )
          )
        ),
      ),
    );
  }
}