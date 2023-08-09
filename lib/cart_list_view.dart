import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database_helper.dart';
import 'main.dart';

class CartListView extends ConsumerStatefulWidget {
  const CartListView({super.key});

  @override
  createState() => _CartListState();
}

class _CartListState extends ConsumerState<CartListView> {
  final dbHelper = DatabaseHelper.instance;
  Future<List<Item>>? _cartData;

  void _handlePlusPressed() {
    return;
  }

  void _handleMinusPressMd() {
    return;
  }

  Future<List<Item>> _getCartItems() async {
    return await dbHelper.getCartItems();
  }

  @override
  void initState() {
    super.initState();
    _cartData = _getCartItems();
  }

  @override
  Widget build(BuildContext context) {
    final StateController<int> notificationCountNotifier =
        ref.watch(notificationCountProvider.notifier);

    return FutureBuilder(
        future: _cartData,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<Item> data = snapshot.data;

              return Container(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: ListView(
                        children: <Widget>[
                          for (var i = 0; i < data.length; i++)
                            Card(
                                child: Row(
                              children: <Widget>[
                                const Expanded(
                                    child: ListTile(
                                  leading: Icon(Icons.local_drink),
                                  title: Text("A",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                )),
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
                                const SizedBox(width: 20),
                                const Text(
                                  "9",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(width: 20),
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
                              ],
                            )),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(250, 50),
                        ),
                        child: const Text('注文する'),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              );
            } else {
              String data = 'エラー';
              return const Text("No widget to build");
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            );
          } else {
            String data = 'エラー';
            return const Text("No widget to build");
          }
        });
  }
}
