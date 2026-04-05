import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/transaction_viewmodel.dart';
import '../models/transaction_model.dart';
import 'add_transaction_screen.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() =>
      _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  String searchQuery = "";
  String filterType = "all";

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TransactionViewModel>(context);

    final filteredList = vm.transactions.where((t) {
      final matchesSearch =
          t.category.toLowerCase().contains(searchQuery.toLowerCase()) ||
              t.note.toLowerCase().contains(searchQuery.toLowerCase()) ||
              t.type.toLowerCase().contains(searchQuery.toLowerCase());

      final matchesFilter =
      filterType == "all" ? true : t.type == filterType;

      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "FinTrack",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Column(
        children: [


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search transactions...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() => searchQuery = value);
              },
            ),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _filterChip("All", "all"),
              _filterChip("Income", "income"),
              _filterChip("Expense", "expense"),
            ],
          ),

          const SizedBox(height: 10),

          Expanded(
            child: filteredList.isEmpty
                ? const Center(
              child: Text(
                "No matching transactions ",
                style: TextStyle(color: Colors.grey),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final t = filteredList[index];
                final isIncome = t.type == "income";

                return Dismissible(
                  key: Key(t.id),
                  direction: DismissDirection.endToStart,

                  onDismissed: (_) {
                    final deleted = t;
                    vm.deleteTransaction(t.id);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Transaction deleted"),
                        action: SnackBarAction(
                          label: "UNDO",
                          onPressed: () {
                            vm.addTransaction(deleted);
                          },
                        ),
                      ),
                    );
                  },

                  background: Container(
                    margin:
                    const EdgeInsets.symmetric(vertical: 6),
                    padding:
                    const EdgeInsets.only(right: 20),
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius:
                      BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.delete,
                        color: Colors.white),
                  ),

                  child: Container(
                    margin:
                    const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color:
                          Colors.grey.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),

                    child: Row(
                      children: [

                        Container(
                          padding:
                          const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isIncome
                                ? Colors.green
                                .withOpacity(0.1)
                                : Colors.red
                                .withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isIncome
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: isIncome
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.category,
                                style:
                                const TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                t.note.isEmpty
                                    ? t.type
                                    : t.note,
                                style:
                                const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "₹${t.amount}",
                              style: TextStyle(
                                color: isIncome
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            const SizedBox(width: 6),

                            IconButton(
                              icon: const Icon(Icons.edit,
                                  size: 20),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        AddTransactionScreen(
                                          existingTransaction: t,
                                        ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String value) {
    final isSelected = filterType == value;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: Colors.deepPurple,
        onSelected: (_) {
          setState(() {
            filterType = value;
          });
        },
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}