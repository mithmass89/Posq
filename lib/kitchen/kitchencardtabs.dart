import 'package:flutter/material.dart';
import 'package:posq/kitchen/carddetailtab.dart';


class KitchenCardTabs extends StatefulWidget {
  final String keys;
  final Color color;
  final List<Map<String, dynamic>> datax;
  final Function notif;
  const KitchenCardTabs(
      {super.key,
      required this.keys,
      required this.datax,
      required this.color,
      required this.notif});

  @override
  State<KitchenCardTabs> createState() => _KitchenCardTabsState();
}

class _KitchenCardTabsState extends State<KitchenCardTabs> {
  List<String> doneitem = [];
  DateTime? timestamp;
  String? times;
  int valueTime = 0;

  String timeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    print(difference.inMinutes);

    if (difference.inDays >= 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays >= 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays >= 7) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }

  int timesInt(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    print(difference.inMinutes);
    if (difference.inDays >= 365) {
      return (difference.inDays / 365).floor();
    } else if (difference.inDays >= 30) {
      return (difference.inDays / 30).floor();
    } else if (difference.inDays >= 7) {
      return (difference.inDays / 7).floor();
    } else if (difference.inDays >= 1) {
      return difference.inDays;
    } else if (difference.inHours >= 1) {
      return difference.inHours;
    } else if (difference.inMinutes >= 1) {
      return difference.inMinutes;
    } else {
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    timestamp = DateTime.parse(widget.datax.first['createdt']);
    times = timeAgo(
        timestamp!); // 'just now' (or a different value depending on the actual time difference)
    valueTime = timesInt(timestamp!);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.color,
      child: Column(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.05,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'nomer transaksi : ${widget.keys}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.height * 0.03),
                ),
              )),
          Container(
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.05,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'nomer table : ${widget.datax.first['tables_id']}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.height * 0.03),
                ),
              )),
          Container(
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "order time : $times",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.height * 0.03,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Divider(
            thickness: MediaQuery.of(context).size.height * 0.01,
            color: Colors.white,
          ),
          CardDetailtabs(
            keys: widget.keys,
            color: widget.color,
            datax: widget.datax,
            notif: widget.notif,
          )
        ],
      ),
    );
  }
}
