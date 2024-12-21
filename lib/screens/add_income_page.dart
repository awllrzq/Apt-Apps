import 'package:flutter/material.dart';

class AddIncomePage extends StatefulWidget {
  final void Function(Map<String, dynamic> income) onAddIncome;

  const AddIncomePage({super.key, required this.onAddIncome});

  @override
  _AddIncomePageState createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  // Dropdown values
  final List<int> nightsList = List<int>.generate(30, (index) => index + 1);
  final List<String> appList = [
    'Traveloka',
    'Tiket.com',
    'Agoda',
    'Trip.com',
    'Booking.com',
    'Trivago',
    'Klook',
  ];

  // Selected values
  int? selectedNights;
  String? selectedApp;
  DateTime? checkInDate;
  DateTime? checkOutDate;
  TextEditingController priceController = TextEditingController();
  TextEditingController guestNameController = TextEditingController();

  // Function to show a DateTime Picker
  Future<void> selectDateTime(BuildContext context, bool isCheckIn) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          if (isCheckIn) {
            checkInDate = DateTime(
              picked.year,
              picked.month,
              picked.day,
              time.hour,
              time.minute,
            );
          } else {
            checkOutDate = DateTime(
              picked.year,
              picked.month,
              picked.day,
              time.hour,
              time.minute,
            );
          }
        });
      }
    }
  }

  // Add Button
  void addIncome() {
    if (guestNameController.text.isEmpty ||
        selectedNights == null ||
        selectedApp == null ||
        checkInDate == null ||
        checkOutDate == null ||
        priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields")),
      );
      return;
    }

    final income = {
      "guestName": guestNameController.text,
      "nights": selectedNights,
      "appBooked": selectedApp,
      "checkInDate": checkInDate,
      "checkOutDate": checkOutDate,
      "price": double.tryParse(priceController.text) ?? 0,
    };

    widget.onAddIncome(income);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Income"),
        backgroundColor: const Color.fromARGB(255, 181, 190, 197),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Guest Name Text Field
            TextField(
              controller: guestNameController,
              decoration: InputDecoration(
                labelText: "Guest Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Row for "Nights" and "App Booked" dropdowns
            Row(
              children: [
                // Nights Dropdown
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: selectedNights,
                    hint: const Text("Select Nights"),
                    items: nightsList.map((n) {
                      return DropdownMenuItem<int>(
                        value: n,
                        child: Text(n.toString()),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() {
                      selectedNights = value;
                    }),
                    decoration: InputDecoration(
                      labelText: "Nights",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Space between the two dropdowns

                // App Booked Dropdown
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedApp,
                    hint: const Text("Select App Booked"),
                    items: appList.map((app) {
                      return DropdownMenuItem<String>(
                        value: app,
                        child: Text(app),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() {
                      selectedApp = value;
                    }),
                    decoration: InputDecoration(
                      labelText: "App Booked",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Check-in Date Picker
            GestureDetector(
              onTap: () => selectDateTime(context, true),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: checkInDate == null
                        ? "Date Check In"
                        : "${checkInDate!.toLocal()}".split(' ')[0],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Check-out Date Picker
            GestureDetector(
              onTap: () => selectDateTime(context, false),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: checkOutDate == null
                        ? "Date Check Out"
                        : "${checkOutDate!.toLocal()}".split(' ')[0],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Price Input Field
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Price",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Add Button
            Center(
              child: ElevatedButton(
                onPressed: addIncome,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 181, 190, 197),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text("Add"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
