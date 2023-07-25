import 'package:flutter/material.dart';

import 'cart_view.dart';
import 'item_list_view.dart';

import 'package:badges/badges.dart' as badges;

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
    const CartView(),
    const CartView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'ご注文',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            color: Colors.black,
            icon: const badges.Badge(
              badgeContent: Text("2"),
              child: Icon(Icons.shopping_cart),),
            onPressed: () => {},
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'お食事',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fire_hydrant_alt),
            label: 'シーシャ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.house_siding_sharp),
            label: 'サウナ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_people),
            label: '呼び出し',
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
