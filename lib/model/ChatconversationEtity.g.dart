// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChatconversationEtity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatconversationEtityAdapter extends TypeAdapter<ChatconversationEtity> {
  @override
  final int typeId = 0;

  @override
  ChatconversationEtity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatconversationEtity()
      ..id = fields[0] as String
      ..status = fields[1] as int
      ..title = fields[2] as String
      ..suggestName = fields[3]==null?"": fields[3] as String;
  }

  @override
  void write(BinaryWriter writer, ChatconversationEtity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.suggestName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatconversationEtityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
