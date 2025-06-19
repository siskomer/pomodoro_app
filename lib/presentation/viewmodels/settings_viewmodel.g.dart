// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_viewmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsStateAdapter extends TypeAdapter<SettingsState> {
  @override
  final int typeId = 1;

  @override
  SettingsState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsState(
      pomodoroMinutes: fields[0] as int,
      breakMinutes: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsState obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.pomodoroMinutes)
      ..writeByte(1)
      ..write(obj.breakMinutes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
