import 'package:flutter/material.dart';
import '../ui/views/vendor/VendorViewModel.dart';

class PaginationControls extends StatelessWidget {
  final VendorViewModel viewModel;

  const PaginationControls({Key? key, required this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: viewModel.currentPage > 1
              ? () {
                  viewModel.previousPage();
                }
              : null,
        ),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(child: child, scale: animation);
          },
          child: Row(
            key: ValueKey<int>(viewModel.currentPage),
            children: [
              for (int i = 1; i <= viewModel.totalPages; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: TextButton(
                    onPressed: () {
                      viewModel.currentPage = i;
                      viewModel.fetchVendors();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: i == viewModel.currentPage
                          ? Colors.teal
                          : Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      '$i',
                      style: TextStyle(
                        color: i == viewModel.currentPage
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: viewModel.currentPage < viewModel.totalPages
              ? () {
                  viewModel.nextPage();
                }
              : null,
        ),
      ],
    );
  }
}
