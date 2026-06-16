import 'package:flutter/material.dart';
import 'login_page.dart';
import 'database_helper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> registerCustomer() async {
    await DatabaseHelper.instance.insertCustomer({
      'name': nameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'points': 0,
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Customer Registered'),
        ),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D47A1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'CREATE ACCOUNT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Username', Icons.person_outline),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a username' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Email Address', Icons.email_outlined),
                  validator: (value) {
                    if (value == null || !value.endsWith('@gmail.com')) {
                      return 'Email must be a @gmail.com address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Password', Icons.lock_outline),
                  validator: (value) {
                    if (value == null || value.length != 8) {
                      return 'Password must be exactly 8 characters';
                    }
                    bool hasLetter = value.contains(RegExp(r'[a-zA-Z]'));
                    bool hasNumber = value.contains(RegExp(r'[0-9]'));
                    int specialCount = value.replaceAll(RegExp(r'[a-zA-Z0-9]'), '').length;
                    
                    if (!hasLetter || !hasNumber) {
                      return 'Must contain letters and numbers';
                    }
                    if (specialCount > 1) {
                      return 'At most one special symbol allowed';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.blue.shade400,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await registerCustomer();

                      if (mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(
                              registeredUsername: nameController.text,
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('REGISTER',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? ',
                        style: TextStyle(color: Colors.white70)),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      child: Text('Login Now',
                          style: TextStyle(
                              color: Colors.blue.shade200, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      errorStyle: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.white54),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.white),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.amberAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.white),
      ),
      prefixIcon: Icon(icon, color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.1),
    );
  }
}
