import 'package:expense_tracker/cubit/expense_cubit.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/utils/expense_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _ExpenseSearchPageState();
}

class _ExpenseSearchPageState extends State<SearchPage> {
  final TextEditingController _searchcontroller = TextEditingController();
  List<Expense> _allExpenses = [];
  List<Expense> _filteredExpenses = [];

  @override
  void initState() {
    super.initState();
    final expenses = context.read<ExpenseCubit>().state;
    _allExpenses = expenses;
    _filteredExpenses = expenses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Text(
            'S E A R C H  P A G E',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 25.0,
            ),
            child: TextField(
              controller: _searchcontroller,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search',
                hintStyle: TextStyle(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  _filteredExpenses =
                      _allExpenses
                          .where(
                            (e) => e.description.toLowerCase().contains(
                              query.toLowerCase(),
                            ),
                          )
                          .toList();
                });
              },
            ),
          ),
          Expanded(
            child:
                _filteredExpenses.isEmpty
                    ? Center(
                      child: Text(
                        'No matching expenses.',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                    : ListView.builder(
                      itemCount: _filteredExpenses.length,
                      itemBuilder: (context, index) {
                        final e = _filteredExpenses[index];
                        return ExpenseCard(
                          number: index + 1,
                          amount: e.amount,
                          date: e.date.toIso8601String(),
                          category: e.category,
                          description: e.description,
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
