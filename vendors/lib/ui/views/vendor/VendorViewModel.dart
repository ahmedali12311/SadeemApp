import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:vendors/models/user.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../models/vendor.dart';
import '../../../services/vendorservices.dart';

class VendorViewModel extends BaseViewModel {
  final _vendorService = VendorService();
  final _navigationService = locator<NavigationService>();

  TextEditingController searchController = TextEditingController();
  List<Vendor> vendors = [];
  List<Vendor> filteredVendors = [];
  int currentPage = 1;
  int totalPages = 1;
  int _totalPagesForSearch = 1;
  User? user;
  int itemsPerPage = 12;
  String sortOrder = 'latest';

  VendorViewModel() {
    searchController.addListener(() {
      searchVendors(searchController.text);
    });
    fetchVendors();
    fetchUserProfile();
  }

  void fetchVendors() async {
    setBusy(true);
    try {
      final result = await _vendorService.getVendors(
        currentPage,
        itemsPerPage,
        sortOrder,
        searchController.text,
      );
      if (result.vendors.isNotEmpty) {
        vendors = result.vendors;
        totalPages = (result.totalPages / itemsPerPage).ceil();
        if (searchController.text.isEmpty) {
          filteredVendors = vendors;
        }
      } else {
        vendors = [];
        filteredVendors = [];
        totalPages = 1;
      }
    } catch (e) {
      print('Error fetching vendors: $e');
    }
    setBusy(false);
    notifyListeners();
  }

  Future<void> fetchUserProfile() async {
    setBusy(true);
    try {
      user = await _vendorService.getUserProfile();
    } catch (e) {
      print('Error fetching vendors: $e');
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  int get totalPagesForSearch {
    return _totalPagesForSearch;
  }

  void previousPage() {
    if (currentPage > 1) {
      currentPage--;
      if (searchController.text.isEmpty) {
        fetchVendors();
      } else {
        notifyListeners();
      }
    }
  }

  void nextPage() {
    if (searchController.text.isEmpty) {
      if (currentPage < totalPages) {
        currentPage++;
        fetchVendors();
      }
    } else {
      if (currentPage < totalPagesForSearch) {
        currentPage++;
        notifyListeners();
      }
    }
  }

  void searchVendors(String query) {
    if (query.isEmpty) {
      filteredVendors = vendors;
      totalPages = (vendors.length / itemsPerPage).ceil();
      fetchVendors();
    } else {
      filteredVendors = vendors.where((vendor) {
        return vendor.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
      totalPages = (filteredVendors.length / itemsPerPage).ceil();
    }
    currentPage = 1;
    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    filteredVendors = vendors;
    notifyListeners();
  }

  List<Vendor> get paginatedVendors {
    return filteredVendors.take(itemsPerPage).toList();
  }

  void changeSortOrder(String order) {
    sortOrder = order;
    fetchVendors();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    final navigationService = locator<NavigationService>();
    navigationService.navigateTo(Routes.signInView);
  }

  bool get hasMorePages => currentPage < totalPages;

  void navigateToProfile() {
    try {
      _navigationService.navigateTo(Routes.profileView);
    } catch (e) {
      print('Error navigating to ProfileView: $e');
    }
  }

  void navigateToVendorDetails() {
    _navigationService.navigateTo(Routes.vendorDetailsView);
  }

  void Cart() {
    try {
      _navigationService.navigateTo(Routes.cartView);
    } catch (e) {
      print('Error navigating to ProfileView: $e');
    }
  }

  void Order() {
    try {
      _navigationService.navigateTo(Routes.UserOrderView);
    } catch (e) {
      print('Error navigating to ProfileView: $e');
    }
  }
}
