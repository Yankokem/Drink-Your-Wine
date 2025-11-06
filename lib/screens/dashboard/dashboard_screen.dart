import 'package:flutter/material.dart';

import '../../widgets/compact_side_bar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          const CompactSideBar(currentRoute: '/dashboard'),

          // Main Content
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
                        'Dashboard',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const Spacer(),
                      // Date & Time
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Nov 04, 2025',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
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
                        // Stats Cards
                        const Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                title: 'Today\'s Sales',
                                value: '₱12,450.00',
                                icon: Icons.trending_up,
                                color: Colors.green,
                                percentage: '+12.5%',
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _StatCard(
                                title: 'Orders',
                                value: '48',
                                icon: Icons.receipt_long,
                                color: Colors.blue,
                                percentage: '+8.3%',
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _StatCard(
                                title: 'Customers',
                                value: '32',
                                icon: Icons.people,
                                color: Colors.orange,
                                percentage: '+5.2%',
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _StatCard(
                                title: 'Avg. Order',
                                value: '₱259.38',
                                icon: Icons.attach_money,
                                color: Colors.purple,
                                percentage: '+3.1%',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Quick Actions & Recent Orders
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Quick Actions
                            Expanded(
                              flex: 1,
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Quick Actions',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(height: 16),
                                      _QuickActionButton(
                                        icon: Icons.point_of_sale,
                                        label: 'New Order',
                                        color: Theme.of(context).primaryColor,
                                        onTap: () => Navigator.pushNamed(
                                            context, '/pos'),
                                      ),
                                      const SizedBox(height: 12),
                                      _QuickActionButton(
                                        icon: Icons.add_box,
                                        label: 'Add Product',
                                        color: Colors.green,
                                        onTap: () => Navigator.pushNamed(
                                            context, '/inventory/add'),
                                      ),
                                      const SizedBox(height: 12),
                                      _QuickActionButton(
                                        icon: Icons.person_add,
                                        label: 'Add Employee',
                                        color: Colors.blue,
                                        onTap: () => Navigator.pushNamed(
                                            context, '/employees/add'),
                                      ),
                                      const SizedBox(height: 12),
                                      _QuickActionButton(
                                        icon: Icons.bar_chart,
                                        label: 'View Reports',
                                        color: Colors.orange,
                                        onTap: () => Navigator.pushNamed(
                                            context, '/reports'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Recent Orders
                            Expanded(
                              flex: 2,
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Recent Orders',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          TextButton(
                                            onPressed: () {},
                                            child: const Text('View All'),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      const _RecentOrderItem(
                                        orderNo: '#0048',
                                        time: '2:45 PM',
                                        items: '3 items',
                                        amount: '₱450.00',
                                        status: 'Completed',
                                      ),
                                      const Divider(height: 24),
                                      const _RecentOrderItem(
                                        orderNo: '#0047',
                                        time: '2:30 PM',
                                        items: '5 items',
                                        amount: '₱680.00',
                                        status: 'Completed',
                                      ),
                                      const Divider(height: 24),
                                      const _RecentOrderItem(
                                        orderNo: '#0046',
                                        time: '2:15 PM',
                                        items: '2 items',
                                        amount: '₱280.00',
                                        status: 'Completed',
                                      ),
                                      const Divider(height: 24),
                                      const _RecentOrderItem(
                                        orderNo: '#0045',
                                        time: '1:50 PM',
                                        items: '4 items',
                                        amount: '₱520.00',
                                        status: 'Completed',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Low Stock Alert
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.warning_amber_rounded,
                                      color: Colors.orange,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Low Stock Alert',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Row(
                                  children: [
                                    Expanded(
                                      child: _LowStockItem(
                                        name: 'Espresso Beans',
                                        stock: '2 kg',
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: _LowStockItem(
                                        name: 'Milk (Whole)',
                                        stock: '5 L',
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: _LowStockItem(
                                        name: 'Sugar',
                                        stock: '1 kg',
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: _LowStockItem(
                                        name: 'Cups (Medium)',
                                        stock: '15 pcs',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
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
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String percentage;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    percentage,
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
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

class _RecentOrderItem extends StatelessWidget {
  final String orderNo;
  final String time;
  final String items;
  final String amount;
  final String status;

  const _RecentOrderItem({
    required this.orderNo,
    required this.time,
    required this.items,
    required this.amount,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                orderNo,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$time • $items',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              amount,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LowStockItem extends StatelessWidget {
  final String name;
  final String stock;

  const _LowStockItem({
    required this.name,
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.orange.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Only $stock left',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
