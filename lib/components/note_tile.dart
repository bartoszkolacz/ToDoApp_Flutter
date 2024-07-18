import 'package:flutter/material.dart';

class NoteTile extends StatelessWidget {
  final String text;
  const NoteTile({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
    decoration: BoxDecoration(
      color: Colors.white70,
      borderRadius: BorderRadius.circular(8),
    ),
      child: ListTile(
        title: Text(text),
      ),
    );
  }
}

