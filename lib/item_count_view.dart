import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cart_item_database_helper.dart';
import 'main.dart';

class ItemCountView extends ConsumerStatefulWidget {
  final String itemName;
  final int itemPrice;

  const ItemCountView(this.itemName, this.itemPrice, {super.key});

  @override
  createState() => _ChangeItemCountState();
}

class _ChangeItemCountState extends ConsumerState<ItemCountView> {
  final dbHelper = CartItemDatabaseHelper.instance;
  int _count = 0;

  get itemName => widget.itemName;

  get itemPrice => widget.itemPrice;

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

  void _clearCount() {
    setState(() {
      if (_count != 0) {
        _count = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final StateController<int> notificationCountNotifier =
        ref.watch(notificationCountProvider.notifier);
    return Container(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: 60, //横幅
              height: 60, //高さ
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                ),
                onPressed: _handleMinusPressMd,
                child: const Icon(
                  Icons.remove,
                  color: Colors.black,
                ),
              ),
            ),
            Text(
              "$_count",
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              width: 60, //横幅
              height: 60, //高さ
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                ),
                onPressed: _handlePlusPressed,
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              width: 60, //横幅
              height: 60, //高さ
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.orangeAccent,
                ),
                onPressed: _count == 0
                    ? null
                    : () {
                        for (int i in Iterable.generate(_count)) {
                          notificationCountNotifier.state++;
                        }
                        _insert(_count);
                        _clearCount();
                      },
                child: const Text('追加',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ));
  }

  void _insert(int quantity) async {
    Map<String, dynamic> row = {
      CartItemDatabaseHelper.name: itemName,
      CartItemDatabaseHelper.quantity: quantity,
      CartItemDatabaseHelper.price: itemPrice,
    };
    await dbHelper.updateOrInsertProduct(row);
  }
}
