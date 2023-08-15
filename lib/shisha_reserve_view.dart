import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:villance/shisha_reserve_database_helper.dart';
import 'package:villance/shisha_time.dart';

class ShishaReserveView extends StatefulWidget {
  const ShishaReserveView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ShishaReserveState();
  }
}

class _ShishaReserveState extends State<ShishaReserveView> {
  final dbHelper = ShishaReserveDatabaseHelper.instance;
  Future<List<ReservedShisha>>? shishaReservedData;

  Future<List<ReservedShisha>> _getReservedItems() async {
    return await dbHelper.getReservedTimes();
  }

  @override
  void initState() {
    super.initState();
    shishaReservedData = _getReservedItems();
  }

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
            backgroundColor: Colors.blue,
            shape: const StadiumBorder(),
          ),
          onPressed: () {
            showDialog<void>(
                context: context,
                builder: (_) {
                  return StartShishaDialog(
                    message1st: "今からシーシャを開始しますか？",
                    message2nd: '',
                    messageSub: '※準備ができたらお部屋にお届けします',
                    isToday: 2,
                    addReserveTime: null,
                    reloadView: clearList,
                  );
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
              backgroundColor: Colors.blue[300],
              shape: const StadiumBorder(),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: const Text("予約時間を選択して下さい"),
                    children: <Widget>[
                      for (var i = 0;
                          i < ReserveTimeList.canShishaToday.length;
                          i++)
                        if (canReserveTime(ReserveTimeList.canShishaToday[i]))
                          Center(
                            child: SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(context);
                                showDialog<void>(
                                    context: context,
                                    builder: (_) {
                                      return StartShishaDialog(
                                        message1st:
                                            "${ReserveTimeList.canShishaToday[i]}",
                                        message2nd: 'に予約しますか？',
                                        messageSub: '',
                                        isToday: 1,
                                        addReserveTime: _addReserveTime,
                                        reloadView: clearList,
                                      );
                                    });
                              },
                              child: Text(
                                  "           ${ReserveTimeList.canShishaToday[i]}           "),
                            ),
                          ),
                    ],
                  );
                },
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
              backgroundColor: Colors.blue[300],
              shape: const StadiumBorder(),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: const Text("予約時間を選択して下さい"),
                    children: <Widget>[
                      for (var i = 0;
                          i < ReserveTimeList.canShishaTomorrow.length;
                          i++)
                        Center(
                          child: SimpleDialogOption(
                            onPressed: () {
                              Navigator.pop(context);
                              showDialog<void>(
                                  context: context,
                                  builder: (_) {
                                    return StartShishaDialog(
                                      message1st:
                                          "${ReserveTimeList.canShishaTomorrow[i]}",
                                      message2nd: 'に予約しますか？',
                                      messageSub: '',
                                      isToday: 0,
                                      addReserveTime: _addReserveTime,
                                      reloadView: clearList,
                                    );
                                  });
                            },
                            child: Text(
                                "           ${ReserveTimeList.canShishaTomorrow[i]}           "),
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
      const SizedBox(height: 10),
      const Text(
        '※本日は24時までご利用できます',
        style: TextStyle(color: Colors.black),
      ),
      const SizedBox(height: 50),
      const Text(
        '予約履歴',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      FutureBuilder(
          future: shishaReservedData,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<ReservedShisha> data = snapshot.data;
                var dayList = <String>[];
                for (var i = 0; i < data.length; i++) {
                  dayList.add(getDayName(data[i].isToday));
                }
                return Flexible(
                  child: ListView(
                    children: <Widget>[
                      for (var i = 0; i < data.length; i++)
                        Card(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const SizedBox(width: 10),
                            Text("${dayList[i]} ： ${data[i].hourMinutes}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
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
                                    showDialog<void>(
                                        context: context,
                                        builder: (_) {
                                          return DeleteShishaTimeDialog(
                                              message: "キャンセルしますか？",
                                              deleteTime: _deleteReserveTime,
                                              time: data[i].hourMinutes);
                                        });
                                  },
                                  child: const Icon(
                                    Icons.delete_forever_rounded,
                                    color: Colors.black,
                                  )),
                            ),
                          ],
                        )),
                    ],
                  ),
                );
              }
            }
            return const Text("");
          })
    ]);
  }

  void clearList() {
    shishaReservedData = _getReservedItems();
    setState(() {});
  }

  void _addReserveTime(int isToday, String time) async {
    Map<String, dynamic> row = {
      ShishaReserveDatabaseHelper.isToday: isToday,
      ShishaReserveDatabaseHelper.hourMinutesString: time,
    };
    await dbHelper.addReserveTime(row);
    clearList();
  }

  void _deleteReserveTime(String time) async {
    dbHelper.deleteTime(time);
    clearList();
  }

  String getDayName(int dayInt) {
    if (dayInt == ReservedDay.tomorrow.index) {
      return "明日";
    } else if (dayInt == ReservedDay.today.index) {
      return "本日";
    } else {
      return "その他";
    }
  }
}

enum ReservedDay {
  tomorrow,
  today,
  other,
}

class StartShishaDialog extends StatelessWidget {
  final String message1st;
  final String message2nd;
  final String messageSub;
  final int isToday;
  final Function? addReserveTime;
  final Function? reloadView;

  StartShishaDialog({
    Key? key,
    required,
    required this.message1st,
    required this.message2nd,
    required this.messageSub,
    required this.isToday,
    required this.addReserveTime,
    required this.reloadView,
  }) : super(key: key);

  final dbHelper = ShishaReserveDatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(message1st + message2nd),
      content: messageSub.isNotEmpty ? Text(messageSub) : null,
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
            if (isToday != 2) {
              addReserveTime!(isToday, message1st);
            }
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

class DeleteShishaTimeDialog extends StatelessWidget {
  final String message;
  final String time;
  final Function? deleteTime;

  DeleteShishaTimeDialog({
    Key? key,
    required,
    required this.message,
    required this.deleteTime,
    required this.time,
  }) : super(key: key);

  final dbHelper = ShishaReserveDatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(message),
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
            deleteTime!(time);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('予約をキャンセルしました'),
              ),
            );
          },
        )
      ],
    );
  }
}

bool canReserveTime(String readTime) {
  final now = DateTime.now();

  if (now.hour < int.parse(readTime.substring(0, 2))) {
    return true;
  } else if (now.hour == int.parse(readTime.substring(0, 2)) &&
      now.minute < int.parse(readTime.substring(3, 5))) {
    return true;
  } else {
    return false;
  }
}
