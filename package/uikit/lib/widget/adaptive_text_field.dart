import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveTextField extends StatelessWidget {
  const AdaptiveTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.maxLines = 1,
    this.maxLength = 200,
  });
  final TextEditingController controller;
  final String? hintText;
  final int maxLines;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    return switch (Platform.isIOS) {
      true => CupertinoTextField(
        controller: controller,
        placeholder: hintText,
        maxLines: maxLines,
        maxLength: maxLength,
        padding: .all(12),
        decoration: BoxDecoration(
          color: CupertinoColors.systemFill,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      false => TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        maxLines: maxLines,
        maxLength: maxLength,
      ),
    };
  }
}
