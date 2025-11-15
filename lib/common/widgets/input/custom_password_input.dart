import 'package:flutter/material.dart';
import 'package:travel_torum_app/core/config/theme/app_colors.dart';

class CustomPasswordInput extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String label;
  final double? width;
  final double? height;
  final IconData? icon; // <-- THÊM THUỘC TÍNH ICON

  const CustomPasswordInput({
    required this.onChanged,
    required this.label,
    this.width,
    this.height,
    this.icon, // <-- THÊM ICON VÀO CONSTRUCTOR
    super.key,
  });

  @override
  State<CustomPasswordInput> createState() => _CustomPasswordInput();
}

class _CustomPasswordInput extends State<CustomPasswordInput> {
  bool _obscure = true;
  String _currentInput = '';

  void _toggleVisibility() {
    setState(() {
      _obscure = !_obscure;
    });
  }

  void _handleInputChange(String value) {
    setState(() {
      _currentInput = value;
    });

    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsetsGeometry.all(0),
      child: TextField(
        onChanged: _handleInputChange,
        obscureText: _obscure,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.password_rounded, color: AppColors.blue),
          suffixIcon: IconButton(
            onPressed: _toggleVisibility,
            icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility_outlined),
          ),
          labelText: "Please Enter Your Password",
          filled: true,
          fillColor: AppColors.gray,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.blue, width: 1),
          ),
        ),
      ),
    );
  }
}
