import 'package:flutter/material.dart';

class ShippingAddressPage extends StatefulWidget {
  const ShippingAddressPage({super.key});

  @override
  State<ShippingAddressPage> createState() => _ShippingAddressPageState();
}

class _ShippingAddressPageState extends State<ShippingAddressPage> {
  final List<String> _addresses = [
    'Westlands, Nairobi, Kenya',
    'Karen, Nairobi, Kenya',
    'Kilimani, Nairobi, Kenya',
    'Upper Hill, Nairobi, Kenya',
    'Gigiri, Nairobi, Kenya',
    'Muthaiga, Nairobi, Kenya',
    'Mombasa Road, Nairobi, Kenya',
    'Parklands, Nairobi, Kenya',
    'Kasarani, Nairobi, Kenya',
    'South B, Nairobi, Kenya',
  ];

  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredAddresses = _addresses
        .where((addr) => addr.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Shipping Address'),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for your location...',
                prefixIcon: const Icon(Icons.location_on, color: Color(0xFF0D47A1)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: filteredAddresses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 80, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text('"${_searchQuery}" not found on our list.', style: const TextStyle(fontSize: 16, color: Colors.grey)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Address request sent! We will add this location soon.')),
                            );
                          },
                          child: const Text('REQUEST THIS LOCATION'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredAddresses.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.place, color: Color(0xFF0D47A1)),
                        title: Text(filteredAddresses[index]),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Delivery set to ${filteredAddresses[index]}')),
                          );
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
