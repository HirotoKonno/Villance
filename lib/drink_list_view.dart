import 'package:flutter/material.dart';
import 'package:villance/picture_card.dart';
import 'item_list_view.dart';

class DrinkListView extends StatelessWidget {
  final List<PictureCard> _drinkCardList = <PictureCard>[];

  final List itemName = <String>['淡路カクテル', 'BECHILL'];
  final List itemPrice = <int>[500, 700];
  final List itemPngName = <String>['drink.png', 'bechill.png'];

  DrinkListView({super.key}) {
    for (int i = 0; i < itemName.length; i++) {
      _drinkCardList.add(PictureCard.drink(
        itemName[i],
        itemPrice[i],
        itemPngName[i],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CardListView(cardList: _drinkCardList);
  }
}
