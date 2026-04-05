import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/local_storage_service.dart';

class TransactionViewModel extends ChangeNotifier {
  final List<TransactionModel> _transactions = [];
  final LocalStorageService _storage = LocalStorageService();

  List<TransactionModel> get transactions => _transactions;

  Future<void> loadTransactions() async {
    final data = await _storage.loadTransactions();
    _transactions.clear();
    _transactions.addAll(data);
    notifyListeners();
  }

  double get totalIncome => _transactions
      .where((t) => t.type == 'income')
      .fold(0, (sum, item) => sum + item.amount);

  double get totalExpense => _transactions
      .where((t) => t.type == 'expense')
      .fold(0, (sum, item) => sum + item.amount);

  double get balance => totalIncome - totalExpense;

  Future<void> addTransaction(TransactionModel transaction) async {
    _transactions.add(transaction);
    await _storage.saveTransactions(_transactions);
    notifyListeners();
  }

  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((t) => t.id == id);
    await _storage.saveTransactions(_transactions);
    notifyListeners();
  }

  Future<void> updateTransaction(
      String id, TransactionModel updated) async {
    final index = _transactions.indexWhere((t) => t.id == id);

    if (index != -1) {
      _transactions[index] = updated;
      await _storage.saveTransactions(_transactions);
      notifyListeners();
    }
  }
}