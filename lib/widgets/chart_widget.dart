import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class ChartWidget extends StatelessWidget {
  final List<TransactionModel> transactions;

  const ChartWidget({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    double totalExpense = transactions
        .where((t) => t.type == "expense")
        .fold(0, (sum, item) => sum + item.amount);

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: totalExpense,
              title: "Expense",
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}