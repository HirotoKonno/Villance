import 'package:flutter/material.dart';
import 'package:villance/picture_card.dart';
import 'item_list_view.dart';

class RentalListView extends StatelessWidget {
  final List<PictureCard> _rentalCardList = <PictureCard>[];

  RentalListView({super.key}) {
    _rentalCardList.add(const PictureCard.rental(
      '玉ねぎサウナハット',
      '500円',
      'rental_sauna_hat.png',
    ));
    _rentalCardList.add(const PictureCard.rental(
      'サウナポンチョ(ネイビー)',
      '500円',
      'rental_poncho_navy.png',
    ));
    _rentalCardList.add(const PictureCard.rental(
      'サウナポンチョ(グレー)',
      '500円',
      'rental_poncho_gray.png',
    ));
    _rentalCardList.add(const PictureCard.rental(
      '水着(メンズ)',
      '500円',
      'rental_swimwear.png',
    ));
  }

  @override
  Widget build(BuildContext context) {
    return CardListView(cardList: _rentalCardList);
  }
}
