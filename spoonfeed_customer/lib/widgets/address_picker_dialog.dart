import 'package:flutter/material.dart';

class AddressPickerDialog extends StatefulWidget {
  final Function(String) onAddressSelected;
  final List<String> recentAddresses;
  final Future<List<String>> Function(String) onSearchAddresses;

  const AddressPickerDialog({
    super.key,
    required this.onAddressSelected,
    required this.recentAddresses,
    required this.onSearchAddresses,
  });

  @override
  State<AddressPickerDialog> createState() => _AddressPickerDialogState();
}

class _AddressPickerDialogState extends State<AddressPickerDialog> {
  final TextEditingController _controller = TextEditingController();
  List<String> searchResults = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_controller.text.isNotEmpty) {
      _performSearch(_controller.text);
    } else {
      setState(() {
        searchResults = [];
        isSearching = false;
      });
    }
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      isSearching = true;
    });

    try {
      final results = await widget.onSearchAddresses(query);
      setState(() {
        searchResults = results;
        isSearching = false;
      });
    } catch (e) {
      setState(() {
        searchResults = [];
        isSearching = false;
      });
    }
  }

  void _selectAddress(String address) {
    widget.onAddressSelected(address);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Choose Delivery Address",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            
            const SizedBox(height: 15),
            
            // Search TextField
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Type your address (e.g., 'ivana')",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: isSearching
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Results
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recent Addresses Section
                  if (widget.recentAddresses.isNotEmpty && _controller.text.isEmpty) ...[
                    const Text(
                      "Recent Addresses",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.recentAddresses.length,
                        itemBuilder: (context, index) {
                          final address = widget.recentAddresses[index];
                          return ListTile(
                            leading: const Icon(Icons.history, color: Colors.grey),
                            title: Text(address),
                            onTap: () => _selectAddress(address),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  
                  // Search Results Section
                  if (_controller.text.isNotEmpty) ...[
                    Text(
                      searchResults.isEmpty && !isSearching
                          ? "No addresses found"
                          : "Search Results",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: searchResults.isEmpty && !isSearching
                          ? const Center(
                              child: Text(
                                "Try typing more of your address",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: searchResults.length,
                              itemBuilder: (context, index) {
                                final address = searchResults[index];
                                return ListTile(
                                  leading: const Icon(Icons.location_on, color: Colors.blue),
                                  title: Text(address),
                                  onTap: () => _selectAddress(address),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                  
                  // Empty state when no recent addresses and no search
                  if (widget.recentAddresses.isEmpty && _controller.text.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on, size: 50, color: Colors.grey),
                            SizedBox(height: 10),
                            Text(
                              "Start typing your address",
                              style: TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}