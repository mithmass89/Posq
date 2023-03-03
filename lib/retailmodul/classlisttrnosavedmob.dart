import 'package:flutter/material.dart';
import 'package:posq/classui/classformat.dart';
import 'package:posq/databasehandler.dart';
import 'package:posq/model.dart';
import 'package:posq/retailmodul/classdetailsavedmobile.dart';

class ClassListSavedMobile extends StatefulWidget {
  final Outlet outletinfo;
  final String pscd;
  final String? trno;
  final IafjrndtClass? datatransaksi;

  const ClassListSavedMobile({
    Key? key,
    required this.outletinfo,
    required this.pscd,
    this.trno,
    this.datatransaksi,
  }) : super(key: key);

  @override
  State<ClassListSavedMobile> createState() => _ClassListSavedMobileState();
}

class _ClassListSavedMobileState extends State<ClassListSavedMobile> {
  DateTime? timestamp;
  String? times;

  @override
  void initState() {
    super.initState();
    timestamp = DateTime.parse(widget.datatransaksi!.createdt!);
    times = timeAgo(
        timestamp!); // 'just now' (or a different value depending on the actual time difference)
  }

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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailSavedTransaction(
                    outletinfo: widget.outletinfo,
                    pscd: widget.outletinfo.outletcd,
                    status: 'Pending',
                    trno: widget.trno!,
                  )),
        );
      },
      leading: CircleAvatar(
        child: Text(widget.datatransaksi!.guestname!.substring(0, 1)),
      ),
      title: Text(widget.datatransaksi!.guestname == null
          ? 'No Guest'
          : widget.datatransaksi!.guestname!),
      subtitle: Text(widget.datatransaksi!.transno!),
      // subtitle: Text(widget.datatransaksi!.time!),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              '${CurrencyFormat.convertToIdr(widget.datatransaksi!.totalaftdisc, 0)}'),
          Text(times!),
        ],
      ),
    );
  }
}
