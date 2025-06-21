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
      fullFocusMode: fields[2] as bool,
      notificationEnabled: fields[3] as bool,
      keepScreenOn: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsState obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.pomodoroMinutes)
      ..writeByte(1)
      ..write(obj.breakMinutes)
      ..writeByte(2)
      ..write(obj.fullFocusMode)
      ..writeByte(3)
      ..write(obj.notificationEnabled)
      ..writeByte(4)
      ..write(obj.keepScreenOn);
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
