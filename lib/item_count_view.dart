import 'package:flutter/material.dart';

class ItemCountView extends StatefulWidget {
  const ItemCountView({super.key});

  @override
  createState() => _ChangeItemCountState();
}

class _ChangeItemCountState extends State<ItemCountView> {
  int _count = 0;

  void _handlePlusPressed() {
    setState(() {
      _count++;
    });
  }

  void _handleMinusPressMd() {
    setState(() {
      if (_count != 0) {
        _count--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingActionButton(
                onPressed: _handleMinusPressMd,
                backgroundColor: Colors.white,
                child: const Icon(Icons.remove, color: Colors.black,)),
            Text(
              "$_count",
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w500),
            ),
            FloatingActionButton(
                onPressed: _handlePlusPressed,
                backgroundColor: Colors.white,
                child: const Icon(Icons.add, color: Colors.black,))
          ],
        ));
  }
}