// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderModelAdapter extends TypeAdapter<OrderModel> {
  @override
  final int typeId = 0;

  @override
  OrderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderModel(
      localId: fields[0] as String,
      prevendaId: fields[1] as String?,
      numero: fields[2] as int,
      nomepessoa: fields[3] as String,
      valortotal: fields[4] as double,
      flagSync: fields[5] as int,
      datahora: fields[6] as String,
      flagpermitefaturar: fields[7] as String?,
      operador: fields[8] as String?,
      vendedorId: fields[9] as String?,
      valordesconto: fields[10] as double?,
      empresaId: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OrderModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.localId)
      ..writeByte(1)
      ..write(obj.prevendaId)
      ..writeByte(2)
      ..write(obj.numero)
      ..writeByte(3)
      ..write(obj.nomepessoa)
      ..writeByte(4)
      ..write(obj.valortotal)
      ..writeByte(5)
      ..write(obj.flagSync)
      ..writeByte(6)
      ..write(obj.datahora)
      ..writeByte(7)
      ..write(obj.flagpermitefaturar)
      ..writeByte(8)
      ..write(obj.operador)
      ..writeByte(9)
      ..write(obj.vendedorId)
      ..writeByte(10)
      ..write(obj.valordesconto)
      ..writeByte(11)
      ..write(obj.empresaId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
