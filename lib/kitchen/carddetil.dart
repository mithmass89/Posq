import 'package:flutter/material.dart';

class CardDetail extends StatefulWidget {
  final String keys;
  final Color color;
  final List<Map<String, dynamic>> datax;
  final Function notif;
  const CardDetail(
      {super.key,
      required this.color,
      required this.datax,
      required this.notif,
      required this.keys});

  @override
  State<CardDetail> createState() => _CardDetailState();
}

class _CardDetailState extends State<CardDetail> {
  List<String> doneitem = [];
  DateTime? timestamp;
  String? times;
  int valueTime = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.08 * widget.datax.length,
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.datax.length,
            itemBuilder: (context, indexx) {
              return ListTile(
                  onTap: () async {
                    if (doneitem.contains(widget.datax[indexx]['itemdesc']) ==
                        true) {
                      doneitem.removeWhere((element) =>
                          element == widget.datax[indexx]['itemdesc']);
                    } else {
                      doneitem.add(widget.datax[indexx]['itemdesc']);
                    }
                    ;
                    if ((doneitem.length == widget.datax.length) == true) {
                      doneitem=[];
                      print(doneitem.length);
                      print(
                          "ini doneitem length : ${doneitem.length} ini widget.data ${widget.datax.length}");
                      await widget.notif(widget.keys);
                    } else {}
                    ;

                    setState(() {});
                  },
                  dense: true,
                  title: Text(
                    widget.datax[indexx]['itemdesc'],
                    style: TextStyle(
                        decoration:
                            doneitem.contains(widget.datax[indexx]['itemdesc'])
                                ? TextDecoration.lineThrough
                                : null,
                        decorationColor:
                            Colors.red, // Optional: You can set the line color
                        decorationThickness:
                            2.0, // Optional: You can set the line thickness
                        // Optional: You can set the font size,
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.06),
                  ),
                  subtitle: Text(
                    widget.datax[indexx]['condiment'] == null
                        ? ''
                        : 'Condiment : ${widget.datax[indexx]['condiment']}',
                    style: TextStyle(
                        decoration:
                            doneitem.contains(widget.datax[indexx]['itemdesc'])
                                ? TextDecoration.lineThrough
                                : null,
                        decorationColor:
                            Colors.red, // Optional: You can set the line color
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.04),
                  ),
                  trailing: Text(
                    widget.datax[indexx]['qty'].toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.04),
                  ));
            }));
  }
}
