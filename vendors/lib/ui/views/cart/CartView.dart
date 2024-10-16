import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:vendors/services/cartService.dart';
import 'package:vendors/ui/views/cart/cartModel.dart';
import 'package:vendors/ui/views/orders/userorderview.dart';
import 'package:vendors/ui/views/profile/ProfileView.dart';
import 'package:vendors/ui/views/vendor/VendorView.dart';

class CartView extends StatefulWidget {
  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final TextEditingController _descriptionController = TextEditingController();
  String? _initialDescription;
  bool _hasChanges = false;
  late int _selectedIndex = 2;

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
    } else if (index == 3) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              UserOrderView(),
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CartViewModel>.reactive(
      viewModelBuilder: () => CartViewModel(CartService()),
      onModelReady: (model) {
        model.fetchCart();
        _initialDescription = model.description ?? '';
        _descriptionController.text = _initialDescription!;

        _descriptionController.addListener(() {
          setState(() {
            final currentDescription = _descriptionController.text;
            _hasChanges = currentDescription != _initialDescription &&
                currentDescription.isNotEmpty;
            model.updateTemporaryDescription(currentDescription);
          });
        });
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: Text(
              'Your Cart',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: model.isBusy
                ? Center(child: CircularProgressIndicator())
                : model.cartItems.isEmpty
                    ? Center(
                        child: Text(
                          'No items in the cart.',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16.0),
                              itemCount: model.cartItems.length,
                              itemBuilder: (context, index) {
                                final cart = model.cartItems[index];

                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  elevation: 10,
                                  shadowColor: Colors.black26,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Vendor: ${cart.vendorName}',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 12.0),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount:
                                              model.cartItemDetails.length,
                                          itemBuilder: (context, itemIndex) {
                                            final cartItem = model
                                                .cartItemDetails[itemIndex];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 100,
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey.shade300),
                                                      image: DecorationImage(
                                                        image: cartItem.img !=
                                                                    null &&
                                                                cartItem.img!
                                                                    .isNotEmpty
                                                            ? NetworkImage(
                                                                cartItem.img!)
                                                            : AssetImage(
                                                                    'assets/vendor.jpg')
                                                                as ImageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 16.0),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          cartItem.name,
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black87,
                                                          ),
                                                        ),
                                                        SizedBox(height: 8.0),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            cartItem.discount !=
                                                                        null &&
                                                                    cartItem.discount! >
                                                                        0
                                                                ? Text(
                                                                    'Discounted Price: \$${(cartItem.discount!).toStringAsFixed(2)}',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .redAccent,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  )
                                                                : Text(
                                                                    'Price: \$${cartItem.price.toStringAsFixed(2)}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Colors
                                                                            .black87),
                                                                  ),
                                                            Row(
                                                              children: [
                                                                IconButton(
                                                                  icon: Icon(
                                                                      Icons
                                                                          .remove,
                                                                      color: Colors
                                                                          .blueAccent),
                                                                  onPressed:
                                                                      () {
                                                                    if (cartItem
                                                                            .quantity >
                                                                        1) {
                                                                      // Check if quantity is greater than 1
                                                                      model.updateQuantity(
                                                                          cartItem,
                                                                          -1);
                                                                      setState(
                                                                          () {
                                                                        _hasChanges =
                                                                            true; // Mark changes as made
                                                                      });
                                                                    }
                                                                  },
                                                                ),
                                                                Text(
                                                                    '${cartItem.quantity}'),
                                                                IconButton(
                                                                  icon: Icon(
                                                                      Icons.add,
                                                                      color: Colors
                                                                          .blueAccent),
                                                                  onPressed:
                                                                      () {
                                                                    if (cartItem
                                                                            .quantity <
                                                                        cartItem
                                                                            .totalquantity) {
                                                                      model.updateQuantity(
                                                                          cartItem,
                                                                          1);
                                                                      setState(
                                                                          () {
                                                                        _hasChanges =
                                                                            true; // Mark changes as made
                                                                      });
                                                                    }
                                                                  },
                                                                ),
                                                                IconButton(
                                                                  icon: Icon(
                                                                      Icons
                                                                          .delete,
                                                                      color: Colors
                                                                          .red),
                                                                  onPressed:
                                                                      () async {
                                                                    await model
                                                                        .deleteCartItem(
                                                                            cartItem);
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        SizedBox(height: 20.0),
                                        Divider(),
                                        SizedBox(height: 8.0),
                                        Text(
                                          'Total Price: \$${model.totalPrice.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          'Total Quantity: ${model.totalQuantity}',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          model.description?.isNotEmpty == true
                                              ? 'Note: ${model.description}'
                                              : 'No description',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: TextField(
                                  controller: _descriptionController,
                                  decoration: InputDecoration(
                                    labelText: 'Description',
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: Colors.teal, width: 2),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 16.0, horizontal: 16.0),
                                    filled: true,
                                    fillColor: Colors.teal.shade50,
                                  ),
                                  maxLines: 3,
                                ),
                              ),
                              SizedBox(height: 16), // Add some spacing
                              if (_hasChanges)
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await model.saveChanges();
                                        setState(() {
                                          _initialDescription =
                                              _descriptionController.text;
                                          _hasChanges =
                                              false; // Reset changes state
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        backgroundColor: Colors.blueAccent,
                                        foregroundColor: Colors.white,
                                        elevation: 5,
                                      ),
                                      child: Text(
                                        'Save Changes',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  // Show a loading indicator or disable the button while busy
                                  if (!model.isBusy) {
                                    await model
                                        .checkout(); // Call the checkout method
                                    if (model.errorMessage != null) {
                                      // Optionally, show an error message
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(model.errorMessage!)),
                                      );
                                    } else {
                                      // Optionally, navigate to a success screen or clear the cart
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('Checkout successful!')),
                                      );
                                      // Clear cart items or navigate to another screen as needed
                                      model.fetchCart(); // Refresh cart items
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  elevation: 5,
                                ),
                                child: Text(
                                  'Checkout',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary)),
              ),
              FlashyTabBarItem(
                icon: Icon(Icons.person,
                    color: Theme.of(context).colorScheme.onPrimary),
                title: Text('Profile',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary)),
              ),
              FlashyTabBarItem(
                icon: Icon(Icons.shopping_cart,
                    color: Theme.of(context).colorScheme.onPrimary),
                title: Text('Cart',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary)),
              ),
              FlashyTabBarItem(
                icon: Icon(Icons.list_alt,
                    color: Theme.of(context).colorScheme.onPrimary),
                title: Text('Orders',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary)),
              ),
            ],
          ),
        );
      },
    );
  }
}
