import 'package:flutter/material.dart';

class AuthTheme {
  static const Color primaryColor = Color(0xFFD24DFF);
  static const Color backgroundColor = Colors.black;
  static const Color textColor = Colors.white;
  static const Color secondaryTextColor = Color(0xFF999999);
  static const Color inputBackground = Color(0xFF1A1A1A);

  static TextStyle titleStyle = const TextStyle(
    color: textColor,
    fontSize: 25,
    fontWeight: FontWeight.bold,
  );

  static TextStyle subtitleStyle = const TextStyle(
    color: secondaryTextColor,
    fontSize: 17,
  );

  static TextStyle inputLabelStyle = const TextStyle(
    color: secondaryTextColor,
  );

  static TextStyle buttonTextStyle = const TextStyle(
    color: textColor,
    fontSize: 25,
    fontWeight: FontWeight.w600,
  );

  static InputDecoration inputDecoration(String hint) => InputDecoration(
    filled: true,
    fillColor: inputBackground,
    hintText: hint,
    hintStyle: const TextStyle(color: secondaryTextColor),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
  );
}