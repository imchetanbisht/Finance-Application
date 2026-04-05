import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_model.dart';

class LocalStorageService {
  static const String key = "transactions";

  Future<void> saveTransactions(List<TransactionModel> list) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> data = list.map((t) => jsonEncode({
      "id": t.id,
      "amount": t.amount,
      "type": t.type,
      "category": t.category,
      "date": t.date.toIso8601String(),
      "note": t.note,
    })).toList();

    await prefs.setStringList(key, data);
  }

  Future<List<TransactionModel>> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(key) ?? [];

    return data.map((item) {
      final json = jsonDecode(item);
      return TransactionModel(
        id: json["id"],
        amount: json["amount"],
        type: json["type"],
        category: json["category"],
        date: DateTime.parse(json["date"]),
        note: json["note"],
      );
    }).toList();
  }
}