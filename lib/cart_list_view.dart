import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:villance/item_image_map.dart';

import 'database_helper.dart';
import 'main.dart';

class CartListView extends ConsumerStatefulWidget {
  const CartListView({super.key});

  @override
  createState() => _CartListState();
}

class _CartListState extends ConsumerState<CartListView> {
  final dbHelper = DatabaseHelper.instance;
  Future<List<Item>>? cartData;
  String allMoney = "";

  _handlePlusPressed(String name, int quantity) async {
    Map<String, dynamic> row = {
      DatabaseHelper.name: name,
      DatabaseHelper.quantity: quantity + 1,
    };
    await dbHelper.updateCartItem(row);
  }

  _handleMinusPressMd(String name, int quantity) async {
    Map<String, dynamic> row = {
      DatabaseHelper.name: name,
      DatabaseHelper.quantity: quantity - 1,
    };
    await dbHelper.updateCartItem(row);
  }

  Future<List<Item>> _getCartItems() async {
    return await dbHelper.getCartItems();
  }

  Future clearCartItems() async {
    return await dbHelper.delete();
  }

  @override
  void initState() {
    super.initState();
    cartData = _getCartItems();
  }

  @override
  Widget build(BuildContext context) {
    final StateController<int> notificationCountNotifier =
        ref.watch(notificationCountProvider.notifier);

    return FutureBuilder(
        future: cartData,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<Item> data = snapshot.data;
              String countData = "";
              var allMineyInt = 0;
              for (var i = 0; i < data.length; i++) {
                allMineyInt += data[i].price * data[i].quantity;
              }
              allMoney = allMineyInt.toString();

              return Container(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: ListView(
                        children: <Widget>[
                          for (var i = 0; i < data.length; i++)
                            if (data[i].quantity >= 1)
                              Card(
                                  child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: ListTile(
                                    leading: SizedBox(
                                    // （1）画像を配置
                                    width: 50,
                                    height: 50,
                                    child: imageWidget(data[i].name),
                                    // : (省略)
                                  ),
                                    title: Text(data[i].name,
                                        style: const TextStyle(
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
                                      onPressed: () {
                                        final countDataInt = data[i].quantity--;
                                        notificationCountNotifier.state--;
                                        _handleMinusPressMd(
                                            data[i].name, countDataInt);
                                        setState(() {
                                          countData = countDataInt.toString();
                                        });
                                      },
                                      child: const Icon(
                                        Icons.remove,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    countData = data[i].quantity.toString(),
                                    style: const TextStyle(
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
                                      onPressed: () {
                                        final countDataInt = data[i].quantity++;
                                        notificationCountNotifier.state++;
                                        _handlePlusPressed(
                                            data[i].name, countDataInt);
                                        setState(() {
                                          countData = countDataInt.toString();
                                        });
                                      },
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
                    allMineyInt > 0 ?
                    Text("合計金額 : $allMoney円",
                        style: const TextStyle(
                          fontSize: 24,
                        )) : const Text("カートに何も入っていません"),
                    const SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        onPressed: allMineyInt == 0 ? null : () {
                          showDialog<void>(
                              context: context,
                              builder: (_) {
                                return OrderConformDialog(
                                    allMoney: allMoney,
                                    conformButtonHandler: clearCartList);
                              });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.orangeAccent,
                          minimumSize: const Size(250, 50),
                        ),
                        child: const Text('注文する',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              );
            } else {
              return const Text("ERROR");
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
            return const Text("ERROR");
          }
        });
  }

  Widget imageWidget(String name){
    var pictureName = ItemImageMap.map[name];
    return ClipRect(
        child: FittedBox(
          fit: BoxFit.cover,
          child: Image.asset('images/$pictureName'),
        )
    );
  }

  void clearCartList() {
    final StateController<int> notificationCountNotifier =
        ref.watch(notificationCountProvider.notifier);
    notificationCountNotifier.state = 0;

    cartData = _getCartItems();
    setState(() {});
  }
}

class OrderConformDialog extends StatelessWidget {
  final String allMoney;
  final Function conformButtonHandler;

  const OrderConformDialog(
      {Key? key, required this.allMoney, required this.conformButtonHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('注文しますか？'),
      content: Text('合計金額 : $allMoney円'),
      actions: <Widget>[
        CupertinoDialogAction(
          child: const Text('いいえ'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: const Text('はい'),
          onPressed: () {
            final dbHelper = DatabaseHelper.instance;
            dbHelper.delete();
            conformButtonHandler();
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('ご注文が確定しました'),
              ),
            );
          },
        )
      ],
    );
  }
}
