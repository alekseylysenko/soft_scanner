import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:soft_scanner/models/equipment.dart';

class MyBagScreen extends StatefulWidget {
  const MyBagScreen({Key? key}) : super(key: key);

  @override
  _MyBagScreenState createState() => _MyBagScreenState();
}

class _MyBagScreenState extends State<MyBagScreen> {
  
  @override
  Widget build(BuildContext context) {
    
    final equipmentBox = Hive.box('equipment');
    return Scaffold(
      appBar: AppBar(title: Text("fdf"),),
      body: FutureBuilder(
          future: Hive.openBox('equipment'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                  itemCount: equipmentBox.length,
                  itemBuilder: (BuildContext context, int index) {
                    final equipment = equipmentBox.get(index) as Equipment;
                    return ListTile(
                      title: Text(equipment.name),
                      subtitle: Text(equipment.code.toString()),
                    );
                  });
            } else
              return Center(child: CircularProgressIndicator());
          }),
    );
  }


}
