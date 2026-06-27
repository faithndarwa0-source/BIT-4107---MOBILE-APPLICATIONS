import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'product.dart';
import 'database_helper.dart';

class CartPage extends StatefulWidget {
  final List<Product> cartItems;
  final Function(double)? onCheckout;

  const CartPage({super.key, required this.cartItems, this.onCheckout});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String _paymentMethod = 'Cash';

  double get _totalAmount => widget.cartItems.fold(0.0, (sum, item) => sum + item.price);

  String _formatCurrency(double amount) {
    return 'Ksh. ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},")}';
  }

  Future<void> _processCheckout() async {
    final double amount = _totalAmount;
    if (amount <= 0) return;

    final prefs = await SharedPreferences.getInstance();
    final int? customerId = prefs.getInt('customerId');

    if (customerId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: User not logged in correctly.')),
        );
      }
      return;
    }

    // 1. Calculate earned points: 1 point for every Ksh 10
    int earnedPoints = (amount / 10).floor();

    // 2. Retrieve current points from SQLite
    final customerData = await DatabaseHelper.instance.getCustomerById(customerId);
    int currentPoints = customerData?['points'] ?? 0;

    // 3. Calculate new total
    int totalPoints = currentPoints + earnedPoints;

    // 4. Update SQLite
    await DatabaseHelper.instance.updateCustomerPoints(customerId, totalPoints);
    
    // Save order history
    await DatabaseHelper.instance.insertOrder({
      'customerId': customerId,
      'amount': amount,
      'pointsEarned': earnedPoints,
      'date': DateTime.now().toIso8601String(),
      'items': widget.cartItems.map((e) => e.name).join(', '),
    });

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Order Confirmed', style: TextStyle(color: Color(0xFF0D47A1), fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Purchase Amount: ${_formatCurrency(amount)}'),
              const SizedBox(height: 8),
              Text('Points Earned: +$earnedPoints', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('New Points Balance: $totalPoints'),
              const SizedBox(height: 16),
              const Text('Thank you for shopping with Wonderful Glass Mart!'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (widget.onCheckout != null) {
                  widget.onCheckout!(amount);
                }
                setState(() {
                  widget.cartItems.clear();
                });
                Navigator.of(context).pop();
              },
              child: const Text('GREAT!'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Shopping Cart'),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: widget.cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.cartItems[index];
                      return ListTile(
                        leading: Image.asset(item.image, width: 50, height: 50, fit: BoxFit.cover),
                        title: Text(item.name),
                        subtitle: Text(item.formattedPrice),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              widget.cartItems.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : Colors.blueGrey.shade50,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Amount:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(
                            _formatCurrency(_totalAmount),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D47A1),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text('Select Payment Method:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      RadioListTile<String>(
                        title: const Text('Cash on Delivery'),
                        value: 'Cash',
                        groupValue: _paymentMethod,
                        onChanged: (value) => setState(() => _paymentMethod = value!),
                        activeColor: const Color(0xFF0D47A1),
                      ),
                      RadioListTile<String>(
                        title: const Text('Card Payment'),
                        value: 'Card',
                        groupValue: _paymentMethod,
                        onChanged: (value) => setState(() => _paymentMethod = value!),
                        activeColor: const Color(0xFF0D47A1),
                      ),
                      RadioListTile<String>(
                        title: const Text('Mobile Payment (M-Pesa)'),
                        value: 'Phone',
                        groupValue: _paymentMethod,
                        onChanged: (value) => setState(() => _paymentMethod = value!),
                        activeColor: const Color(0xFF0D47A1),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? Colors.white24 : Colors.black,
                            foregroundColor: Colors.blue.shade400,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            textStyle: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: _processCheckout,
                          child: const Text('CHECKOUT'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
