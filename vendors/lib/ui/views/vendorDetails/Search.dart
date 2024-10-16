import 'package:flutter/material.dart';
import 'package:vendors/ui/views/vendorDetails/VendorDetailsModel.dart';
import 'package:vendors/widgets/searchfield.dart';

class SearchItemBar extends StatelessWidget {
  final VendorDetailsViewModel viewModel;

  const SearchItemBar({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SearchField(
        searchController: viewModel.searchController,
        focusNode: viewModel.searchFocusNode,
        onSearch: (query) => viewModel.searchItems(query),
      ),
    );
  }
}
