import 'package:flutter/material.dart';
import 'package:villance/picture_card.dart';
import 'item_list_view.dart';

class RentalListView extends StatelessWidget {
  final List<PictureCard> _rentalCardList = <PictureCard>[];

  final List itemName = <String>[
    '玉ねぎサウナハット',
    'サウナポンチョ(ネイビー)',
    'サウナポンチョ(グレー)',
    '水着(メンズ)'
  ];
  final List itemPrice = <int>[500, 500, 500, 600];
  final List itemPngName = <String>[
    'rental_sauna_hat.png',
    'rental_poncho_navy.png',
    'rental_poncho_gray.png',
    'rental_swimwear.png'
  ];

  RentalListView({super.key}) {
    for (int i = 0; i < itemName.length; i++) {
      _rentalCardList.add(PictureCard.drink(
        itemName[i],
        itemPrice[i],
        itemPngName[i],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CardListView(cardList: _rentalCardList);
  }
}
