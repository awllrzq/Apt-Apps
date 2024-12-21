import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Import intl untuk format tanggal
import 'login_screen.dart'; // Pastikan untuk import LoginScreen
import 'property_page.dart'; // Import halaman PropertyPage
import 'add_property_screen.dart'; // Import AddPropertyPage

// Model Properti
class Property {
  final String name;
  bool isActive;

  Property({
    required this.name,
    this.isActive = false,
  });
}

// Daftar properti yang akan ditampilkan
final List<Property> properties = [
  Property(name: "Apart Puri Park View 2'Br", isActive: true),
  Property(name: "Permata Eksekutif studio", isActive: false),
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Apartment Manager',
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = "User"; // Default value
  String _currentDate = ""; // Default value
  double incomeAmount = 1500000; // Default income amount
  double outcomeAmount = 500000; // Default outcome amount

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Controllers for manual input
  TextEditingController incomeController = TextEditingController();
  TextEditingController outcomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _getCurrentDate();
    incomeController.text = incomeAmount.toString();
    outcomeController.text = outcomeAmount.toString();
  }

  // Mendapatkan data pengguna dari Firebase
  void _getCurrentUser() {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _userName = user.displayName ?? "User"; // Menampilkan nama pengguna atau "User" jika tidak ada
      });
    } else {
      // Jika user null, arahkan ke login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    }
  }

  // Mendapatkan tanggal saat ini
  void _getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, d MMMM yyyy').format(now);
    setState(() {
      _currentDate = formattedDate; // Format tanggal
    });
  }

  void _toggleSwitch(int index) {
    setState(() {
      properties[index].isActive = !properties[index].isActive;
    });
  }

  void _deleteProperty(int index) {
    setState(() {
      properties.removeAt(index);
    });
  }

  void _addProperty(Map<String, String> property) {
    setState(() {
      properties.add(Property(name: property['name']!, isActive: false)); // Add new property to list
    });
  }

  void _logout() {
    _auth.signOut(); // Sign out Firebase
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  // Show dialog to edit income or outcome
  void _editAmount(BuildContext context, String type) {
    TextEditingController controller = type == 'income' ? incomeController : outcomeController;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit $type Amount"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: type == 'income' ? 'Income' : 'Outcome',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  if (type == 'income') {
                    incomeAmount = double.tryParse(controller.text) ?? incomeAmount;
                  } else {
                    outcomeAmount = double.tryParse(controller.text) ?? outcomeAmount;
                  }
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  double get total => incomeAmount - outcomeAmount; // Calculate the total (income - outcome)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout, // Panggil fungsi logout
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome, $_userName", // Menampilkan nama pengguna
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _currentDate, // Menampilkan tanggal saat ini
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "STATEMENT",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        leading: Icon(Icons.trending_up, color: Colors.green),
                        title: Text("INCOME"),
                        trailing: TextButton(
                          onPressed: () {
                            _editAmount(context, 'income');
                          },
                          child: Text(
                            "Rp.${incomeAmount.toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.trending_down, color: Colors.red),
                        title: Text("OUTCOME"),
                        trailing: TextButton(
                          onPressed: () {
                            _editAmount(context, 'outcome');
                          },
                          child: Text(
                            "Rp.${outcomeAmount.toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // Display total
                      const SizedBox(height: 10),
                      ListTile(
                        title: Text(
                          "TOTAL",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        trailing: Text(
                          "Rp.${total.toStringAsFixed(0)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: total >= 0 ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "PROPERTY LIST",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...properties.map((property) {
                        int index = properties.indexOf(property);
                        return ListTile(
                          title: Text(property.name),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PropertyPage(propertyName: property.name),
                              ),
                            );
                          },
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Switch(
                                value: property.isActive,
                                onChanged: (value) {
                                  _toggleSwitch(index);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _deleteProperty(index);
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    IconButton(
                      iconSize: 40,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddPropertyPage(onAddProperty: _addProperty),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_circle, color: Colors.grey),
                    ),
                    const Text(
                      "Add Property",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
