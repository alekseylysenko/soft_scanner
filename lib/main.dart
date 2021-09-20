import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:soft_scanner/models/equipment.dart';
import 'package:soft_scanner/provider/barcode_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:soft_scanner/widget/bottom_navigation_bar.dart';


void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(EquipmentAdapter());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BarCodeProvider()),
      ],
      child: BottomNavigationBarBag(),
    ),
  );

  await Hive.openBox<Equipment>('equipment');
}