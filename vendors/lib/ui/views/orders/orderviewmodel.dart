import 'package:stacked/stacked.dart';
import '../../../services/orderserivce.dart';
import '../../../models/order.dart';

class OrderViewModel extends BaseViewModel {
  final OrderService _orderService = OrderService();

  List<OrderDetails> userOrders = [];
  List<OrderDetails> vendorOrders = [];
  bool isVendor = false;

  Future<void> fetchOrders() async {
    setBusy(true);
    try {
      isVendor = false;
      userOrders = await _orderService.getUserOrders();
    } catch (e) {
      // Handle errors
      print('Error fetching orders: $e');
    }
    setBusy(false);
  }
}
