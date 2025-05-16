import 'package:courier_app/deliver_screen.dart';
import 'package:flutter/material.dart';
import 'package:courier_app/custom_button.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key, required this.changeScreen});
  final void Function(Widget) changeScreen;

  @override
  State<StatefulWidget> createState() {
    return _BalanceScreenState();
  }
}

class _BalanceScreenState extends State<BalanceScreen> {
  // Mock balance value
  double _balance = 125.50;
  
  // Controller for deposit/withdraw amount
  final TextEditingController _amountController = TextEditingController();
  
  // Focus node for the text field
  final FocusNode _amountFocusNode = FocusNode();
  
  // Transaction history (mock data)
  final List<Map<String, dynamic>> _transactions = [
    {
      'type': 'Deposit',
      'amount': 50.00,
      'date': '2025-05-14',
    },
    {
      'type': 'Earning',
      'amount': 85.50,
      'date': '2025-05-12',
    },
    {
      'type': 'Withdraw',
      'amount': -10.00,
      'date': '2025-05-10',
    },
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  void _deposit() {
    _processTransaction('Deposit');
  }

  void _withdraw() {
    _processTransaction('Withdraw');
  }

  void _processTransaction(String type) {
    if (_amountController.text.isEmpty) {
      _showErrorSnackBar('Please enter an amount');
      return;
    }

    try {
      double amount = double.parse(_amountController.text);
      
      if (amount <= 0) {
        _showErrorSnackBar('Please enter a positive amount');
        return;
      }
      
      if (type == 'Withdraw' && amount > _balance) {
        _showErrorSnackBar('Insufficient balance');
        return;
      }

      setState(() {
        _balance += type == 'Deposit' ? amount : -amount;
        
        _transactions.insert(0, {
          'type': type,
          'amount': type == 'Deposit' ? amount : -amount,
          'date': DateTime.now().toString().substring(0, 10),
        });
        
        _amountController.clear();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$type successful'),
            backgroundColor: Colors.green,
          ),
        );
      });
    } catch (e) {
      _showErrorSnackBar('Invalid amount');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Balance'),
        backgroundColor: const Color.fromARGB(255, 231, 182, 182),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => widget.changeScreen(DeliverScreen(changeScreen: widget.changeScreen)),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 228, 208, 208),
              Color.fromARGB(255, 231, 182, 182),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Balance Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Current Balance',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '\$${_balance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            
            // Amount Input Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _amountController,
                focusNode: _amountFocusNode,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  hintText: 'Enter amount',
                  prefixText: '\$ ',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            
            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CustomButton(
                      'Deposit',
                      _deposit,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      'Withdraw',
                      _withdraw,
                    ),
                  ),
                ],
              ),
            ),
            
            // Transaction History
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Transaction History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = _transactions[index];
                          final bool isDeposit = transaction['amount'] > 0;
                          
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: Icon(
                                isDeposit ? Icons.arrow_downward : Icons.arrow_upward,
                                color: isDeposit ? Colors.green : Colors.red,
                              ),
                              title: Text(transaction['type']),
                              subtitle: Text(transaction['date']),
                              trailing: Text(
                                '\$${transaction['amount'].abs().toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isDeposit ? Colors.green : Colors.red,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}