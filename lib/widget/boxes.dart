import 'package:hive/hive.dart';
import 'package:soft_scanner/models/equipment.dart';

class Boxes {

  static Box<Equipment> getEquipment() => Hive.box<Equipment>('equipment');

  
}
