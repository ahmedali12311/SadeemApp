import 'package:flutter/material.dart';
import 'package:vendors/ui/views/vendorDetails/VendorDetailsModel.dart';

class TablesSection extends StatelessWidget {
  final VendorDetailsViewModel viewModel;

  const TablesSection({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (viewModel.occupiedTable != null) {
      final table = viewModel.occupiedTable!;
      return Card(
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                "Your Occupied Table: ${table.name}",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  viewModel.freeTable().then((message) {
                    final snackBar = SnackBar(
                      content: Text(message ?? 'Error occurred'),
                      backgroundColor: message == 'Table freed successfully!'
                          ? Colors.green
                          : Colors.red,
                      duration: Duration(seconds: 2),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
                },
                child: Text(
                  "Free Table",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (viewModel.tables != null) {
      return Card(
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Available Tables",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Divider(color: Colors.grey[300]),
              ...viewModel.tables?.map(
                    (table) => ListTile(
                      title: Text(
                        table.name,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          viewModel.occupyTable(table).then((message) {
                            final snackBar = SnackBar(
                              content: Text(message ?? 'Error occurred'),
                              backgroundColor:
                                  message == 'Table occupied successfully!'
                                      ? Colors.green
                                      : Colors.red,
                              duration: Duration(seconds: 2),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          });
                        },
                        child: Text(
                          "Occupy",
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ) ??
                  [],
            ],
          ),
        ),
      );
    } else {
      return Container(); // or a loading indicator
    }
  }
}
