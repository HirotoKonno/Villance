import 'package:flutter/material.dart';
import 'package:villance/item_count_view.dart';

class PictureCard extends StatelessWidget {

  final String _name;
  final String _desc;
  final String _picture;

  const PictureCard(this._name, this._desc, this._picture, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.coffee_sharp),
            title: Text(_name),
            subtitle: Text(_desc),
          ),
          Image.asset('images/$_picture'),
          const ItemCountView(),
        ],
      ),
    );
  }
}