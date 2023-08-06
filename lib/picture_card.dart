import 'package:flutter/material.dart';
import 'package:villance/item_count_view.dart';

class PictureCard extends StatelessWidget {
  final String _name;
  final int _price;
  final String _picture;
  final Icon icon;

  const PictureCard.drink(this._name, this._price, this._picture,
      {super.key, this.icon = const Icon(Icons.local_drink)});

  const PictureCard.rental(this._name, this._price, this._picture,
      {super.key, this.icon = const Icon(Icons.store_outlined)});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ListTile(
            leading: icon,
            title: Text(_name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("$_price円",
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Image.asset('images/$_picture'),
          ItemCountView(_name, _price),
        ],
      ),
    );
  }
}
