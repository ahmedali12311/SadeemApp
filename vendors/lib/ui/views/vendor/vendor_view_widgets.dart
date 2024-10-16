import 'package:flutter/material.dart';
import 'VendorViewModel.dart';

Widget buildVendorGrid(VendorViewModel viewModel) {
  return SliverGrid(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 0.65,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
    ),
    delegate: SliverChildBuilderDelegate(
      (context, index) {
        return Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              // Vendor image and details
            ],
          ),
        );
      },
      childCount: viewModel.paginatedVendors.length,
    ),
  );
}

Widget _buildPaginationControls(VendorViewModel viewModel) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: viewModel.currentPage > 1 ? viewModel.previousPage : null,
      ),
      for (int i = 1; i <= viewModel.totalPages; i++)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: TextButton(
            onPressed: () {
              viewModel.currentPage = i;
              viewModel.fetchVendors();
            },
            style: TextButton.styleFrom(
              backgroundColor:
                  i == viewModel.currentPage ? Colors.teal : Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              '$i',
              style: TextStyle(
                color: i == viewModel.currentPage ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      IconButton(
        icon: Icon(Icons.arrow_forward),
        onPressed: viewModel.currentPage < viewModel.totalPages
            ? viewModel.nextPage
            : null,
      ),
    ],
  );
}
