import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction_model.dart';
import '../viewmodels/transaction_viewmodel.dart';
import 'package:uuid/uuid.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionModel? existingTransaction;

  const AddTransactionScreen({super.key, this.existingTransaction});

  @override
  State<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  String type = "expense";
  String category = "General";

  final uuid = const Uuid();

  final List<String> categories = [
    "General",
    "Food",
    "Travel",
    "Shopping",
    "Bills",
    "Salary",
    "Other"
  ];

  @override
  void initState() {
    super.initState();

    if (widget.existingTransaction != null) {
      final t = widget.existingTransaction!;
      amountController.text = t.amount.toString();
      noteController.text = t.note;
      type = t.type;
      category = t.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TransactionViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.existingTransaction != null
              ? "Edit Transaction"
              : "Add Transaction",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  children: [


                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Amount",
                        prefixIcon: const Icon(Icons.currency_rupee),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: _typeButton("income", Colors.green),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _typeButton("expense", Colors.red),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    DropdownButtonFormField<String>(
                      value: category,
                      decoration: InputDecoration(
                        labelText: "Category",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: categories.map((c) {
                        return DropdownMenuItem(
                          value: c,
                          child: Text(c),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          category = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: noteController,
                      decoration: InputDecoration(
                        labelText: "Note (Optional)",
                        prefixIcon: const Icon(Icons.note),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),


                    GestureDetector(
                      onTap: () {
                        if (amountController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please enter amount")),
                          );
                          return;
                        }

                        final newTransaction = TransactionModel(
                          id: widget.existingTransaction?.id ??
                              uuid.v4(),
                          amount:
                          double.parse(amountController.text),
                          type: type,
                          category: category,
                          date: DateTime.now(),
                          note: noteController.text,
                        );


                        if (widget.existingTransaction != null) {
                          vm.updateTransaction(
                              widget.existingTransaction!.id,
                              newTransaction);
                        } else {
                          vm.addTransaction(newTransaction);
                        }

                        Navigator.pop(context);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 18),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Colors.deepPurple,
                              Colors.purpleAccent
                            ],
                          ),
                          borderRadius:
                          BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            widget.existingTransaction != null
                                ? "Update Transaction"
                                : "Save Transaction",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _typeButton(String value, Color color) {
    final isSelected = type == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          type = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            value.toUpperCase(),
            style: TextStyle(
              color: isSelected ? Colors.white : color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}