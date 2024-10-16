import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:vendors/app/app.locator.dart';
import 'package:vendors/app/app.router.dart';
import '../../../models/item.dart';
import '../../../models/vendor.dart';
import '../../../models/table.dart';
import '../../../services/VendorDetailsService.dart';

class VendorDetailsViewModel extends ChangeNotifier {
  final String vendorId;
  final _navigationService = locator<NavigationService>();
  final _isBusyForCart = ValueNotifier<bool>(false);
  ValueNotifier<bool> get isBusyForCart => _isBusyForCart;
  final ValueNotifier<Map<Items, int>> _cartNotifier = ValueNotifier({});

  Vendor? vendor;
  List<Items> items = [];
  List<Items> filteredItems = [];
  List<Tables>? tables;
  Tables? occupiedTable;
  int _currentPage = 1;
  final int itemsPerPage;
  bool _hasMoreItems = true;

  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  bool _isBusy = false;
  bool _isLoadingItems = false; // New loading state for items
  String _currentSearchQuery = ''; // Store the current query
  String get currentSearchQuery =>
      _currentSearchQuery; // Store the current query

  Timer? _debounce;

  VendorDetailsViewModel(this.vendorId, {this.itemsPerPage = 12}) {
    searchController.addListener(_onSearchChanged);
  }

  List<Items> get displayedItems =>
      filteredItems.isNotEmpty ? filteredItems : items;

  bool get hasMoreItems => _hasMoreItems;
  bool get isBusy => _isBusy;
  bool get isLoadingItems => _isLoadingItems;

  void setBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  void setLoadingItems(bool value) {
    _isLoadingItems = value;
    notifyListeners();
  }

  Map<Items, int> _itemQuantities = {};

  int getItemQuantity(Items item) {
    return _itemQuantities[item] ?? 0;
  }

  void incrementItemQuantity(Items item) {
    _itemQuantities[item] = (getItemQuantity(item) + 1);
    notifyListeners();
  }

  void decrementItemQuantity(Items item) {
    if (getItemQuantity(item) > 0) {
      _itemQuantities[item] = (getItemQuantity(item) - 1);
      notifyListeners();
    }
  }

  // Fetch the vendor details and check if the user has an occupied table
  Future<void> fetchVendorDetails() async {
    setBusy(true);
    try {
      // Fetch the vendor details
      vendor = await VendorDetailsService().getVendorDetails(vendorId);

      // Fetch the user's occupied table -- this is important!
      await fetchUserOccupiedTable();

      // If no table is occupied, fetch available tables
      if (occupiedTable == null) {
        await fetchVendorTables();
      }
    } catch (e) {
    } finally {
      setBusy(false);
    }
  }

  Future<void> fetchUserOccupiedTable() async {
    try {
      occupiedTable = await VendorDetailsService().getUserOccupiedTable();

      notifyListeners(); // Update the UI based on whether a table is occupied
    } catch (e) {
      print('Error fetching user\'s occupied table: $e');
    }
  }

  // Fetch available vendor tables (if no table is occupied)
  Future<void> fetchVendorTables() async {
    setBusy(true);
    try {
      tables = await VendorDetailsService().getVendorTables(vendorId);
      notifyListeners();
    } catch (e) {
      print('Error fetching vendor tables: $e');
    } finally {
      setBusy(false);
    }
  }

//tables
  Future<String?> occupyTable(Tables table) async {
    setBusy(true);
    try {
      await VendorDetailsService().occupyTable(vendorId, table.id);
      occupiedTable = table;
      tables = null; // Hide other tables when one is occupied
      notifyListeners();
      return 'Table occupied successfully!';
    } catch (e) {
      return 'Failed to occupy table: ${e.toString()}';
    } finally {
      setBusy(false);
    }
  }

  // Method to free the occupied table
  Future<String?> freeTable() async {
    if (occupiedTable == null) return 'No table to free';

    setBusy(true);
    try {
      await VendorDetailsService().freeTable(vendorId, occupiedTable!.id);
      occupiedTable = null;
      await fetchVendorTables(); // Reload tables after freeing the current one
      notifyListeners();
      return 'Table freed successfully!';
    } catch (e) {
      return 'Failed to free table: ${e.toString()}';
    } finally {
      setBusy(false);
    }
  }

  Future<void> fetchVendorItems({String query = '', bool reset = false}) async {
    if (!_hasMoreItems || _isLoadingItems) return;

    if (reset) {
      _currentPage = 1;
      items.clear();
      _hasMoreItems = true; // Reset pagination
    }

    setLoadingItems(true);
    print("Fetching items for query: $query");
    try {
      final newItems = await VendorDetailsService().getVendorItems(
        vendorId,
        query,
        _currentPage,
        itemsPerPage,
      );

      print("Fetched items: ${newItems.length}");

      if (_currentPage == 1) {
        items.clear(); // Clear the list if it's a fresh search
      }

      if (newItems.isNotEmpty) {
        items.addAll(newItems);
        _currentPage++;
        notifyListeners();
      } else {
        _hasMoreItems = false; // No more items to load
      }
      searchItems(
          _currentSearchQuery); // Reapply search after fetching new items
    } catch (e) {
      print('Error fetching vendor items: $e');
    } finally {
      setLoadingItems(false);
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _currentSearchQuery = searchController.text;
      fetchVendorItems(query: _currentSearchQuery, reset: true);
    });
  }

  void searchItems(String query) {
    if (query.isEmpty) {
      filteredItems = items;
    } else {
      filteredItems = items
          .where(
              (item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  ValueNotifier<Map<Items, int>> get cartNotifier => _cartNotifier;

  Future<String?> addItemToCart(Items item, int quantity) async {
    try {
      print(
          'Attempting to add item to cart: ${item.name}, Quantity: $quantity');

      // Add item to cart logic goes here
      await VendorDetailsService().addToCart(vendorId, item.id, quantity);

      print('Item added to cart successfully');

      // Update the cartNotifier without calling notifyListeners()
      final currentCart = Map<Items, int>.from(_cartNotifier.value);
      currentCart[item] = (currentCart[item] ?? 0) + quantity;
      _cartNotifier.value = currentCart; // Notify listeners of cart changes

      return 'Added to cart successfully!';
    } catch (e) {
      print('Error adding item to cart: $e');
      return 'Error: ${e.toString()}';
    }
  }

  void navigateToProfile() {
    try {
      _navigationService.navigateTo(Routes.profileView);
    } catch (e) {
      print('Error navigating to ProfileView: $e');
    }
  }

  void Home() {
    try {
      _navigationService.navigateTo(Routes.vendorView);
    } catch (e) {
      print('Error navigating to ProfileView: $e');
    }
  }

  void Cart() {
    try {
      _navigationService.navigateTo(Routes.cartView);
    } catch (e) {
      print('Error navigating to ProfileView: $e');
    }
  }

  void Orders() {
    try {
      _navigationService.navigateTo(Routes.UserOrderView);
    } catch (e) {
      print('Error navigating to ProfileView: $e');
    }
  }

  bool canLoadMore() => _hasMoreItems && !_isLoadingItems;
}
