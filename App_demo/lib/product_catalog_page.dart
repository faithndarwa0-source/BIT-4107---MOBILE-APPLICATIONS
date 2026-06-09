import 'package:flutter/material.dart';
import '../models/product.dart';
import 'cart_page.dart';

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
    Product('Decorative Mirror', 12000, Icons.auto_awesome, 'High-definition wall mirror', 'images/Decorative mirror.jpg'),
    Product('Tempered Glass', 8500, Icons.grid_view, 'Durable window glass', 'images/tampered glass.jpg'),
    Product('Sliding Door', 45000, Icons.sensor_door, 'Modern glass sliding system', 'images/sliding door.jpg'),
    Product('Tinted Glass', 6000, Icons.blur_on, 'UV protection for windows', 'images/tinted glass.jpg'),
    Product('Frost Mirror', 15000, Icons.wb_sunny, 'Elegant bathroom mirror', 'images/frost mirror.jpg'),
    Product('Safety Glass', 9500, Icons.shield, 'Impact resistant window glass', 'images/safety glass.jpg'),
    Product('Laminated Glass', 18000, Icons.layers, 'Extra strong security glass', 'images/laminated glass.jpg'),
    Product('Beveled Mirror', 14000, Icons.diamond, 'Stylish edges for decor', 'images/beveled glass.jpg'),
    Product('Glass Table Top', 7500, Icons.table_restaurant, 'Custom cut furniture glass', 'images/glass table top.jpg'),
    Product('Shower Enclosure', 55000, Icons.shower, 'Complete glass shower set', 'images/shower enclosure.jpg'),
    Product('Patterned Glass', 11000, Icons.texture, 'Privacy glass with designs', 'images/Patterned glass.jpg'),
    Product('Wired Glass', 13500, Icons.border_all, 'Fire-resistant safety glass', 'images/wired glass.jpg'),
    Product('One-way Mirror', 22000, Icons.visibility_off, 'Privacy observation glass', 'images/one-way mirror.jpg'),
    Product('Smart Glass', 95000, Icons.settings_remote, 'Switchable opacity glass', 'images/smart glass.jpg'),
    Product('Anti-reflective Glass', 16000, Icons.light_mode, 'High clarity display glass', 'images/anti-reflective glass.jpg'),
    Product('Bulletproof Glass', 150000, Icons.security, 'Maximum security protection', 'images/bulletproof glass.jpg'),
  ];

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

  void _filterProducts(String query) {
    setState(() {
      _filteredProducts = _allProducts
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Collection'),
        backgroundColor: Colors.blueGrey.shade50,
        actions: [
          IconButton(
            icon: Badge(
              label: Text('${widget.cartItems.length}'),
              isLabelVisible: widget.cartItems.isNotEmpty,
              child: const Icon(Icons.shopping_cart),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(cartItems: widget.cartItems),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterProducts,
              decoration: InputDecoration(
                hintText: 'Search for mirrors, glass...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
          ),
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
                                    style: TextStyle(color: Colors.blueGrey.shade700, fontWeight: FontWeight.w600, fontSize: 13),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.amber,
                                        foregroundColor: Colors.black,
                                        padding: EdgeInsets.zero,
                                        textStyle: const TextStyle(fontSize: 12),
                                      ),
                                      onPressed: () {
                                        widget.onAddToCart(product);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('${product.name} added to cart!'),
                                            duration: const Duration(seconds: 1),
                                          ),
                                        );
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
