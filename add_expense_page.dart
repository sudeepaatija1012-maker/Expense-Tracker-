import 'package:expense_tracker/cubit/expense_cubit.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final List<String> category = ['Food', 'Transport', 'Bills', 'Shopping'];
  String? selectedCategory;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Text(
            'A D D  E X P E N S E',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                prefixIcon: Icon(Icons.currency_rupee),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                prefixIcon: Icon(Icons.abc),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 60,

              child: DropdownButtonFormField<String>(
                hint: Text('Select Category'),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.wallet),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                initialValue: selectedCategory,
                items:
                    category.map((String categories) {
                      return DropdownMenuItem<String>(
                        value: categories,
                        child: Text(categories),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 80,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Colors.transparent,
                  ),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  padding: WidgetStateProperty.all(EdgeInsets.zero),
                ),
                onPressed: () {
                  final amountText = _amountController.text.trim();
                  final descriptionText = _descriptionController.text.trim();
                  if (selectedCategory == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please select a Category')),
                    );
                  } else if (amountText.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter the Amount.')),
                    );
                  } else if (descriptionText.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a Description.')),
                    );
                  } else {
                    final newExpense = Expense(
                      amount: amountText,
                      description: descriptionText,
                      category: selectedCategory!,
                      date: DateTime.now(),
                    );
                    BlocProvider.of<ExpenseCubit>(
                      context,
                    ).addExpense(newExpense);
                    Navigator.pop(context);
                  }
                },
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 33, 229, 243).withAlpha(100),
                        const Color.fromARGB(255, 14, 196, 246).withAlpha(100),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(color: const Color.fromARGB(255, 196, 51, 209)),
                    ],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    height: 80,
                    // width:
                    child: Text(
                      'Add Expense',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
