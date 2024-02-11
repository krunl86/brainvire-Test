import 'package:brainvire_test/common/consts/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductTextField extends StatefulWidget {
  const ProductTextField({
    super.key,
    required this.controller,
    required this.isEditable,
    required this.TextFieldType,
    required this.hint,
  });
  final TextEditingController controller;
  final bool isEditable;
  final int TextFieldType;
  final String hint;

  @override
  State<ProductTextField> createState() => _ProductTextFieldState();
}

class _ProductTextFieldState extends State<ProductTextField> {
  bool isEditable = false;

  @override
  void initState() {
    super.initState();
    isEditable = widget.isEditable;
  }

  @override
  void didUpdateWidget(covariant ProductTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    isEditable = widget.isEditable;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      enabled: isEditable,
      keyboardType: widget.TextFieldType == textFieldTypeText
          ? TextInputType.name
          : TextInputType.number,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter ${widget.hint}';
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        hintStyle: TextStyle(color: Colors.grey[800]),
        hintText: "title",
        fillColor: Colors.white70,
      ),
    );
  }
}
