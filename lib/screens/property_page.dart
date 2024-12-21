import 'package:flutter/material.dart';
import 'add_income_page.dart';
import 'add_expense_page.dart'; // Import AddExpensePage

class PropertyPage extends StatefulWidget {
  final String propertyName;

  const PropertyPage({super.key, required this.propertyName});

  @override
  State<PropertyPage> createState() => _PropertyPageState();
}

class _PropertyPageState extends State<PropertyPage> {
  List<Map<String, dynamic>> incomeList = [];
  List<Map<String, dynamic>> expenseList = [];

  // Add income
  void addIncome(Map<String, dynamic> newIncome) {
    setState(() {
      incomeList.add(newIncome);
    });
  }

  // Add expense
  void addExpense(Map<String, dynamic> newExpense) {
    setState(() {
      expenseList.add(newExpense);
    });
  }

  // Delete income
  void deleteIncome(int index) {
    setState(() {
      incomeList.removeAt(index);
    });
  }

  // Delete expense
  void deleteExpense(int index) {
    setState(() {
      expenseList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Parse the price as double and calculate totals
    double totalIncome = incomeList.fold(0.0, (sum, item) => sum + (item['price'] as double));
    double totalExpense = expenseList.fold(0.0, (sum, item) => sum + (item['price'] as double));
    double netProfit = totalIncome - totalExpense;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.propertyName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // INCOME Section
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.trending_up, color: Colors.green),
                              const SizedBox(width: 8),
                              const Text(
                                "INCOME",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.green),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddIncomePage(
                                    onAddIncome: addIncome,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...incomeList.map((income) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text(income['guestName'] ?? 'No Name'),
                              subtitle: Text(
                                "${income['app'] ?? 'No App'}\n${income['nights']} Nights\n${income['date'] ?? 'No Date'}",
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Rp. ${income['price'].toStringAsFixed(0)}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => deleteIncome(incomeList.indexOf(income)),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                          ],
                        );
                      }).toList(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Total: Rp. ${totalIncome.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // OUTCOME Section
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.trending_down, color: Colors.red),
                              const SizedBox(width: 8),
                              const Text(
                                "OUTCOME",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.red),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddExpensePage(
                                    onAddOutcome: addExpense,
                                  ),
                                ),
                              ).then((newOutcome) {
                                if (newOutcome != null) {
                                  addExpense(newOutcome);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...expenseList.map((expense) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text(expense['name'] ?? 'No Name'),
                              subtitle: Text(
                                "${expense['type'] ?? 'No Type'}\n${expense['date'] ?? 'No Date'}",
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Rp. ${expense['price'].toStringAsFixed(0)}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => deleteExpense(expenseList.indexOf(expense)),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                          ],
                        );
                      }).toList(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Total: Rp. ${totalExpense.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // NET PROFIT Section
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "NET PROFIT",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Rp. ${netProfit.toStringAsFixed(0)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: netProfit >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
