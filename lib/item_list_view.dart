import 'package:flutter/material.dart';
import 'package:villance/picture_card.dart';

class CardListView extends StatefulWidget {
  final List<PictureCard> cardList;

  const CardListView({super.key, required this.cardList});

  @override
  State<StatefulWidget> createState() {
    return _CardListState();
  }
}

class _CardListState extends State<CardListView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: ListView.builder(
        itemCount: widget.cardList.length,
        itemBuilder: (BuildContext context, int index) {
          return widget.cardList[index];
        },
      ),
    );
  }
}
