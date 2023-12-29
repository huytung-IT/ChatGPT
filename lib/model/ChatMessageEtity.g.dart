// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChatMessageEtity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatMessageEtityAdapter extends TypeAdapter<ChatMessageEtity> {
  @override
  final int typeId = 1;

  @override
  ChatMessageEtity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatMessageEtity()
      ..id = fields[0] as String
      ..from = fields[1] as String
      ..to = fields[2] as String
      ..msg = fields[3] as String
      ..timeSent = fields[4] as DateTime
      ..conversationId = fields[5] as String;
  }

  @override
  void write(BinaryWriter writer, ChatMessageEtity obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.from)
      ..writeByte(2)
      ..write(obj.to)
      ..writeByte(3)
      ..write(obj.msg)
      ..writeByte(4)
      ..write(obj.timeSent)
      ..writeByte(5)
      ..write(obj.conversationId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessageEtityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
