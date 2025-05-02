import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShimmerGridItem extends StatelessWidget {
  const ShimmerGridItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(color: Colors.grey[300]),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 16,
              color: Colors.grey[300],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              height: 14,
              width: 60,
              color: Colors.grey[300],
              margin: const EdgeInsets.symmetric(horizontal: 40),
            ),
          ),
        ],
      ),
    );
  }
}