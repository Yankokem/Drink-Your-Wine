import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../widgets/compact_side_bar.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedReport = 'sales'; // 'sales', 'inventory', 'employees'
  DateTimeRange? _dateRange;
  String _selectedPeriod = 'today'; // 'today', 'week', 'month', 'custom'

  @override
  void initState() {
    super.initState();
    _setDateRangeForPeriod('today');
  }

  void _setDateRangeForPeriod(String period) {
    final now = DateTime.now();
    setState(() {
      _selectedPeriod = period;
      switch (period) {
        case 'today':
          _dateRange = DateTimeRange(
            start: DateTime(now.year, now.month, now.day),
            end: now,
          );
          break;
        case 'week':
          _dateRange = DateTimeRange(
            start: now.subtract(const Duration(days: 7)),
            end: now,
          );
          break;
        case 'month':
          _dateRange = DateTimeRange(
            start: DateTime(now.year, now.month, 1),
            end: now,
          );
          break;
        case 'year':
          _dateRange = DateTimeRange(
            start: DateTime(now.year, 1, 1),
            end: now,
          );
          break;
      }
    });
  }

  Future<void> _selectCustomDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
    );
    if (picked != null) {
      setState(() {
        _selectedPeriod = 'custom';
        _dateRange = picked;
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
    return Scaffold(
      body: Row(
        children: [
          const CompactSideBar(currentRoute: '/reports'),
          Expanded(
            child: Column(
              children: [
                // Top Bar
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Reports',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const Spacer(),
                      // Export Button
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
                ),

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
                            // Date Filter
                            Row(
                              children: [
                                _PeriodButton(
                                  label: 'Today',
                                  isSelected: _selectedPeriod == 'today',
                                  onTap: () => _setDateRangeForPeriod('today'),
                                ),
                                const SizedBox(width: 8),
                                _PeriodButton(
                                  label: 'Week',
                                  isSelected: _selectedPeriod == 'week',
                                  onTap: () => _setDateRangeForPeriod('week'),
                                ),
                                const SizedBox(width: 8),
                                _PeriodButton(
                                  label: 'Month',
                                  isSelected: _selectedPeriod == 'month',
                                  onTap: () => _setDateRangeForPeriod('month'),
                                ),
                                const SizedBox(width: 8),
                                _PeriodButton(
                                  label: 'Year',
                                  isSelected: _selectedPeriod == 'year',
                                  onTap: () => _setDateRangeForPeriod('year'),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton.icon(
                                  onPressed: _selectCustomDateRange,
                                  icon: const Icon(Icons.calendar_today,
                                      size: 18),
                                  label: Text(
                                    _selectedPeriod == 'custom' &&
                                            _dateRange != null
                                        ? '${DateFormat('MMM d').format(_dateRange!.start)} - ${DateFormat('MMM d').format(_dateRange!.end)}'
                                        : 'Custom',
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: _selectedPeriod == 'custom'
                                        ? Colors.white
                                        : Theme.of(context).primaryColor,
                                    backgroundColor: _selectedPeriod == 'custom'
                                        ? Theme.of(context).primaryColor
                                        : Colors.transparent,
                                    side: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Summary Cards (different for each report type)
                        if (_selectedReport == 'sales') ...[
                          _buildSalesSummaryCards(),
                          const SizedBox(height: 24),
                          _buildSalesTable(),
                        ] else if (_selectedReport == 'inventory') ...[
                          _buildInventorySummaryCards(),
                          const SizedBox(height: 24),
                          _buildInventoryTable(),
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
    return const Row(
      children: [
        Expanded(
          child: _SummaryCard(
            title: 'Total Sales',
            value: '₱45,280.00',
            icon: Icons.attach_money,
            color: Colors.green,
            subtitle: '+15.3% vs last period',
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _SummaryCard(
            title: 'Total Orders',
            value: '187',
            icon: Icons.receipt_long,
            color: Colors.blue,
            subtitle: '+8.7% vs last period',
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _SummaryCard(
            title: 'Average Order',
            value: '₱242.14',
            icon: Icons.shopping_cart,
            color: Colors.orange,
            subtitle: '+5.2% vs last period',
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _SummaryCard(
            title: 'Total Items Sold',
            value: '524',
            icon: Icons.inventory,
            color: Colors.purple,
            subtitle: '+12.1% vs last period',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sales Transactions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        // Refresh data
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () {
                        // Show filter options
                      },
                    ),
                  ],
                ),
              ],
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
                _buildSalesRow('Nov 4, 2:45 PM', '#2025110400048', 'John Doe',
                    '3', '₱450.00', 'Cash'),
                _buildSalesRow('Nov 4, 2:30 PM', '#2025110400047', 'Jane Smith',
                    '5', '₱680.00', 'Card'),
                _buildSalesRow('Nov 4, 2:15 PM', '#2025110400046', 'John Doe',
                    '2', '₱280.00', 'Cash'),
                _buildSalesRow('Nov 4, 1:50 PM', '#2025110400045',
                    'Alice Johnson', '4', '₱520.00', 'GCash'),
                _buildSalesRow('Nov 4, 1:35 PM', '#2025110400044', 'John Doe',
                    '6', '₱890.00', 'Card'),
                _buildSalesRow('Nov 4, 1:20 PM', '#2025110400043', 'Jane Smith',
                    '3', '₱420.00', 'Cash'),
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
          child: _SummaryCard(
            title: 'Total Products',
            value: '156',
            icon: Icons.inventory_2,
            color: Colors.blue,
            subtitle: '12 categories',
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _SummaryCard(
            title: 'Low Stock Items',
            value: '8',
            icon: Icons.warning_amber,
            color: Colors.orange,
            subtitle: 'Needs attention',
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _SummaryCard(
            title: 'Out of Stock',
            value: '3',
            icon: Icons.remove_circle,
            color: Colors.red,
            subtitle: 'Reorder immediately',
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _SummaryCard(
            title: 'Total Value',
            value: '₱128,450',
            icon: Icons.attach_money,
            color: Colors.green,
            subtitle: 'Inventory worth',
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryTable() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Inventory Status',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1.5),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
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
                    _TableHeader('Product Name'),
                    _TableHeader('Category'),
                    _TableHeader('Stock'),
                    _TableHeader('Unit'),
                    _TableHeader('Price'),
                    _TableHeader('Status'),
                  ],
                ),
                _buildInventoryRow('Espresso Beans', 'Coffee', '2.5', 'kg',
                    '₱850.00', 'Low', Colors.orange),
                _buildInventoryRow('Arabica Beans', 'Coffee', '15', 'kg',
                    '₱1,200.00', 'In Stock', Colors.green),
                _buildInventoryRow('Whole Milk', 'Dairy', '5', 'L', '₱280.00',
                    'Low', Colors.orange),
                _buildInventoryRow('Sugar', 'Supplies', '1', 'kg', '₱85.00',
                    'Low', Colors.orange),
                _buildInventoryRow('Paper Cups (M)', 'Packaging', '0', 'pcs',
                    '₱2.50', 'Out', Colors.red),
                _buildInventoryRow('Chocolate Syrup', 'Flavors', '8', 'btl',
                    '₱320.00', 'In Stock', Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildInventoryRow(String name, String category, String stock,
      String unit, String price, String status, Color statusColor) {
    return TableRow(
      children: [
        _TableCell(name),
        _TableCell(category),
        _TableCell(stock, fontWeight: FontWeight.bold),
        _TableCell(unit),
        _TableCell(price),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeSummaryCards() {
    return const Row(
      children: [
        Expanded(
          child: _SummaryCard(
            title: 'Total Employees',
            value: '24',
            icon: Icons.people,
            color: Colors.blue,
            subtitle: '18 active today',
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _SummaryCard(
            title: 'Total Sales',
            value: '₱45,280',
            icon: Icons.trending_up,
            color: Colors.green,
            subtitle: 'By all employees',
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _SummaryCard(
            title: 'Avg. Sales/Employee',
            value: '₱1,887',
            icon: Icons.person,
            color: Colors.orange,
            subtitle: 'Performance metric',
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _SummaryCard(
            title: 'Total Hours',
            value: '192',
            icon: Icons.access_time,
            color: Colors.purple,
            subtitle: 'Working hours',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Employee Performance',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1.5),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1.5),
                4: FlexColumnWidth(1),
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
                    _TableHeader('Employee Name'),
                    _TableHeader('Position'),
                    _TableHeader('Orders'),
                    _TableHeader('Total Sales'),
                    _TableHeader('Hours'),
                    _TableHeader('Rating'),
                  ],
                ),
                _buildEmployeeRow(
                    'John Doe', 'Cashier', '45', '₱12,450.00', '8.5', '4.8'),
                _buildEmployeeRow(
                    'Jane Smith', 'Barista', '38', '₱9,680.00', '8.0', '4.9'),
                _buildEmployeeRow(
                    'Alice Johnson', 'Server', '32', '₱7,280.00', '7.5', '4.7'),
                _buildEmployeeRow(
                    'Bob Wilson', 'Cashier', '28', '₱6,520.00', '8.0', '4.6'),
                _buildEmployeeRow(
                    'Carol Brown', 'Barista', '24', '₱5,890.00', '6.5', '4.8'),
                _buildEmployeeRow(
                    'Dave Miller', 'Server', '20', '₱3,460.00', '6.0', '4.5'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildEmployeeRow(String name, String position, String orders,
      String sales, String hours, String rating) {
    return TableRow(
      children: [
        _TableCell(name),
        _TableCell(position),
        _TableCell(orders),
        _TableCell(sales, fontWeight: FontWeight.bold),
        _TableCell(hours),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(
                rating,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
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

class _PeriodButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PeriodButton({
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
      ),
      child: Text(label),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String subtitle;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
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
