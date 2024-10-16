import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final TextEditingController searchController;
  final Function(String) onSearch;
  final FocusNode focusNode;

  SearchField({
    required this.searchController,
    required this.onSearch,
    required this.focusNode,
  });

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField>
    with SingleTickerProviderStateMixin {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      setState(() {
        _isFocused = widget.focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      transform: Matrix4.translationValues(
        0,
        _isFocused ? -10 : 0,
        0,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              size: 24,
              color: Colors.grey[400],
            ),
            Expanded(
              child: TextField(
                focusNode: widget.focusNode,
                controller: widget.searchController,
                onChanged: widget.onSearch,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(fontSize: 16, color: Colors.grey[300]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ),
            widget.searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      size: 24,
                      color: Colors.grey[400],
                    ),
                    onPressed: () {
                      widget.searchController.clear();
                      widget
                          .onSearch(''); // Trigger search with an empty string
                      widget.focusNode.unfocus();
                    },
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isFocused = widget.focusNode.hasFocus;
  }
}
