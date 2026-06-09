import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'database_helper.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController admissionController = TextEditingController();
  final TextEditingController courseController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void dispose() {
    nameController.dispose();
    admissionController.dispose();
    courseController.dispose();
    super.dispose();
  }

  Future<void> registerStudent() async {
    await dbHelper.insertStudent(
      nameController.text,
      admissionController.text,
      courseController.text,
    );

    debugPrint("Student saved to SQLite");

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DashboardScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Registration"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Student Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: admissionController,
              decoration: const InputDecoration(
                labelText: "Admission Number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: courseController,
              decoration: const InputDecoration(
                labelText: "Course",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: registerStudent,
              child: const Text("Register Student"),
            ),
          ],
        ),
      ),
    );
  }
}
