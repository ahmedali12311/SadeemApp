import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:vendors/ui/views/vendorDetails/VendorHeader.dart';
import 'package:vendors/ui/views/vendorDetails/Vendor_itemsViewModel.dart';
import 'package:vendors/ui/views/vendorDetails/vendor_table.dart';
import 'Search.dart';
import 'VendorDetailsModel.dart'; // ViewModel

class VendorDetailsView extends StatefulWidget {
  final String vendorId;

  VendorDetailsView({required this.vendorId});

  @override
  _VendorDetailsViewState createState() => _VendorDetailsViewState();
}

class _VendorDetailsViewState extends State<VendorDetailsView> {
  late VendorDetailsViewModel viewModel;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    viewModel = VendorDetailsViewModel(widget.vendorId);
    viewModel.fetchVendorDetails();
    viewModel.fetchVendorTables();
    viewModel.fetchVendorItems();
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (_selectedIndex) {
      case 0:
        viewModel.Home();
        break;
      case 1:
        viewModel.navigateToProfile();
        break;
      case 2:
        viewModel.Cart();

        break;
      case 3:
        viewModel.Orders();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VendorDetailsViewModel>.reactive(
      viewModelBuilder: () => VendorDetailsViewModel(widget.vendorId),
      onModelReady: (viewModel) {
        viewModel.fetchVendorDetails();
        viewModel.fetchVendorTables();
        viewModel.fetchVendorItems();
      },
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          body: viewModel.isBusy
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepPurpleAccent,
                    strokeWidth: 4.0,
                  ),
                )
              : viewModel.vendor == null
                  ? Center(
                      child: Text(
                        'Vendor not found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    )
                  : NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        if (scrollNotification is ScrollEndNotification &&
                            scrollNotification.metrics.maxScrollExtent ==
                                scrollNotification.metrics.pixels) {
                          if (viewModel.canLoadMore()) {
                            viewModel.fetchVendorItems(
                                query: viewModel.currentSearchQuery);
                          }
                        }
                        return true; // Propagate the notification to other listeners
                      },
                      child: CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            expandedHeight: 300,
                            pinned: true,
                            flexibleSpace: FlexibleSpaceBar(
                              collapseMode: CollapseMode.parallax,
                              background:
                                  VendorHeader(vendor: viewModel.vendor!),
                              centerTitle: true,
                            ),
                            backgroundColor: Colors.black.withOpacity(0.5),
                            elevation: 4,
                          ),
                          SliverToBoxAdapter(
                            child: TablesSection(viewModel: viewModel),
                          ),
                          SliverToBoxAdapter(
                            child: SearchItemBar(viewModel: viewModel),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.all(12.0),
                            sliver: ItemsGrid(
                              viewModel: viewModel,
                              scaffoldContext: context,
                            ),
                          ),
                          if (viewModel.isLoadingItems)
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.deepPurpleAccent,
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
            onItemSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
              _onTabSelected(index);
            },
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
