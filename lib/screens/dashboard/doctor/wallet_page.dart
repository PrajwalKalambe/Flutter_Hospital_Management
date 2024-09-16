import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  double balance = 0.0;
  List<Transaction> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWalletData();
  }

  Future<void> fetchWalletData() async {
    // Replace with your actual API endpoint
    final response = await http.get(Uri.parse('https://your-api-endpoint.com/wallet'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        balance = data['balance'].toDouble();
        transactions = (data['transactions'] as List)
            .map((item) => Transaction.fromJson(item))
            .toList();
        isLoading = false;
      });
    } else {
      // Handle error
      print('Failed to load wallet data');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                BalanceCard(balance: balance),
                Expanded(
                  child: TransactionList(transactions: transactions),
                ),
              ],
            ),
    );
  }
}

class BalanceCard extends StatelessWidget {
  final double balance;

  const BalanceCard({Key? key, required this.balance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Main Balance',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.account_balance_wallet, color: Colors.teal),
              ),
              SizedBox(width: 12),
              Text(
                '\$ ${balance.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionList({Key? key, required this.transactions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return ListTile(
          leading: Icon(Icons.arrow_downward, color: Colors.green),
          title: Text('Receive'),
          subtitle: Text(transaction.date),
          trailing: Text(
            '\$${transaction.amount.toStringAsFixed(2)}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}

class Transaction {
  final String date;
  final double amount;

  Transaction({required this.date, required this.amount});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      date: json['date'],
      amount: json['amount'].toDouble(),
    );
  }
}