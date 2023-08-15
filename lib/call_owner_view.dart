import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CallOwnerView extends StatelessWidget {
  const CallOwnerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 100),
          MaterialButton(
            elevation: 40,
            onPressed: () {
              showDialog<void>(
                  context: context,
                  builder: (_) {
                    return OrderConformDialog();
                  });
            },
            padding: const EdgeInsets.all(100),
            color: Colors.orange,
            textColor: Colors.white,
            shape: const CircleBorder(),
            child: const Text(
              "呼び出す",
              style: TextStyle(color: Colors.white, fontSize: 35),
            ),
          )
        ],
      ),
    );
  }
}

class OrderConformDialog extends StatelessWidget {
  const OrderConformDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('スタッフを呼びますか？'),
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
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('呼び出し中です。少々お待ち下さい。'),
              ),
            );
          },
        )
      ],
    );
  }
}
