import 'package:flutter/material.dart';
import 'package:villance/picture_card.dart';

class ItemListView extends StatefulWidget {
  const ItemListView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<ItemListView> {
  // late final int navigationPosition;

  final List<PictureCard> _cardList = <PictureCard>[];

  _State() {
    _cardList.add(const PictureCard(
      '牛丼',
      '890円',
      'gyudon1.png',
    ));
    _cardList.add(const PictureCard(
      '淡路カクテル',
      '500円',
      'drink.png',
    ));
    _cardList.add(const PictureCard(
      'BECHILL',
      '700円',
      'bechill.png',
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: ListView.builder(
        itemCount: _cardList.length,
        itemBuilder: (BuildContext context, int index) {
          return _cardList[index];
        },
      ),
    );
  }
}
