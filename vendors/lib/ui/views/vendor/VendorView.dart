import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:stacked/stacked.dart';
import 'package:vendors/ui/views/cart/CartView.dart';
import 'package:vendors/ui/views/orders/userorderview.dart';

import '../../../widgets/searchfield.dart';
import '../Profile/ProfileView.dart';
import 'VendorViewModel.dart';
import 'VendorGrid.dart';

class VendorView extends StatefulWidget {
  @override
  _VendorViewState createState() => _VendorViewState();
}

class _VendorViewState extends State<VendorView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late FocusNode _searchFocusNode;
  late int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onMenuIconPressed(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void _onTabSelected(int index) {
    if (index == 0) {
    } else if (index == 1) {
      _navigateTo(ProfileView(), index);
    } else if (index == 2) {
      _navigateTo(CartView(), index);
    } else {
      _navigateTo(UserOrderView(), index);
    }
  }

  void _navigateTo(Widget view, int index) {
    _searchFocusNode.unfocus(); // Unfocus the search field before navigating
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => view,
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
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VendorViewModel>.reactive(
      viewModelBuilder: () => VendorViewModel(),
      builder: (context, viewModel, child) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: _buildAppBar(context, viewModel),
          drawer: _buildDrawer(viewModel),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SearchField(
                  searchController: viewModel
                      .searchController, // Updated to use searchController from ViewModel
                  onSearch: viewModel
                      .searchVendors, // Updated to use search method from ViewModel
                  focusNode: _searchFocusNode,
                ),
                SizedBox(height: 16),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: Column(
                      key: ValueKey<int>(viewModel.currentPage),
                      children: [
                        Expanded(child: VendorGrid(viewModel)),
                      ],
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
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, VendorViewModel viewModel) {
    return AppBar(
      title: Text('Vendors',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary)),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0,
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
      leading: Builder(
        builder: (context) => GestureDetector(
          onTapDown: (_) => _controller.forward(),
          onTapUp: (_) {
            _controller.reverse();
            _onMenuIconPressed(context);
          },
          onTapCancel: () => _controller.reverse(),
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              margin: EdgeInsets.all(6),
              padding: EdgeInsets.all(10),
              child: Icon(Icons.menu,
                  size: 25, color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            _searchFocusNode.unfocus();
            viewModel.changeSortOrder(value);
          },
          itemBuilder: (context) => _buildSortMenuItems(),
          icon: Container(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.sort,
                size: 25, color: Theme.of(context).colorScheme.onPrimary),
          ),
          offset: Offset(0, 40),
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ],
    );
  }

  List<PopupMenuEntry<String>> _buildSortMenuItems() {
    return [
      PopupMenuItem(
          value: 'latest',
          child: _buildMenuItem(Icons.timer, 'Sort by Latest')),
      PopupMenuItem(
          value: 'name_asc',
          child: _buildMenuItem(Icons.sort_by_alpha, 'Sort by Name (A-Z)')),
      PopupMenuItem(
          value: 'name_desc',
          child: _buildMenuItem(Icons.sort_by_alpha, 'Sort by Name (Z-A)')),
    ];
  }

  Widget _buildMenuItem(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.onSurface),
          SizedBox(width: 8),
          Text(text,
              style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface)),
        ],
      ),
    );
  }

  Drawer _buildDrawer(VendorViewModel viewModel) {
    return Drawer(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: viewModel.user?.imageUrl != null
                    ? NetworkImage(viewModel.user!.imageUrl!) as ImageProvider
                    : AssetImage('assets/profile.jpg') as ImageProvider,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.1), BlendMode.modulate),
              ),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                _buildDrawerHeader(viewModel),
                _buildDrawerItem(
                  icon: Icons.person,
                  title: 'Profile',
                  onTap: () {
                    viewModel.navigateToProfile();
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {
                    viewModel.logout();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(VendorViewModel viewModel) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 45,
              backgroundImage: viewModel.user?.imageUrl != null
                  ? NetworkImage(viewModel.user!.imageUrl!)
                  : null,
              backgroundColor: Colors.transparent,
              child: viewModel.user?.imageUrl == null
                  ? Icon(Icons.person, size: 70, color: Colors.white)
                  : null,
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    viewModel.user?.name ?? 'Guest',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Text(
                    viewModel.user?.email ?? 'No Email',
                    style: TextStyle(color: Colors.white.withOpacity(0.8)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.9),
              width: 1,
            ),
          ),
        ),
        child: ListTile(
          leading: Icon(icon,
              size: 30, color: Theme.of(context).colorScheme.primary),
          title: Text(
            title,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
