import 'package:expense_tracker/cubit/expense_cubit.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/pages/add_expense_page.dart';
import 'package:expense_tracker/pages/search_page.dart';
import 'package:expense_tracker/utils/expense_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> filters = const [
    'All',
    'Food',
    'Transport',
    'Bills',
    'Shopping',
  ];
  late String selectedState;

  @override
  void initState() {
    super.initState();
    selectedState = filters[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 280,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(color: const Color.fromARGB(255, 196, 51, 209)),
                ],
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 33, 229, 243).withAlpha(100),
                    const Color.fromARGB(255, 14, 196, 246).withAlpha(100),
                  ],
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(40.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Expense Tracker',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                              color: Colors.white,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchPage(),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Total',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    BlocBuilder<ExpenseCubit, List<Expense>>(
                      builder: (context, expenses) {
                        final filteredExpenses =
                            selectedState == 'All'
                                ? expenses
                                : expenses
                                    .where((e) => e.category == selectedState)
                                    .toList();
                        if (filteredExpenses.isEmpty) {
                          return Text(
                            '0',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                        final totalAmount = filteredExpenses.fold<double>(
                          0.0,
                          (sum, expense) =>
                              sum + (double.tryParse(expense.amount) ?? 0.0),
                        );
                        return Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.currency_rupee_sharp,
                                color: Colors.white,
                                size: 40,
                              ),
                              SizedBox(width: 8),
                              Text(
                                totalAmount.toStringAsFixed(2),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 80,
            child: ListView.builder(
              itemCount: filters.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final filter = filters[index];
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedState = filter;
                      });
                    },
                    child: Chip(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor:
                          selectedState == filter
                              ? Colors.amber
                              : const Color.fromARGB(106, 158, 158, 158),
                      label: Text(filter),
                      labelStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<ExpenseCubit, List<Expense>>(
              builder: (context, expenses) {
                final filteredExpenses =
                    selectedState == 'All'
                        ? expenses
                        : expenses
                            .where(
                              (expense) => expense.category == selectedState,
                            )
                            .toList();
                if (filteredExpenses.isEmpty) {
                  return Column(
                    children: [
                      Image.asset(
                        "assets/images/no_data_image.png",
                        height: 175,
                        width: 175,
                      ),
                      SizedBox(height: 25),
                      Text(
                        'No expenses yet. Start tracking your spending!',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  );
                }
                return ListView.builder(
                  itemCount: filteredExpenses.length,
                  itemBuilder: (context, index) {
                    final expense = filteredExpenses[index];
                    return Dismissible(
                      key: Key(expense.amount),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        height: 20,
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        context.read<ExpenseCubit>().removeExpense(expense);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Expense "${index + 1}" deleted'),
                          ),
                        );
                      },
                      child: ExpenseCard(
                        number: index + 1,
                        amount: expense.amount,
                        date: expense.date.toIso8601String(),
                        category: expense.category,
                        description: expense.description,

                        onDelete: () {
                          context.read<ExpenseCubit>().removeExpense(expense);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Expense "${index + 1}" deleted'),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddExpensePage()),
          );
        },
        backgroundColor: Colors.transparent,
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.amber,
          ),
          alignment: Alignment.center,
          child: Text('+', style: TextStyle(fontSize: 30, color: Colors.white)),
        ),
      ),
    );
  }
}
