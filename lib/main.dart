import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:villance/rental_list_view.dart';
import 'package:villance/sauna_reserve_view.dart';
import 'package:villance/shisha_reserve_view.dart';

import 'auth_manager.dart';
import 'call_owner_view.dart';
import 'cart_view.dart';
import 'cart_item_database_helper.dart';
import 'drink_list_view.dart';

import 'package:badges/badges.dart' as badges;

import 'onion_add_view.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // await LineSDK.instance.setup("2000467028");
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final _authManager = ref.watch(authManagerProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'タイトル',
      // ログイン中：ホーム画面、未ログイン：ログイン画面
      // home: _authManager.isLoggedIn ? const VillanceApp() : const Text("FALSE"),
      home: VillanceApp(),
    );
  }
}

class VillanceApp extends ConsumerStatefulWidget {
  const VillanceApp({super.key});

  @override
  createState() => _NavigationState();
}

final notificationCountProvider = StateProvider((ref) => 0);

class _NavigationState extends ConsumerState<VillanceApp> {
  final dbHelper = CartItemDatabaseHelper.instance;
  Future<List<Item>>? _cartData;
  var _navigationIndex = 0;
  var _appBarTitle = 'ご注文';

  Future<List<Item>> _getCartItems() async {
    return await dbHelper.getCartItems();
  }

  List<Widget> display = [
    DrinkListView(),
    const OnionAddView(),
    RentalListView(),
    const ShishaReserveView(),
    const SaunaReserveView(),
    const CallOwnerView(),
  ];

  @override
  void initState() {
    super.initState();
    _cartData = _getCartItems();
  }

  @override
  Widget build(BuildContext context) {
    int notificationCount = ref.watch(notificationCountProvider);

    return FutureBuilder(
        future: _cartData,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<Item> data = snapshot.data;
              for (var i = 0; i < data.length; i++) {
                notificationCount += data[i].quantity;
              }
              FlutterNativeSplash.remove();
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
                          MaterialPageRoute(
                              builder: (context) => const CartView()),
                        )
                      },
                    ),
                  ],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  selectedItemColor: Colors.orange,
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
            } else {
              return const Text("ERROR");
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text("loading now..."),
            );
          } else {
            return const Text("ERROR");
          }
        });
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
