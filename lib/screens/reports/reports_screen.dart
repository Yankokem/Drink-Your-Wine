import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../widgets/compact_side_bar.dart';
import '../../widgets/page_header.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedReport = 'sales'; // 'sales', 'inventory', 'employees'
  String _salesType = 'internal'; // 'internal', 'external'
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    // Set default dates to today
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, now.day);
    _endDate = now;
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        // If end date is before start date, adjust it
        if (_endDate != null && _endDate!.isBefore(picked)) {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _exportReport() {
    // TODO: Implement export functionality (CSV, PDF, etc.)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exporting report...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Row(
        children: [
          const CompactSideBar(currentRoute: '/reports'),
          Expanded(
            child: Column(
              children: [
                // Page Header
                const PageHeader(title: 'Reports'),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Report Type Selector & Date Filter
                        Row(
                          children: [
                            // Report Type Buttons
                            Expanded(
                              child: Row(
                                children: [
                                  _ReportTypeButton(
                                    label: 'Sales Report',
                                    icon: Icons.trending_up,
                                    isSelected: _selectedReport == 'sales',
                                    onTap: () => setState(() {
                                      _selectedReport = 'sales';
                                    }),
                                  ),
                                  const SizedBox(width: 12),
                                  _ReportTypeButton(
                                    label: 'Inventory Report',
                                    icon: Icons.inventory_2,
                                    isSelected: _selectedReport == 'inventory',
                                    onTap: () => setState(() {
                                      _selectedReport = 'inventory';
                                    }),
                                  ),
                                  const SizedBox(width: 12),
                                  _ReportTypeButton(
                                    label: 'Employee Report',
                                    icon: Icons.people,
                                    isSelected: _selectedReport == 'employees',
                                    onTap: () => setState(() {
                                      _selectedReport = 'employees';
                                    }),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),

                            // Date Filter - Only for Sales and Employee reports
                            if (_selectedReport != 'inventory') ...[
                              // Start Date
                              OutlinedButton.icon(
                                onPressed: _selectStartDate,
                                icon:
                                    const Icon(Icons.calendar_today, size: 18),
                                label: Text(
                                  _startDate != null
                                      ? DateFormat('MMM d, yyyy')
                                          .format(_startDate!)
                                      : 'Start Date',
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor:
                                      Theme.of(context).primaryColor,
                                  side: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text('to',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                              const SizedBox(width: 8),
                              // End Date
                              OutlinedButton.icon(
                                onPressed: _selectEndDate,
                                icon:
                                    const Icon(Icons.calendar_today, size: 18),
                                label: Text(
                                  _endDate != null
                                      ? DateFormat('MMM d, yyyy')
                                          .format(_endDate!)
                                      : 'End Date',
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor:
                                      Theme.of(context).primaryColor,
                                  side: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                            ],

                            ElevatedButton.icon(
                              onPressed: _exportReport,
                              icon: const Icon(Icons.file_download, size: 20),
                              label: const Text('Export'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Sales Type Toggle (only for sales report)
                        if (_selectedReport == 'sales') ...[
                          Row(
                            children: [
                              _SalesTypeButton(
                                label: 'Internal Sales',
                                isSelected: _salesType == 'internal',
                                onTap: () => setState(() {
                                  _salesType = 'internal';
                                }),
                              ),
                              const SizedBox(width: 12),
                              _SalesTypeButton(
                                label: 'External Sales',
                                isSelected: _salesType == 'external',
                                onTap: () => setState(() {
                                  _salesType = 'external';
                                }),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Summary Cards (different for each report type)
                        if (_selectedReport == 'sales') ...[
                          _buildSalesSummaryCards(),
                          const SizedBox(height: 24),
                          _buildSalesTable(),
                        ] else if (_selectedReport == 'inventory') ...[
                          _buildInventorySummaryCards(),
                          const SizedBox(height: 24),
                          _buildInventoryTable(isDarkMode),
                        ] else if (_selectedReport == 'employees') ...[
                          _buildEmployeeSummaryCards(),
                          const SizedBox(height: 24),
                          _buildEmployeeTable(),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: _salesType == 'internal'
                ? 'Total Sales'
                : 'Total Sales (50% Off)',
            value: _salesType == 'internal' ? '₱45,280.00' : '₱22,640.00',
            icon: Icons.attach_money,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: _StatCard(
            title: 'Total Orders',
            value: '187',
            icon: Icons.receipt_long,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            title: 'Average Order',
            value: _salesType == 'internal' ? '₱242.14' : '₱121.07',
            icon: Icons.shopping_cart,
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: _StatCard(
            title: 'Total Items Sold',
            value: '524',
            icon: Icons.inventory,
            color: Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildSalesTable() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sales Transactions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1.5),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(1.5),
                3: FlexColumnWidth(1.5),
                4: FlexColumnWidth(1.5),
                5: FlexColumnWidth(1),
              },
              border: TableBorder.symmetric(
                inside: BorderSide(color: Colors.grey.shade200),
              ),
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                  ),
                  children: const [
                    _TableHeader('Date & Time'),
                    _TableHeader('Transaction ID'),
                    _TableHeader('Cashier'),
                    _TableHeader('Items'),
                    _TableHeader('Amount'),
                    _TableHeader('Payment'),
                  ],
                ),
                _buildSalesRow(
                    'Nov 4, 2:45 PM',
                    '#2025110400048',
                    'John Doe',
                    '3',
                    _salesType == 'internal' ? '₱450.00' : '₱225.00',
                    'Cash'),
                _buildSalesRow(
                    'Nov 4, 2:30 PM',
                    '#2025110400047',
                    'Jane Smith',
                    '5',
                    _salesType == 'internal' ? '₱680.00' : '₱340.00',
                    'Card'),
                _buildSalesRow(
                    'Nov 4, 2:15 PM',
                    '#2025110400046',
                    'John Doe',
                    '2',
                    _salesType == 'internal' ? '₱280.00' : '₱140.00',
                    'Cash'),
                _buildSalesRow(
                    'Nov 4, 1:50 PM',
                    '#2025110400045',
                    'Alice Johnson',
                    '4',
                    _salesType == 'internal' ? '₱520.00' : '₱260.00',
                    'GCash'),
                _buildSalesRow(
                    'Nov 4, 1:35 PM',
                    '#2025110400044',
                    'John Doe',
                    '6',
                    _salesType == 'internal' ? '₱890.00' : '₱445.00',
                    'Card'),
                _buildSalesRow(
                    'Nov 4, 1:20 PM',
                    '#2025110400043',
                    'Jane Smith',
                    '3',
                    _salesType == 'internal' ? '₱420.00' : '₱210.00',
                    'Cash'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildSalesRow(String date, String id, String cashier, String items,
      String amount, String payment) {
    return TableRow(
      children: [
        _TableCell(date),
        _TableCell(id),
        _TableCell(cashier),
        _TableCell(items),
        _TableCell(amount, fontWeight: FontWeight.bold),
        _TableCell(payment),
      ],
    );
  }

  Widget _buildInventorySummaryCards() {
    return const Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Total Products',
            value: '156',
            icon: Icons.inventory_2,
            color: Colors.blue,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            title: 'Low Stock Items',
            value: '8',
            icon: Icons.warning_amber,
            color: Colors.orange,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            title: 'Out of Stock',
            value: '3',
            icon: Icons.remove_circle,
            color: Colors.red,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            title: 'Total Value',
            value: '₱128,450',
            icon: Icons.attach_money,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryTable(bool isDarkMode) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Inventory Status',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2.5),
                1: FlexColumnWidth(1.5),
                2: FlexColumnWidth(1.2),
                3: FlexColumnWidth(1.5),
                4: FlexColumnWidth(1.2),
              },
              border: TableBorder.symmetric(
                inside: BorderSide(color: Colors.grey.shade200),
              ),
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                  ),
                  children: const [
                    _TableHeader('Product Name'),
                    _TableHeader('Category'),
                    _TableHeader('Stock (pcs)'),
                    _TableHeader('Price'),
                    _TableHeader('Status'),
                  ],
                ),
                _buildInventoryRow('Espresso Beans', 'Coffee', '25', '₱850.00',
                    'Low', Colors.orange, isDarkMode),
                _buildInventoryRow('Arabica Beans', 'Coffee', '150',
                    '₱1,200.00', 'In Stock', Colors.green, isDarkMode),
                _buildInventoryRow('Whole Milk', 'Dairy', '50', '₱280.00',
                    'Low', Colors.orange, isDarkMode),
                _buildInventoryRow('Sugar', 'Supplies', '10', '₱85.00', 'Low',
                    Colors.orange, isDarkMode),
                _buildInventoryRow('Paper Cups (M)', 'Packaging', '0', '₱2.50',
                    'Out', Colors.red, isDarkMode),
                _buildInventoryRow('Chocolate Syrup', 'Flavors', '80',
                    '₱320.00', 'In Stock', Colors.green, isDarkMode),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildInventoryRow(String name, String category, String stock,
      String price, String status, Color statusColor, bool isDarkMode) {
    return TableRow(
      children: [
        _TableCell(name),
        _TableCell(category),
        _TableCell(stock, fontWeight: FontWeight.bold),
        _TableCell(price),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeSummaryCards() {
    return const Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Total Employees',
            value: '24',
            icon: Icons.people,
            color: Colors.blue,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            title: 'Total Sales',
            value: '₱45,280',
            icon: Icons.trending_up,
            color: Colors.green,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            title: 'Avg. Sales/Employee',
            value: '₱1,887',
            icon: Icons.person,
            color: Colors.orange,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            title: 'Total Hours',
            value: '192',
            icon: Icons.access_time,
            color: Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeTable() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Employee Performance',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1.5),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1.5),
                4: FlexColumnWidth(1),
              },
              border: TableBorder.symmetric(
                inside: BorderSide(color: Colors.grey.shade200),
              ),
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                  ),
                  children: const [
                    _TableHeader('Employee Name'),
                    _TableHeader('Position'),
                    _TableHeader('Orders'),
                    _TableHeader('Total Sales'),
                    _TableHeader('Hours'),
                  ],
                ),
                _buildEmployeeRow(
                    'John Doe', 'Cashier', '45', '₱12,450.00', '8.5'),
                _buildEmployeeRow(
                    'Jane Smith', 'Barista', '38', '₱9,680.00', '8.0'),
                _buildEmployeeRow(
                    'Alice Johnson', 'Server', '32', '₱7,280.00', '7.5'),
                _buildEmployeeRow(
                    'Bob Wilson', 'Cashier', '28', '₱6,520.00', '8.0'),
                _buildEmployeeRow(
                    'Carol Brown', 'Barista', '24', '₱5,890.00', '6.5'),
                _buildEmployeeRow(
                    'Dave Miller', 'Server', '20', '₱3,460.00', '6.0'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildEmployeeRow(
      String name, String position, String orders, String sales, String hours) {
    return TableRow(
      children: [
        _TableCell(name),
        _TableCell(position),
        _TableCell(orders),
        _TableCell(sales, fontWeight: FontWeight.bold),
        _TableCell(hours),
      ],
    );
  }
}

class _ReportTypeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ReportTypeButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade100,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey.shade700,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SalesTypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SalesTypeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor:
            isSelected ? Colors.white : Theme.of(context).primaryColor,
        backgroundColor:
            isSelected ? Theme.of(context).primaryColor : Colors.transparent,
        side: BorderSide(color: Theme.of(context).primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(label),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String text;

  const _TableHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;

  const _TableCell(this.text, {this.fontWeight = FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
