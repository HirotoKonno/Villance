import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:villance/sauna_reserve_database_helper.dart';
import 'package:villance/sauna_time.dart';

class SaunaReserveView extends StatefulWidget {
  const SaunaReserveView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SaunaReserveState();
  }
}

class _SaunaReserveState extends State<SaunaReserveView> {
  final dbHelper = SaunaReserveDatabaseHelper.instance;
  Future<List<ReservedSauna>>? saunaReservedData;

  Future<List<ReservedSauna>> _getReservedItems() async {
    return await dbHelper.getReservedTimes();
  }

  @override
  void initState() {
    super.initState();
    saunaReservedData = _getReservedItems();
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
            backgroundColor: Colors.orange,
            shape: const StadiumBorder(),
          ),
          onPressed: () {
            showDialog<void>(
                context: context,
                builder: (_) {
                  return StartSaunaDialog(
                    message1st: "今からサウナを開始しますか？",
                    message2nd: '',
                    messageSub: '※準備ができたらお呼びいたします',
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
                      for (var i = 0;
                          i < ReserveTimeList.canSaunaToday.length;
                          i++)
                        if (canReserveTime(ReserveTimeList.canSaunaToday[i]))
                          Center(
                            child: SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(context);
                                showDialog<void>(
                                    context: context,
                                    builder: (_) {
                                      return StartSaunaDialog(
                                        message1st:
                                            "${ReserveTimeList.canSaunaToday[i]}",
                                        message2nd: 'に予約しますか？',
                                        messageSub: '',
                                        isToday: 1,
                                        addReserveTime: _addReserveTime,
                                        reloadView: clearList,
                                      );
                                    });
                              },
                              child: Text(
                                  "           ${ReserveTimeList.canSaunaToday[i]}           "),
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
                      for (var i = 0;
                          i < ReserveTimeList.canSaunaTomorrow.length;
                          i++)
                        Center(
                          child: SimpleDialogOption(
                            onPressed: () {
                              Navigator.pop(context);
                              showDialog<void>(
                                  context: context,
                                  builder: (_) {
                                    return StartSaunaDialog(
                                      message1st:
                                          "${ReserveTimeList.canSaunaTomorrow[i]}",
                                      message2nd: 'に予約しますか？',
                                      messageSub: '',
                                      isToday: 0,
                                      addReserveTime: _addReserveTime,
                                      reloadView: clearList,
                                    );
                                  });
                            },
                            child: Text(
                                "           ${ReserveTimeList.canSaunaTomorrow[i]}           "),
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
        '※本日は21時までご利用できます',
        style: TextStyle(color: Colors.black),
      ),
      const SizedBox(height: 50),
      const Text(
        '予約履歴',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      FutureBuilder(
          future: saunaReservedData,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<ReservedSauna> data = snapshot.data;
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
                                          return DeleteTimeDialog(
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
    saunaReservedData = _getReservedItems();
    setState(() {});
  }

  void _addReserveTime(int isToday, String time) async {
    Map<String, dynamic> row = {
      SaunaReserveDatabaseHelper.isToday: isToday,
      SaunaReserveDatabaseHelper.hourMinutesString: time,
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

class StartSaunaDialog extends StatelessWidget {
  final String message1st;
  final String message2nd;
  final String messageSub;
  final int isToday;
  final Function? addReserveTime;
  final Function? reloadView;

  StartSaunaDialog({
    Key? key,
    required,
    required this.message1st,
    required this.message2nd,
    required this.messageSub,
    required this.isToday,
    required this.addReserveTime,
    required this.reloadView,
  }) : super(key: key);

  final dbHelper = SaunaReserveDatabaseHelper.instance;

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

class DeleteTimeDialog extends StatelessWidget {
  final String message;
  final String time;
  final Function? deleteTime;

  DeleteTimeDialog({
    Key? key,
    required,
    required this.message,
    required this.deleteTime,
    required this.time,
  }) : super(key: key);

  final dbHelper = SaunaReserveDatabaseHelper.instance;

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
