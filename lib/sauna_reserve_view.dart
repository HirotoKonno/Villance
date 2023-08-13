import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SaunaReserveView extends StatefulWidget {
  const SaunaReserveView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SaunaReserveState();
  }
}

class _SaunaReserveState extends State<SaunaReserveView> {
  String? _prefecture;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 40),
      SizedBox(
        width: 340, //横幅
        height: 50, //高さ
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.orange,
            shape: const StadiumBorder(),
          ),
          onPressed: () {
            showDialog<void>(
                context: context,
                builder: (_) {
                  return const StartSaunaDialog(message: "今から開始しますか？");
                });
          },
          child: const Text(
            '今から開始する',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      const SizedBox(height: 40),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        SizedBox(
          width: 150, //横幅
          height: 50, //高さ
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.orange[300],
              shape: const StadiumBorder(),
            ),
            onPressed: () async {
              // 選択ダイアログを表示して、選択した都道府県を受け取る
              final selectedPrefecture = await showDialog<String>(
                context: context,
                builder: (context) => RserveTodayDialog(
                  prefecture: _prefecture,
                ),
              );
            },
            child: const Text(
              '本日のご予約',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        SizedBox(
          width: 150, //横幅
          height: 50, //高さ
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.orange[300],
              shape: const StadiumBorder(),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: const Text("予約時間を選択して下さい"),
                    children: <Widget>[
                      for (var i = 0; i < 50; i++)
                        Expanded(child: Center(
                          child: SimpleDialogOption(
                            onPressed: () {
                              Navigator.pop(context);
                              showDialog<void>(
                                  context: context,
                                  builder: (_) {
                                    return StartSaunaDialog(
                                        message: "$iに予約しますか？");
                                  });
                            },
                            child: Text("           $i           "),
                          ),
                        ),
                        ),
                    ],
                  );
                },
              );
            },
            child: const Text(
              '明日のご予約',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ]),
      const SizedBox(height: 50),
      const Text(
        '予約履歴',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      Flexible(
        child: ListView(
          children: <Widget>[
            for (var i = 0; i < 5; i++)
              Card(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox(width: 10),
                  const Text("今日 ： 10:00",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: 60, //横幅
                    height: 60, //高さ
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {},
                        child: const Icon(
                          Icons.delete_forever_rounded,
                          color: Colors.black,
                        )),
                  ),
                ],
              )),
          ],
        ),
      ),
    ]);
  }
}

class StartSaunaDialog extends StatelessWidget {
  final String message;

  const StartSaunaDialog({Key? key, required, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(message),
      content: const Text('※準備ができたらお呼びいたします'),
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
                content: Text('ご予約を承りました'),
              ),
            );
          },
        )
      ],
    );
  }
}

class RserveTodayDialog extends StatelessWidget {
  const RserveTodayDialog({
    Key? key,
    this.prefecture,
  }) : super(key: key);
  final String? prefecture;

  static const _prefectures = [
    '北海道',
    '青森県',
    '岩手県',
  ];

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: _prefectures
          .map(
            (p) => ListTile(
              leading: Visibility(
                visible: p == prefecture,
                child: const Icon(Icons.check),
              ),
              title: Text(p),
              onTap: () {
                Navigator.of(context).pop(p);
                showDialog<void>(
                    context: context,
                    builder: (_) {
                      return const StartSaunaDialog(message: "18:00");
                    });
              },
            ),
          )
          .toList(),
    );
  }
}
