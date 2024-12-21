import 'package:flutter/material.dart';

class AddExpensePage extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddOutcome;

  const AddExpensePage({super.key, required this.onAddOutcome});

  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String? selectedAmount;
  String? selectedTypeProduct;
  DateTime? selectedDateTime;

  final List<String> amountList =
      List<String>.generate(100, (index) => (index + 1).toString());
  final List<String> typeProductList = [
    "Main Product",
    "Adding Product",
    "Service"
  ];

  Future<void> _pickDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _submitData() {
    // Validate if all required fields are filled
    if (_nameController.text.isEmpty ||
        selectedAmount == null ||
        selectedTypeProduct == null ||
        selectedDateTime == null ||
        _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    // Convert price to double
    double price = double.tryParse(_priceController.text.trim()) ?? 0.0;

    // Create outcome data
    final outcome = {
      'name': _nameController.text.trim(),
      'amount': selectedAmount,
      'type': selectedTypeProduct,
      'date': selectedDateTime.toString().split(' ')[0], // Format date to YYYY-MM-DD
      'price': price, // Store price as double
    };

    // Pass data back to the previous screen
    Navigator.pop(context, outcome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        backgroundColor: const Color.fromARGB(255, 181, 190, 197),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name Product
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name Product',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Row for Amount and Type Product
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      value: selectedAmount,
                      items: amountList
                          .map((amount) => DropdownMenuItem(
                                value: amount,
                                child: Text(amount),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedAmount = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Type Product',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      value: selectedTypeProduct,
                      items: typeProductList
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedTypeProduct = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Date Buy Picker
              GestureDetector(
                onTap: _pickDateTime,
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: selectedDateTime == null
                          ? "Pick Date and Time"
                          : "${"${selectedDateTime!.toLocal()}".split(' ')[0]} ${selectedDateTime!.hour}:${selectedDateTime!.minute}",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Notes
              TextField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Price
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 181, 190, 197),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                  ),
                  child: const Text('Add'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
