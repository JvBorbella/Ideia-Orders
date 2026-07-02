import 'package:hive/hive.dart';

part 'order_model.g.dart';

@HiveType(typeId: 0)
@HiveType(typeId: 0)
class OrderModel extends HiveObject {

  @HiveField(0)
  String localId;

  @HiveField(1)
  String? prevendaId;

  @HiveField(2)
  int numero;

  @HiveField(3)
  String nomepessoa;

  @HiveField(4)
  double valortotal;

  @HiveField(5)
  int flagSync;

  @HiveField(6)
  String datahora;

  @HiveField(7)
  String? flagpermitefaturar;

  @HiveField(8)
  String? operador;

  @HiveField(9)
  String? vendedorId;

  @HiveField(10)
  double? valordesconto;

  @HiveField(11)
  String? empresaId;

  OrderModel({
    required this.localId,
    this.prevendaId,
    required this.numero,
    required this.nomepessoa,
    required this.valortotal,
    required this.flagSync,
    required this.datahora,
    this.flagpermitefaturar,
    this.operador,
    this.vendedorId,
    this.valordesconto,
    this.empresaId,
  });
}

