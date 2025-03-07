import 'package:cashu_app/ui/home/widgets/recent_transactions/empty_transactions_list.dart';
import 'package:cashu_app/ui/home/widgets/recent_transactions/transaction_list_item.dart';
import 'package:flutter/material.dart';

enum TransactionType { sent, received }

class TransactionItem {
  final TransactionType type;
  final int amount;
  final DateTime date;
  final String description;

  TransactionItem({
    required this.type,
    required this.amount,
    required this.date,
    required this.description,
  });
}

class RecentTransactionsWidget extends StatelessWidget {
  const RecentTransactionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for recent transactions
    final transactions = [
      TransactionItem(
        type: TransactionType.received,
        amount: 1000,
        date: DateTime.now().subtract(const Duration(hours: 2)),
        description: 'Received from friend',
      ),
      TransactionItem(
        type: TransactionType.sent,
        amount: 500,
        date: DateTime.now().subtract(const Duration(days: 1)),
        description: 'Coffee payment',
      ),
      TransactionItem(
        type: TransactionType.received,
        amount: 2500,
        date: DateTime.now().subtract(const Duration(days: 2)),
        description: 'Work payment',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to transaction history
              },
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        transactions.isEmpty
            ? const EmptyTransactionsList()
            : ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: transactions.length,
                shrinkWrap: true,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return TransactionListItem(transaction: transaction);
                },
              ),
      ],
    );
  }
}
