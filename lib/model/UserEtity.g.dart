// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserEtity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserEtityAdapter extends TypeAdapter<UserEtity> {
  @override
  final int typeId = 2;

  @override
  UserEtity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserEtity()
      ..Sn_id = fields[0] as String
      ..Sn_displayName = fields[1] as String
      ..Sn_userName = fields[2] as String?
      ..Sn_photoUrl = fields[3] as dynamic
      ..Sn_Type = fields[4] as String?;
  }

  @override
  void write(BinaryWriter writer, UserEtity obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.Sn_id)
      ..writeByte(1)
      ..write(obj.Sn_displayName)
      ..writeByte(2)
      ..write(obj.Sn_userName)
      ..writeByte(3)
      ..write(obj.Sn_photoUrl)
      ..writeByte(4)
      ..write(obj.Sn_Type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEtityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
