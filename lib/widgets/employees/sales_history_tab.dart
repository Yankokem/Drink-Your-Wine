import 'package:flutter/material.dart';

class SalesHistoryTab extends StatefulWidget {
  final Map<String, dynamic> employeeData;

  const SalesHistoryTab({
    super.key,
    required this.employeeData,
  });

  @override
  State<SalesHistoryTab> createState() => _SalesHistoryTabState();
}

class _SalesHistoryTabState extends State<SalesHistoryTab> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sample sales data
    final sales = [
      {
        'order_no': '#0048',
        'date': '2024-11-06',
        'time': '10:30 AM',
        'items': '3 items',
        'type': 'Grab',
        'payment_method': 'Cash',
        'amount': 450.00,
        'amount_received': 500.00,
        'change': 50.00,
      },
      {
        'order_no': '#0052',
        'date': '2024-11-06',
        'time': '01:45 PM',
        'items': '5 items',
        'type': 'Foodpanda',
        'payment_method': 'GCash',
        'amount': 680.00,
        'amount_received': 680.00,
        'change': 0.00,
      },
      {
        'order_no': '#0065',
        'date': '2024-11-05',
        'time': '11:20 AM',
        'items': '2 items',
        'type': 'Walk-in',
        'payment_method': 'Cash',
        'amount': 280.00,
        'amount_received': 300.00,
        'change': 20.00,
      },
      {
        'order_no': '#0078',
        'date': '2024-11-05',
        'time': '03:15 PM',
        'items': '4 items',
        'type': 'Grab',
        'payment_method': 'Maya',
        'amount': 520.00,
        'amount_received': 520.00,
        'change': 0.00,
      },
      {
        'order_no': '#0089',
        'date': '2024-11-04',
        'time': '09:45 AM',
        'items': '6 items',
        'type': 'Walk-in',
        'payment_method': 'Cash',
        'amount': 890.00,
        'amount_received': 1000.00,
        'change': 110.00,
      },
    ];

    final totalSales = sales.fold<double>(
      0.0,
      (sum, sale) => sum + (sale['amount'] as double),
    );

    final totalItems = sales.fold<int>(
      0,
      (sum, sale) {
        final itemsStr = sale['items'] as String;
        final itemCount = int.tryParse(itemsStr.split(' ')[0]) ?? 0;
        return sum + itemCount;
      },
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.receipt_long,
                  color: Theme.of(context).primaryColor,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sales History',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'All sales handled by ${widget.employeeData['first_name']} ${widget.employeeData['last_name']}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Date filter
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 8),
                      Text(
                          '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}'),
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Stats Cards
          Row(
            children: [
              _SalesStatCard(
                title: 'Total Sales',
                count: '₱${totalSales.toStringAsFixed(2)}',
                color: Colors.green,
                icon: Icons.trending_up,
              ),
              const SizedBox(width: 16),
              _SalesStatCard(
                title: 'Total Items Sold',
                count: totalItems.toString(),
                color: Colors.blue,
                icon: Icons.shopping_bag,
              ),
              const SizedBox(width: 16),
              _SalesStatCard(
                title: 'Total Orders Handled',
                count: sales.length.toString(),
                color: Colors.orange,
                icon: Icons.receipt,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Sales Table
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // Table Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Order No.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Date & Time',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Items',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Type',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Payment',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Amount',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Amt Received',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Change',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Table Content
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sales.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: Colors.grey.shade200,
                  ),
                  itemBuilder: (context, index) {
                    final sale = sales[index];
                    return _SaleRow(
                      orderNo: sale['order_no'] as String,
                      date: sale['date'] as String,
                      time: sale['time'] as String,
                      items: sale['items'] as String,
                      type: sale['type'] as String,
                      paymentMethod: sale['payment_method'] as String,
                      amount: sale['amount'] as double,
                      amountReceived: sale['amount_received'] as double,
                      change: sale['change'] as double,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SalesStatCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;
  final IconData icon;

  const _SalesStatCard({
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    count,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SaleRow extends StatelessWidget {
  final String orderNo;
  final String date;
  final String time;
  final String items;
  final String type;
  final String paymentMethod;
  final double amount;
  final double amountReceived;
  final double change;

  const _SaleRow({
    required this.orderNo,
    required this.date,
    required this.time,
    required this.items,
    required this.type,
    required this.paymentMethod,
    required this.amount,
    required this.amountReceived,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: Show sale details
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                orderNo,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                items,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                type,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                paymentMethod,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _getPaymentColor(paymentMethod),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '₱${amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '₱${amountReceived.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '₱${change.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPaymentColor(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return Colors.green;
      case 'gcash':
        return Colors.blue;
      case 'maya':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
