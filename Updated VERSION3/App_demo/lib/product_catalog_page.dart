import 'package:flutter/material.dart';
import 'product.dart';

class ProductCatalogPage extends StatefulWidget {
  final List<Product> cartItems;
  final Function(Product) onAddToCart;

  const ProductCatalogPage({
    super.key,
    required this.cartItems,
    required this.onAddToCart,
  });

  @override
  State<ProductCatalogPage> createState() => _ProductCatalogPageState();
}

class _ProductCatalogPageState extends State<ProductCatalogPage> {
  final List<Product> _allProducts = [
    Product('Decorative Mirror', 12000, Icons.auto_awesome, 'High-definition wall mirror', 'images/Decorative mirror.jpg', 'Mirrors'),
    Product('Tempered Glass', 8500, Icons.grid_view, 'Durable window glass', 'images/tampered glass.jpg', 'Window Glass'),
    Product('Sliding Door', 45000, Icons.sensor_door, 'Modern glass sliding system', 'images/sliding door.jpg', 'Doors'),
    Product('Tinted Glass', 6000, Icons.blur_on, 'UV protection for windows', 'images/tinted glass.jpg', 'Window Glass'),
    Product('Frost Mirror', 15000, Icons.wb_sunny, 'Elegant bathroom mirror', 'images/frost mirror.jpg', 'Mirrors'),
    Product('Safety Glass', 9500, Icons.shield, 'Impact resistant window glass', 'images/safety glass.jpg', 'Window Glass'),
    Product('Laminated Glass', 18000, Icons.layers, 'Extra strong security glass', 'images/laminated glass.jpg', 'Security Glass'),
    Product('Beveled Mirror', 14000, Icons.diamond, 'Stylish edges for decor', 'images/beveled glass.jpg', 'Mirrors'),
    Product('Glass Table Top', 7500, Icons.table_restaurant, 'Custom cut furniture glass', 'images/glass table top.jpg', 'Specialty Glass'),
    Product('Shower Enclosure', 55000, Icons.shower, 'Complete glass shower set', 'images/shower enclosure.jpg', 'Specialty Glass'),
    Product('Patterned Glass', 11000, Icons.texture, 'Privacy glass with designs', 'images/Patterned glass.jpg', 'Window Glass'),
    Product('Wired Glass', 13500, Icons.border_all, 'Fire-resistant safety glass', 'images/wired glass.jpg', 'Security Glass'),
    Product('One-way Mirror', 22000, Icons.visibility_off, 'Privacy observation glass', 'images/one-way mirror.jpg', 'Mirrors'),
    Product('Smart Glass', 95000, Icons.settings_remote, 'Switchable opacity glass', 'images/smart glass.jpg', 'Specialty Glass'),
    Product('Anti-reflective Glass', 16000, Icons.light_mode, 'High clarity display glass', 'images/anti-reflective glass.jpg', 'Window Glass'),
    Product('Bulletproof Glass', 150000, Icons.security, 'Maximum security protection', 'images/bulletproof glass.jpg', 'Security Glass'),
  ];

  final List<String> _categories = [
    'All',
    'Mirrors',
    'Window Glass',
    'Doors',
    'Security Glass',
    'Specialty Glass'
  ];

  String _selectedCategory = 'All';
  List<Product> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredProducts = _allProducts;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      _filteredProducts = _allProducts.where((product) {
        bool matchesCategory = _selectedCategory == 'All' || product.category == _selectedCategory;
        bool matchesSearch = product.name.toLowerCase().contains(query);
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Collection'),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _filterProducts(),
              decoration: InputDecoration(
                hintText: 'Search for products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: isDark ? Colors.white10 : Colors.grey.shade100,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  'Categories',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = category;
                          _filterProducts();
                        });
                      }
                    },
                    selectedColor: const Color(0xFF0D47A1),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _filteredProducts.isEmpty
                ? const Center(child: Text('No items found.'))
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey.shade100,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                  image: DecorationImage(
                                    image: AssetImage(product.image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    product.formattedPrice,
                                    style: TextStyle(
                                      color: isDark ? Colors.blue.shade200 : Colors.blueGrey.shade700,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isDark ? Colors.white24 : Colors.black,
                                        foregroundColor: Colors.blue.shade400,
                                        padding: EdgeInsets.zero,
                                        textStyle: const TextStyle(fontSize: 12),
                                      ),
                                      onPressed: () {
                                        widget.onAddToCart(product);
                                      },
                                      child: const Text('Add to Cart'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
