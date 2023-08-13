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
        title: const Text('カート', style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("注文履歴"),
                    content: const Text("AAAAA"),
                    actions: [
                      TextButton(
                        child: const Text("閉じる",style: TextStyle(color: Colors.black)),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text("注文履歴",style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: const CartListView(),
      ),
    );
  }
}
