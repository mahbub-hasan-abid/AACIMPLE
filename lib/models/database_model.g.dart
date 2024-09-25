// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DatabaseModelAdapter extends TypeAdapter<DatabaseModel> {
  @override
  final int typeId = 0;

  @override
  DatabaseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DatabaseModel(
      keyfieldCode: fields[0] as String,
      messageText: fields[1] as String,
      messageImage: fields[2] as String,
      messageSound: fields[3] as String,
      language: fields[4] as Language,
      isPictureVisible: fields[5] as bool,
      isTextVisible: fields[6] as bool,
      isSoundEnabled: fields[7] as bool,
      fontSize: fields[8] as int,
      fontColor: fields[9] as String,
      backgroundColor: fields[10] as String,
      fromWhere: fields[11] as FromWhere,
    );
  }

  @override
  void write(BinaryWriter writer, DatabaseModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.keyfieldCode)
      ..writeByte(1)
      ..write(obj.messageText)
      ..writeByte(2)
      ..write(obj.messageImage)
      ..writeByte(3)
      ..write(obj.messageSound)
      ..writeByte(4)
      ..write(obj.language)
      ..writeByte(5)
      ..write(obj.isPictureVisible)
      ..writeByte(6)
      ..write(obj.isTextVisible)
      ..writeByte(7)
      ..write(obj.isSoundEnabled)
      ..writeByte(8)
      ..write(obj.fontSize)
      ..writeByte(9)
      ..write(obj.fontColor)
      ..writeByte(10)
      ..write(obj.backgroundColor)
      ..writeByte(11)
      ..write(obj.fromWhere);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DatabaseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FromWhereAdapter extends TypeAdapter<FromWhere> {
  @override
  final int typeId = 2;

  @override
  FromWhere read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FromWhere.assets;
      case 1:
        return FromWhere.user;
      default:
        return FromWhere.assets;
    }
  }

  @override
  void write(BinaryWriter writer, FromWhere obj) {
    switch (obj) {
      case FromWhere.assets:
        writer.writeByte(0);
        break;
      case FromWhere.user:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FromWhereAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LanguageAdapter extends TypeAdapter<Language> {
  @override
  final int typeId = 1;

  @override
  Language read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Language.English;
      case 1:
        return Language.Greek;
      case 2:
        return Language.Italian;
      default:
        return Language.English;
    }
  }

  @override
  void write(BinaryWriter writer, Language obj) {
    switch (obj) {
      case Language.English:
        writer.writeByte(0);
        break;
      case Language.Greek:
        writer.writeByte(1);
        break;
      case Language.Italian:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanguageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
