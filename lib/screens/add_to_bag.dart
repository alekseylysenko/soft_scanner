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

   void deleteEquipment(Equipment equipment) {
    // final box = Boxes.getTransactions();
    // box.delete(transaction.key);

 equipment.delete();
    //setState(() => transactions.remove(transaction));
  }
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
                  return Container(
                    padding: EdgeInsets.only(right: 10, left: 10, top: 5),
                    child: Card(
                      child: ListTile(
                        title: (Text(equipmentSingle.name + "\n" + equipmentSingle.dateReceiving!.day.toString() + "-" + equipmentSingle.dateReceiving!.month.toString() + "-" + equipmentSingle.dateReceiving!.year.toString(), style: TextStyle(fontSize: 14),) ),               
                        leading:  Text(equipmentSingle.code, style: TextStyle(fontSize: 10)),
                        trailing:  TextButton.icon(
                            label: Text('Удалить'),
                            icon: Icon(Icons.delete, size: 24,),
                            onPressed: () => deleteEquipment(equipmentSingle),)
                      ),
                    ),
                  );
                },
              );
            },
          )
    );
  }
}
