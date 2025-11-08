import 'package:flutter/material.dart';

class CustomInputs extends StatefulWidget{
  final ValueChanged<String> onChange;
  final String label;
  final double ? width;
  final double ? height;

  const CustomInputs({
    required this.onChange,
    required this.label,
    this.width,
    this.height,
    super.key
  });

  @override
  State<CustomInputs> createState => _CustomInputs();
}

class _CustomInputs extends State<CustomInputs> {

}