import 'package:vendors/ui/views/vendorDetails/VendorDetailsModel.dart';
import 'package:flutter/material.dart';

class ItemsGrid extends StatefulWidget {
  final VendorDetailsViewModel viewModel;
  final BuildContext scaffoldContext; // Add this field

  const ItemsGrid({required this.viewModel, required this.scaffoldContext});

  @override
  _ItemsGridState createState() => _ItemsGridState();
}

class _ItemsGridState extends State<ItemsGrid> {
  Map<int, int> _quantities = {};

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 3 / 4,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = widget.viewModel.filteredItems?[index];
          final hasDiscount = item?.discount != null && item!.discount! > 0;
          int quantity = _quantities[index] ?? 0;

          return Card(
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        item?.imageUrl ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/vendor.jpg',
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    item?.name ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  if (hasDiscount) ...[
                    Text(
                      '\$${item?.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                  Text(
                    '\$${hasDiscount ? item?.discount.toStringAsFixed(2) : item?.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: hasDiscount ? Colors.red : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  if (item?.quantity != null && item!.quantity > 0)
                    Text(
                      'Total Quantity: ${item.quantity}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  item?.quantity == 0
                      ? Center(
                          child: Text(
                            'Out of Stock',
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: quantity > 0
                                      ? () {
                                          setState(() {
                                            _quantities[index] = --quantity;
                                          });
                                        }
                                      : null, // Disable if quantity is 0
                                ),
                                Text(
                                  '$quantity', // Show the current quantity
                                  style: TextStyle(fontSize: 18),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      _quantities[index] = ++quantity;
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () async {
                                if (item != null && quantity > 0) {
                                  final resultMessage = await widget.viewModel
                                      .addItemToCart(item!, quantity);
                                  final isSuccess = resultMessage ==
                                      'Added to cart successfully!';
                                  Future.delayed(Duration(milliseconds: 100),
                                      () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          resultMessage ??
                                              'Something went wrong!',
                                          style: TextStyle(
                                            color: Colors
                                                .white, // Ensure text color
                                          ),
                                        ),
                                        backgroundColor: isSuccess
                                            ? Colors.green
                                            : Colors
                                                .red, // Explicitly set the background color
                                        duration: Duration(seconds: 2),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Please select a quantity greater than 0.',
                                        style: TextStyle(
                                          color: Colors.white, // Text color
                                          fontSize: 16,
                                        ),
                                      ),
                                      backgroundColor: Colors
                                          .red, // Ensure background color is red for errors
                                      duration: Duration(seconds: 2),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              },
                              child: Center(
                                child: Text('Add to Cart'),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          );
        },
        childCount: widget.viewModel.filteredItems?.length ?? 0,
      ),
    );
  }
}
