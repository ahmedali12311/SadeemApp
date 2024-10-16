import 'package:stacked/stacked.dart';
import '../../../services/orderserivce.dart';
import '../../../models/order.dart';

class OrderViewModel extends BaseViewModel {
  final OrderService _orderService = OrderService();

  List<OrderDetails> vendorOrders = [];
  bool isVendor = false;
  String vendorid = "";
  Future<void> fetchOrders() async {
    setBusy(true);
    try {
      isVendor = true;
      vendorOrders = await _orderService.getVendorOrders(vendorid);
    } catch (e) {
      // Handle errors
      print('Error fetching orders: $e');
    }
    setBusy(false);
  }
}
