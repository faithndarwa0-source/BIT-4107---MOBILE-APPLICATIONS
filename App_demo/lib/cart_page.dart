import 'package:flutter/material.dart';
import '../models/product.dart';

class CartPage extends StatefulWidget {
  final List<Product> cartItems;

  const CartPage({super.key, required this.cartItems});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String _paymentMethod = 'Cash';

  double get _totalAmount => widget.cartItems.fold(0, (sum, item) => sum + item.price);

  String _formatCurrency(double amount) {
    return 'Ksh. ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},")}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Shopping Cart'),
        backgroundColor: Colors.amber,
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
                    color: Colors.blueGrey.shade50,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Amount:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(_formatCurrency(_totalAmount), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text('Select Payment Method:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      RadioGroup<String>(
                        groupValue: _paymentMethod,
                        onChanged: (value) => setState(() => _paymentMethod = value!),
                        child: Column(
                          children: const [
                            ListTile(
                              title: Text('Cash on Delivery'),
                              leading: Radio<String>(value: 'Cash'),
                            ),
                            ListTile(
                              title: Text('Card Payment'),
                              leading: Radio<String>(value: 'Card'),
                            ),
                            ListTile(
                              title: Text('Mobile Payment (M-Pesa)'),
                              leading: Radio<String>(value: 'Phone'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            textStyle: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Order Confirmed'),
                                content: Text('Thank you for your purchase! Total: ${_formatCurrency(_totalAmount)} via $_paymentMethod'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        widget.cartItems.clear();
                                      });
                                      Navigator.popUntil(context, (route) => route.isFirst);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
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
