import 'package:flutter/material.dart';
import 'package:villance/rental_list_view.dart';

import 'cart_view.dart';
import 'drink_list_view.dart';

import 'package:badges/badges.dart' as badges;

import 'onion_view.dart';

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
  var _navigationIndex = 0;
  var _appBarTitle = "";

  List<Widget> display = [
    DrinkListView(),
    const OnionView(),
    RentalListView(),
    const CartView(),
    const CartView(),
    const CartView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          _appBarTitle,
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            color: Colors.black,
            icon: const badges.Badge(
              badgeContent: Text("2"),
              child: Icon(Icons.shopping_cart),
            ),
            onPressed: () => {},
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_drink),
            label: 'ドリンク',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.face),
            label: '玉ねぎ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store_outlined),
            label: 'レンタル',
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
          _onChangeAppBarTitle(index);
          setState(
            () {
              _navigationIndex = index;
            },
          );
        },
        currentIndex: _navigationIndex,
      ),
      body: display[_navigationIndex],
    );
  }

  void _onChangeAppBarTitle(int index) {
    switch (index) {
      case 0:
      case 1:
      case 2:
        _appBarTitle = 'ご注文';
        break;
      case 3:
      case 4:
        _appBarTitle = 'ご予約';
        break;
      case 5:
        _appBarTitle = 'ご連絡';
        break;
    }
  }
}
