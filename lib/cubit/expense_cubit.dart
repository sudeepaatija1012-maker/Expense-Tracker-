import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseCubit extends Cubit<List<Expense>> {
  ExpenseCubit() : super([]) {
    _loadExpense();
  }

  void addExpense(Expense expense) {
    if (expense.amount.isEmpty) {
      emitError("Enter Amount");
      return;
    } else if (expense.category.isEmpty) {
      emitError("Category is Empty");
      return;
    }
    emit([...state, expense]);
    _saveExpense();
  }

  void removeExpense(Expense expense) {
    emit(state.where((e) => e != expense).toList());
    _saveExpense();
  }

  void emitError(String message) {
    if (kDebugMode) {
      print(message);
    }
  }

  Future<void> _saveExpense() async {
    final expenseJson = jsonEncode(state.map((e) => e.toJson()).toList());
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('expense', expenseJson);
  }

  Future<void> _loadExpense() async {
    final prefs = await SharedPreferences.getInstance();
    final expenseJson = prefs.getString('expense');
    if (expenseJson != null) {
      final List<dynamic> expenseList = jsonDecode(expenseJson);
      final expense = expenseList.map((e) => Expense.fromJson(e)).toList();
      emit(expense);
    }
  }
}
