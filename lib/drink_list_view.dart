import 'package:flutter/material.dart';
import 'package:villance/picture_card.dart';
import 'item_list_view.dart';

class DrinkListView extends StatelessWidget {
  final List<PictureCard> _drinkCardList = <PictureCard>[];

  DrinkListView({super.key}) {
    _drinkCardList.add(const PictureCard.drink(
      '淡路カクテル',
      '500円',
      'drink.png',
    ));
    _drinkCardList.add(const PictureCard.drink(
      'BECHILL',
      '700円',
      'bechill.png',
    ));
  }

  @override
  Widget build(BuildContext context) {
    return CardListView(cardList: _drinkCardList);
  }
}
