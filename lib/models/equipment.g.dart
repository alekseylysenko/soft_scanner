// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EquipmentAdapter extends TypeAdapter<Equipment> {
  @override
  final int typeId = 0;

  @override
  Equipment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Equipment()
      ..name = fields[0] as String
      ..code = fields[1] as String
      ..applicationNumber = fields[2] as int
      ..dateReceiving = fields[3] as DateTime?
      ..dateInstallation = fields[4] as DateTime?
      ..deleteEquipment = fields[5] as bool;
  }

  @override
  void write(BinaryWriter writer, Equipment obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.applicationNumber)
      ..writeByte(3)
      ..write(obj.dateReceiving)
      ..writeByte(4)
      ..write(obj.dateInstallation)
      ..writeByte(5)
      ..write(obj.deleteEquipment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EquipmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
