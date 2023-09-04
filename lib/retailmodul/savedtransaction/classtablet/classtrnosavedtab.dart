import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/savedtransaction/classtablet/classdetailsavedtab.dart';

class ClassListSavedTab extends StatefulWidget {
  final Outlet outletinfo;
  final String pscd;
  final String? trno;
  final IafjrndtClass? datatransaksi;
  final String? trnoopen;

  const ClassListSavedTab({
    Key? key,
    required this.outletinfo,
    required this.pscd,
    this.trno,
    this.datatransaksi,
    required this.trnoopen,
  }) : super(key: key);

  @override
  State<ClassListSavedTab> createState() => _ClassListSavedTabState();
}

class _ClassListSavedTabState extends State<ClassListSavedTab> {
  DateTime? timestamp;
  String? times;
  int valueTime = 0;

  @override
  void initState() {
    super.initState();
    if (widget.datatransaksi!.active == null) {
      print(widget.datatransaksi!.createdt!);
      timestamp = DateTime.parse(widget.datatransaksi!.createdt!);

      times = timeAgo(
          timestamp!); // 'just now' (or a different value depending on the actual time difference)
      // valueTime = timesInt(timestamp!);
      print('ini times :${timestamp}');
    }
  }

  String timeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    print('ini now ${now}');

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
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.trnoopen != widget.trno
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailSavedTransactionTab(
                          outletinfo: widget.outletinfo,
                          pscd: widget.outletinfo.outletcd,
                          status: 'Pending',
                          trno: widget.trno!,
                        )),
              );
            }
          : () async {
              await Fluttertoast.showToast(
                  msg: "Transaksi sudah teropen",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Color.fromARGB(255, 11, 12, 14),
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
      leading: CircleAvatar(
        child: Text(widget.datatransaksi!.guestname!.substring(0, 1)),
      ),
      title: Text(widget.datatransaksi!.guestname == null
          ? 'No Guest'
          : widget.datatransaksi!.guestname!),
      subtitle: Column(
        children: [
          Row(
            children: [
              Text(widget.datatransaksi!.transno!),
            ],
          ),
          Row(
            children: [
              Text(widget.datatransaksi!.tablesid!),
            ],
          ),
        ],
      ),
      // subtitle: Text(widget.datatransaksi!.time!),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerRight,
            width: MediaQuery.of(context).size.width * 0.3,
            child: Text(
                '${CurrencyFormat.convertToIdr(widget.datatransaksi!.totalaftdisc, 0)}'),
          ),
          Container(
            alignment: Alignment.centerRight,
            width: MediaQuery.of(context).size.width * 0.3,
            child: Text(
              times!,
              style:
                  TextStyle(color: valueTime >= 10 ? Colors.red : Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}
