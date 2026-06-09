import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'registration_screen.dart';
import 'main.dart';
import 'home_screen.dart';
import 'api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> students = [];
  List<dynamic> apiUsers = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    loadStudents();
    loadApiUsers();
  }

  Future<void> loadStudents() async {
    final data = await dbHelper.getStudents();
    setState(() {
      students = data;
    });
  }

  Future<void> loadApiUsers() async {
    final data = await apiService.fetchUsers();
    setState(() {
      apiUsers = data;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildDashboardTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            "Registered Students",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: loadApiUsers,
            child: const Text('Load Online Students'),
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Local Database:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: students.isEmpty
                ? const Center(child: Text("No students registered yet."))
                : ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];
                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(student['name'] ?? 'No Name'),
                          subtitle: Text(
                            "${student['admissionNumber'] ?? 'N/A'} - ${student['course'] ?? 'N/A'}",
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const Divider(height: 30),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Online Students (API):",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: apiUsers.isEmpty
                ? const Center(child: Text("Click 'Load Online Students' to fetch data."))
                : ListView.builder(
                    itemCount: apiUsers.length,
                    itemBuilder: (context, index) {
                      final user = apiUsers[index];
                      return Card(
                        color: Colors.blue.shade50,
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.cloud, color: Colors.white),
                          ),
                          title: Text(user['name'] ?? 'No Name'),
                          subtitle: Text(user['email'] ?? 'No Email'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    if (students.isEmpty) {
      return const Center(
        child: Text(
          "No student profile available.\nPlease register a student first.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    // Showing the first student's profile as a placeholder for the "Profile" tab
    final student = students[0];

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 70,
              backgroundColor: Colors.blueAccent,
              child: Icon(
                Icons.person,
                size: 90,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              student['name'] ?? 'N/A',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.badge_outlined, color: Colors.blue),
                      title: const Text(
                        "Admission Number",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        student['admissionNumber'] ?? 'N/A',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.school_outlined, color: Colors.blue),
                      title: const Text(
                        "Registered Course",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        student['course'] ?? 'N/A',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Settings"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder<ThemeMode>(
                valueListenable: themeNotifier,
                builder: (context, currentMode, _) {
                  return SwitchListTile(
                    title: const Text("Dark Mode"),
                    secondary: Icon(
                      currentMode == ThemeMode.dark
                          ? Icons.dark_mode
                          : Icons.light_mode,
                    ),
                    value: currentMode == ThemeMode.dark,
                    onChanged: (bool value) {
                      themeNotifier.value =
                          value ? ThemeMode.dark : ThemeMode.light;
                    },
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Dashboard"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      // Side menu (Drawer)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Students'),
              onTap: () {
                loadStudents();
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Student'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegistrationScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                _showSettingsDialog(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHomePage(title: 'Student Management Home'),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: _selectedIndex == 0 ? _buildDashboardTab() : _buildProfileTab(),
      // Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
