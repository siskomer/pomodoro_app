// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_viewmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PomodoroRecordAdapter extends TypeAdapter<PomodoroRecord> {
  @override
  final int typeId = 0;

  @override
  PomodoroRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PomodoroRecord(
      date: fields[0] as DateTime,
      focusMinutes: fields[1] as int,
      breakMinutes: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PomodoroRecord obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.focusMinutes)
      ..writeByte(2)
      ..write(obj.breakMinutes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PomodoroRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
