import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:soft_scanner/models/equipment.dart';
import 'package:soft_scanner/screens/history_screen.dart';
import 'package:soft_scanner/widget/boxes.dart';

class BagScreen extends StatefulWidget {
  const BagScreen({Key? key}) : super(key: key);

  @override
  _BagScreenState createState() => _BagScreenState();
}

class _BagScreenState extends State<BagScreen> {
  final numberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void editEquipment(Equipment equipment, int applicationNumber) {
    // Рекдактирование Оборудования

    equipment.applicationNumber = applicationNumber;
    equipment.dateInstallation = DateTime.now();
    equipment.deleteEquipment = true;

    final box = Boxes.getEquipment();
    box.put(equipment.key, equipment);

    equipment.save();
  }

  void _showSimpleDialog(equipmentSingle) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Укажите номер заяки где установили оборудование'),
          content: Column(
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                    autofocus: true,
                    controller: numberController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Поле обязатьльное';
                      }
                    },
                    decoration:
                        InputDecoration(helperText: "Введите номер заяки")),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
                child: Text('Установить'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    editEquipment(
                        equipmentSingle, int.parse(numberController.text));
                    Navigator.of(context).pop();
                    final snackBar = SnackBar(
                      content: Text('Yay! A SnackBar!'),
                      action: SnackBarAction(
                        label: 'Назад',
                        onPressed: () {},
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Мой рюкзак"),
         
        ),
        body: ValueListenableBuilder<Box<Equipment>>(
          valueListenable: Boxes.getEquipment().listenable(),
          builder: (context, box, _) {
            final equipment = box.values.toList().cast<Equipment>();

            return ListView.builder(
                itemCount: equipment.length,
                itemBuilder: (context, index) {
                  final equipmentSingle = equipment[index];
                  if (equipmentSingle.deleteEquipment == false) {
                    return Container(
                      padding: EdgeInsets.only(right: 10, left: 10, top: 5),
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
                                      child: Text("S/N:"))),
                              Expanded(
                                  flex: 5,
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          left: 10, top: 5, bottom: 5),
                                      child:
                                          SelectableText(equipmentSingle.code)))
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
                                      padding:
                                          EdgeInsets.only(left: 10, bottom: 5),
                                      child: Text('Наименование:'))),
                              Expanded(
                                  flex: 5,
                                  child: Container(
                                      padding:
                                          EdgeInsets.only(left: 10, bottom: 5),
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
                                      padding:
                                          EdgeInsets.only(left: 10, bottom: 5),
                                      child: Text('Дата получения:'))),
                              Expanded(
                                  flex: 5,
                                  child: Container(
                                      padding:
                                          EdgeInsets.only(left: 10, bottom: 5),
                                      child: Text(DateFormat("dd.MM.yyyy")
                                          .format(
                                              equipmentSingle.dateReceiving!))))
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
                                    child: Text("Установить"),
                                    onPressed: () {
                                      _showSimpleDialog(equipmentSingle);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                    );
                  }
                  return Container();
                });
          },
        ));
  }
}
