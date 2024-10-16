import 'package:stacked/stacked.dart';
import 'package:vendors/models/cart.dart';
import 'package:vendors/models/cartitems.dart';
import 'package:vendors/services/cartService.dart';

class CartViewModel extends BaseViewModel {
  final CartService _cartService;
  List<Cart> _cartItems = [];
  List<Cart> get cartItems => _cartItems;
  List<CartItem> _cartItemDetails = [];
  List<CartItem> get cartItemDetails => _cartItemDetails;

  bool _hasChanges = false;
  bool get hasChanges => _hasChanges;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  String? _temporaryDescription; // Temporary description for editing
  String? get temporaryDescription =>
      _temporaryDescription; // Getter for temporary description

  String? _description; // Add this property for description
  String? get description => _description; // Getter for description

  CartViewModel(this._cartService);

  Future<void> fetchCart() async {
    setBusy(true);
    try {
      _cartItems = await _cartService.fetchCart();
      if (_cartItems.isNotEmpty) {
        _description =
            _cartItems.first.Description; // Initialize the description
        _temporaryDescription = _description; // Set the temporary description
      }
      await fetchCartItems();
    } catch (e) {
      print('Failed to load cart: $e');
    }
    setBusy(false);
  }

  Future<void> fetchCartItems() async {
    try {
      _cartItemDetails = await _cartService.fetchCartItems();
    } catch (e) {
      print('Failed to load cart items: $e');
    }
  }

  double get totalPrice {
    return _cartItemDetails.fold(0, (sum, item) {
      double effectivePrice = item.discount ?? item.price;
      return sum + (effectivePrice * item.quantity);
    });
  }

  int get totalQuantity {
    return _cartItemDetails.fold(0, (sum, item) => sum + item.quantity);
  }

  void updateQuantity(CartItem item, int change) {
    int newQuantity = item.quantity + change;
    if (newQuantity < 0) return; // Prevent negative quantities

    // Create a new CartItem with the updated quantity
    CartItem updatedItem = item.copyWith(quantity: newQuantity);

    // Find the index and replace the item in the list
    int index = _cartItemDetails.indexOf(item);
    if (index != -1) {
      _cartItemDetails[index] = updatedItem;
    }

    _hasChanges = true; // Mark that a change has occurred
    notifyListeners(); // Notify listeners to update the UI
  }

  Future<void> deleteCartItem(CartItem item) async {
    setBusy(true);
    _errorMessage = null; // Reset the error message
    try {
      await _cartService.deleteCart(item.id); // Call the delete service
      _cartItemDetails.remove(item); // Remove the item from the local list
      await fetchCart(); // Refetch the cart to ensure state is updated
      notifyListeners(); // Notify listeners to update the UI
    } catch (e) {
      _errorMessage = 'Failed to delete item: ${e.toString()}';
      print(_errorMessage); // Print to console for debugging
      notifyListeners(); // Notify listeners to update the UI
    }
    setBusy(false);
  }

  void updateTemporaryDescription(String newDescription) {
    _temporaryDescription = newDescription; // Update the temporary description
    _hasChanges = true; // Mark that a change has occurred
    notifyListeners(); // Notify listeners to update the UI
  }

  Future<void> saveChanges() async {
    setBusy(true);
    _errorMessage = null; // Reset the error message
    try {
      // Save the description if it's available
      if (_temporaryDescription != null && _cartItems.isNotEmpty) {
        _description = _temporaryDescription; // Update the main description
        await _cartService.updateCart(_cartItems[0].id, _description!);
      }

      for (var item in _cartItemDetails) {
        print('Saving changes for item ID: ${item.id}'); // Debugging line
        await _cartService.updateCartItem(
            item.id, item); // Ensure item.id is valid
      }
      _hasChanges = false; // Reset the change flag
      notifyListeners(); // Notify listeners to update the UI
    } catch (e) {
      _errorMessage = 'Failed to save changes: ${e.toString()}';
      print(_errorMessage); // Print to console for debugging
      notifyListeners(); // Notify listeners to update the UI
    }
    setBusy(false);
  }

  Future<void> checkout() async {
    setBusy(true);
    _errorMessage = null; // Reset the error message
    try {
      await _cartService.checkoutCart(); // Call the checkout service
      // Optionally, clear the cart items and reset UI
      _cartItemDetails.clear();
      _cartItems.clear();
      notifyListeners(); // Notify listeners to update the UI
    } catch (e) {
      _errorMessage = 'Checkout failed: ${e.toString()}';
      print(_errorMessage); // Print to console for debugging
      notifyListeners(); // Notify listeners to update the UI
    }
    setBusy(false);
  }
}
