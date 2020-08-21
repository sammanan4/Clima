import 'package:flutter/material.dart';

class TileList extends StatelessWidget {

  final leading, title, flex;

  TileList({this.leading, @required this.title, this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: this.flex,
      child: ListTile(
        leading: this.leading,
        title: this.title,
      ),
    );
  }
}
