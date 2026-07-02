import 'package:hive/hive.dart';
import 'order_model.dart';

class OrderLocalService {

  final Box<OrderModel> box = Hive.box<OrderModel>('orders');

  /// 🔹 Adicionar pedido offline
  Future<void> addOrder(OrderModel order) async {
    await box.add(order);
  }

  /// 🔹 Buscar todos pedidos
  List<OrderModel> getAllOrders() {
    return box.values.toList();
  }

  /// 🔹 Buscar apenas não sincronizados
  List<OrderModel> getUnsyncedOrders() {
    return box.values.where((o) => o.flagSync == 0).toList();
  }

  /// 🔹 Marcar como sincronizado
  Future<void> markAsSynced(OrderModel order, String pedidoId) async {
    order.flagSync = 1;
    order.prevendaId = pedidoId;
    await order.save();
  }

  /// 🔹 Substituir lista vinda do servidor
  Future<void> replaceFromServer(List<OrderModel> serverOrders) async {
    await box.clear();
    await box.addAll(serverOrders);
  }
}
