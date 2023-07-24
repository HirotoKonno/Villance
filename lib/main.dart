import 'package:flutter/material.dart';

import 'cart_view.dart';
import 'item_list_view.dart';

void main() => runApp(
      const MaterialApp(
        home: VillanceApp(),
      ),
    );

class VillanceApp extends StatefulWidget {
  const VillanceApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NavigationState();
  }
}

class _NavigationState extends State<VillanceApp> {
  var _navIndex = 0;

  List<Widget> display = [
    const ItemListView(),
    const ItemListView(),
    const CartView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('ご注文',style: TextStyle(color: Colors.black),),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.coffee_sharp),
            label: 'ドリンク',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: '食べ物',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'カート',
          ),
        ],
        onTap: (int index) {
          setState(
            () {
              _navIndex = index;
            },
          );
        },
        currentIndex: _navIndex,
      ),
      body: display[_navIndex],
    );
  }
}
