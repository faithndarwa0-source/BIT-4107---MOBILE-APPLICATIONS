import 'package:flutter/material.dart';
import 'product.dart';
import 'cart_page.dart';
import 'product_catalog_page.dart';
import 'profile_page.dart';
import 'database_helper.dart';

class MyHomePage extends StatefulWidget {
  final String username;
  final String email;
  const MyHomePage({super.key, required this.username, required this.email});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final List<Product> _cartItems = [];
  int _userPoints = 0;

  @override
  void initState() {
    super.initState();
    _loadUserPoints();
  }

  Future<void> _loadUserPoints() async {
    final customer = await DatabaseHelper.instance.getCustomer(widget.email);
    if (customer != null) {
      setState(() {
        _userPoints = customer['points'] ?? 0;
      });
    }
  }

  void _addToCart(Product product) {
    setState(() {
      _cartItems.add(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart!'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onCheckout(double amount) async {
    // Points logic: 1 point for every Ksh 10
    int earnedPoints = (amount / 10).floor();
    
    final customer = await DatabaseHelper.instance.getCustomer(widget.email);
    if (customer != null) {
      int currentPoints = customer['points'] ?? 0;
      int updatedPoints = currentPoints + earnedPoints;
      
      await DatabaseHelper.instance.updateCustomerPoints(customer['id'], updatedPoints);
      
      setState(() {
        _userPoints = updatedPoints;
        _selectedIndex = 2; // Take user to profile to see points
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      ProductCatalogPage(
        cartItems: _cartItems,
        onAddToCart: _addToCart,
      ),
      CartPage(
        cartItems: _cartItems,
        onCheckout: _onCheckout,
      ),
      ProfilePage(
        username: widget.username,
        email: widget.email,
        loyaltyPoints: _userPoints,
      ),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF0D47A1),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
