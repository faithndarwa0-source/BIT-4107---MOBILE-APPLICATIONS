import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'main.dart'; // To access themeNotifier
import 'orders_page.dart';
import 'shipping_address_page.dart';

class ProfilePage extends StatefulWidget {
  final String username;
  final String email;
  final int loyaltyPoints;

  const ProfilePage({
    super.key,
    required this.username,
    required this.email,
    required this.loyaltyPoints,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final bool isDark = themeNotifier.value == ThemeMode.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50, // Slightly smaller
              backgroundColor: Color(0xFF0D47A1),
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 15),
            Text(
              widget.username,
              style: const TextStyle(
                fontSize: 22, // Smaller font
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.email,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 25),
            
            // Smaller Loyalty Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF0D47A1), width: 1),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.stars, color: Color(0xFF0D47A1), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Loyalty Balance',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.blue.shade200 : const Color(0xFF0D47A1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.loyaltyPoints}',
                    style: const TextStyle(
                      fontSize: 32, // Smaller font than before (48 -> 32)
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Text(
                    'Total Points',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            _buildProfileOption(Icons.shopping_bag_outlined, 'My Orders', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const OrdersPage()));
            }),
            _buildProfileOption(Icons.location_on_outlined, 'Shipping Address', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ShippingAddressPage()));
            }),
            
            // Payment Methods removed as per instruction
            
            // Settings with Global Dark Mode Toggle
            ListTile(
              leading: const Icon(Icons.settings_outlined, color: Color(0xFF0D47A1)),
              title: const Text(
                'Dark Mode',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: Switch(
                value: isDark,
                onChanged: (value) async {
                  setState(() {
                    themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                  });
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isDark', value);
                },
                activeColor: const Color(0xFF0D47A1),
              ),
            ),
            
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  // Clear login status
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();

                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                      (route) => false,
                    );
                  }
                },
                child: const Text('LOGOUT'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF0D47A1)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
