// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_local_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserLocalDataAdapter extends TypeAdapter<UserLocalData> {
  @override
  final int typeId = 0;

  @override
  UserLocalData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserLocalData(
      id: fields[0] as String?,
      email: fields[1] as String?,
      name: fields[2] as String?,
      userLogged: fields[3] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, UserLocalData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.userLogged);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserLocalDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserBalanceLocalDataAdapter extends TypeAdapter<UserBalanceLocalData> {
  @override
  final int typeId = 1;

  @override
  UserBalanceLocalData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserBalanceLocalData(
      userTotalAmount: fields[0] as double?,
      userExpenseAmount: fields[2] as double?,
      userIncomeAmount: fields[1] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, UserBalanceLocalData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.userTotalAmount)
      ..writeByte(1)
      ..write(obj.userIncomeAmount)
      ..writeByte(2)
      ..write(obj.userExpenseAmount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserBalanceLocalDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CurrencyLocalDataAdapter extends TypeAdapter<CurrencyLocalData> {
  @override
  final int typeId = 2;

  @override
  CurrencyLocalData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrencyLocalData(
      code: fields[0] as String,
      symbol: fields[1] as String,
      name: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CurrencyLocalData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.symbol)
      ..writeByte(2)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyLocalDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
