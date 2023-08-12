import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:villance/rental_list_view.dart';

import 'cart_view.dart';
import 'drink_list_view.dart';

import 'package:badges/badges.dart' as badges;

import 'onion_view.dart';

void main() => runApp(
      const ProviderScope(
        child: MaterialApp(
          home: VillanceApp(),
        ),
      ),
    );

class VillanceApp extends ConsumerStatefulWidget {
  const VillanceApp({super.key});

  @override
  createState() => _NavigationState();
}

final notificationCountProvider = StateProvider((ref) => 0);

class _NavigationState extends ConsumerState<VillanceApp> {
  var _navigationIndex = 0;
  var _appBarTitle = 'ご注文';

  List<Widget> display = [
    DrinkListView(),
    const OnionView(),
    RentalListView(),
    DrinkListView(),
    DrinkListView(),
    DrinkListView(),
  ];

  @override
  Widget build(BuildContext context) {
    final int notificationCount = ref.watch(notificationCountProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          _appBarTitle,
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            color: Colors.black,
            icon: badges.Badge(
              showBadge: (notificationCount == 0) ? false : true,
              badgeContent: Text(notificationCount.toString()),
              child: const Icon(Icons.shopping_cart),
            ),
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartView()),
              )
            },
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
