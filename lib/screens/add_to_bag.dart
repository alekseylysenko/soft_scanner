import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:soft_scanner/models/equipment.dart';
import 'package:soft_scanner/widget/boxes.dart';

class AddToBagScreen extends StatefulWidget {
  const AddToBagScreen({Key? key}) : super(key: key);

  @override
  _AddToBagScreenState createState() => _AddToBagScreenState();
}

class _AddToBagScreenState extends State<AddToBagScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: 
    
          ValueListenableBuilder<Box<Equipment>>(
            valueListenable: Boxes.getEquipment().listenable(),
            builder: (context, box, _) {
              final equipment = box.values.toList().cast<Equipment>();

              return ListView.builder(
                itemCount: equipment.length,
                itemBuilder: (context, index) {
                  final equipmentSingle = equipment[index];
                  return ListTile(
                    title: Text(equipmentSingle.name),
                    subtitle: Text(equipmentSingle.code),
                    leading: Text(equipmentSingle.dateReceiving!.day.toString() + "-" + equipmentSingle.dateReceiving!.month.toString() + "-" + equipmentSingle.dateReceiving!.year.toString()),
                  );
                },
              );
            },
          )
    );
  }
}
