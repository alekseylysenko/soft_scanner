import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:soft_scanner/models/equipment.dart';
import 'package:soft_scanner/widget/boxes.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  void deleteEquipment(Equipment equipment) {
    // final box = Boxes.getTransactions();
    // box.delete(transaction.key);

    equipment.delete();
    //setState(() => transactions.remove(transaction));
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("История перемещений"),
        ),
        body: 
        
         ValueListenableBuilder<Box<Equipment>>(
            valueListenable: Boxes.getEquipment().listenable(),
            builder: (context, box, _) {
              final equipment = box.values.toList().cast<Equipment>();           
              return ListView.builder(
                  itemCount: equipment.length,
                  itemBuilder: (context, index) {
                    final equipmentSingle = equipment[index];

                    return equipmentSingle.deleteEquipment == true
                        ? Container(
                            padding:
                                EdgeInsets.only(right: 10, left: 10, top: 5),
                            child: Card(
                                color: Colors.grey[100],
                                child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 5,
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 10, top: 5, bottom: 5),
                                          child: Text("№ заявки"),
                                        )),
                                    Expanded(
                                        flex: 5,
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                left: 10, top: 5, bottom: 5),
                                            child: SelectableText(
                                                equipmentSingle
                                                    .applicationNumber
                                                    .toString())))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 5,
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                left: 10, top: 5, bottom: 5),
                                            child: Text("S/N:"))),
                                    Expanded(
                                        flex: 5,
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                left: 10, top: 5, bottom: 5),
                                            child: SelectableText(
                                                equipmentSingle.code)))
                                  ],
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 5,
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                left: 10, bottom: 5),
                                            child: Text('Наименование:'))),
                                    Expanded(
                                        flex: 5,
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                left: 10, bottom: 5),
                                            child: Text(equipmentSingle.name)))
                                  ],
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 5,
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                left: 10, bottom: 5),
                                            child: Text('Дата получения:'))),
                                    Expanded(
                                        flex: 5,
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                left: 10, bottom: 5),
                                            child: Text(
                                                DateFormat("H:m dd.MM.yyyy")
                                                    .format(equipmentSingle
                                                        .dateReceiving!)))),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 5,
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                left: 10, bottom: 5),
                                            child: Text('Дата установки:'))),
                                    Expanded(
                                        flex: 5,
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                left: 10, bottom: 5),
                                            child: Text(
                                                DateFormat("H:m dd.MM.yyyy")
                                                    .format(equipmentSingle
                                                        .dateInstallation!)))),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: Container(),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                        child: TextButton(
                                          child: Text("Удалить"),
                                          onPressed: () {
                                            deleteEquipment(equipmentSingle);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )),
                          )
                        : Container();
                  });
            }));
  }
}
