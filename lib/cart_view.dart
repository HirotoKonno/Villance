import 'package:flutter/material.dart';

import 'cart_list_view.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('カート', style: TextStyle(color: Colors.black),),
      ),
      body: Container(
        color: Colors.white,
        child: const CartListView(),
      ),
    );
  }
}
