import 'package:hive/hive.dart';

part 'equipment.g.dart';

@HiveType(typeId: 0)
class Equipment extends HiveObject{
  
  @HiveField(0)
  late final String name; // Наименование оборудования

  @HiveField(1)
  late final String code; // штрих-код

  @HiveField(2)
  late int applicationNumber; //Номер заявки

  @HiveField(3)
  DateTime? dateReceiving; //Дата получения оборудования

  @HiveField(4)
  DateTime? dateInstallation; //Дата установки оборудования

  @HiveField(5)
  bool deleteEquipment = true; // В рюкзаке или нет

}
