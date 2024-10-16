import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:stacked/stacked.dart';
import 'package:vendors/ui/views/orders/orderviewmodel.dart';
import 'package:vendors/ui/views/cart/CartView.dart';
import 'package:vendors/ui/views/Profile/ProfileView.dart';
import 'package:vendors/ui/views/vendor/VendorView.dart';

class UserOrderView extends StatefulWidget {
  @override
  _UserOrderViewState createState() => _UserOrderViewState();
}

class _UserOrderViewState extends State<UserOrderView> {
  int _selectedIndex = 3; // Assuming Orders is the fourth item
  void _onTabSelected(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => VendorView(),
          transitionDuration: Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ).then((_) {
        setState(() {
          _selectedIndex = 0;
        });
      });
    } else if (index == 1) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ProfileView(),
          transitionDuration: Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ).then((_) {
        setState(() {
          _selectedIndex = 0;
        });
      });
    } else if (index == 2) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => CartView(),
          transitionDuration: Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ).then((_) {
        setState(() {
          _selectedIndex = 0;
        });
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text("🚀 Your Orders"),
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      body: ViewModelBuilder<OrderViewModel>.reactive(
        viewModelBuilder: () => OrderViewModel(),
        onModelReady: (model) => model.fetchOrders(),
        builder: (context, model, child) {
          if (model.isBusy) {
            return Center(child: CircularProgressIndicator());
          }

          if (model.userOrders.isEmpty) {
            return Center(
              child: Text(
                '😔 No Orders Found',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: model.userOrders.length,
            itemBuilder: (context, index) {
              final order = model.userOrders[index];
              return _buildOrderCard(order);
            },
          );
        },
      ),
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: _onTabSelected,
        backgroundColor: Theme.of(context).colorScheme.primary,
        items: [
          FlashyTabBarItem(
            icon: Icon(Icons.home,
                color: Theme.of(context).colorScheme.onPrimary),
            title: Text('Home',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.person,
                color: Theme.of(context).colorScheme.onPrimary),
            title: Text('Profile',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.shopping_cart,
                color: Theme.of(context).colorScheme.onPrimary),
            title: Text('Cart',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.list_alt,
                color: Theme.of(context).colorScheme.onPrimary),
            title: Text('Orders',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(order) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('🛍️ Vendor: ${order.vendorName}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Icon(Icons.local_offer_outlined,
                          color: Colors.pinkAccent, size: 30),
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(color: Colors.black38, thickness: 1),
                  SizedBox(height: 10),
                  Text(
                      '💵 Total Cost: \$${order.totalOrderCost.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.teal,
                          fontWeight: FontWeight.bold)),
                  Text(
                    '📦 Total Quantity: ${order.itemQuantities.reduce((int a, int b) => a + b)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text('🍔 Items:',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  ...order.itemNames.map((itemName) {
                    final index = order.itemNames.indexOf(itemName);
                    return ListTile(
                      title:
                          Text(itemName, style: TextStyle(color: Colors.black)),
                      subtitle: Text(
                          '💲 Price: \$${order.itemPrices[index]} | Quantity: ${order.itemQuantities[index]}',
                          style: TextStyle(color: Colors.black54)),
                      leading: Icon(Icons.fastfood_outlined,
                          color: Colors.lightBlueAccent),
                    );
                  }).toList(),
                  SizedBox(height: 10),
                  Text('📝 Description: ${order.description}',
                      style: TextStyle(fontSize: 14, color: Colors.black54)),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20)),
                        child: Text('🛠️ Status: ${order.status}',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 6,
            right: 20,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                    colors: [Colors.pinkAccent, Colors.blueAccent]),
                boxShadow: [
                  BoxShadow(
                      color: Colors.pinkAccent.withOpacity(0.6),
                      blurRadius: 15,
                      spreadRadius: 1),
                ],
              ),
              child: Icon(Icons.shopping_cart_outlined, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
