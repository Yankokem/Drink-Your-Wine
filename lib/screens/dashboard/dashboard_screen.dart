import 'package:flutter/material.dart';

import '../../widgets/compact_side_bar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const CompactSideBar(currentRoute: '/dashboard'),
          Expanded(
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text('Dashboard',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 16,
                                color: Theme.of(context).primaryColor),
                            const SizedBox(width: 8),
                            Text('Nov 04, 2025',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Expanded(
                                child: _StatCard(
                                    title: 'Today\'s Sales',
                                    value: '₱12,450.00',
                                    icon: Icons.trending_up,
                                    color: Colors.green)),
                            SizedBox(width: 16),
                            Expanded(
                                child: _StatCard(
                                    title: 'Orders',
                                    value: '48',
                                    icon: Icons.receipt_long,
                                    color: Colors.blue)),
                            SizedBox(width: 16),
                            Expanded(
                                child: _StatCard(
                                    title: 'Revenue',
                                    value: '₱45,280.00',
                                    icon: Icons.account_balance_wallet,
                                    color: Colors.orange)),
                            SizedBox(width: 16),
                            Expanded(
                                child: _StatCard(
                                    title: 'Avg. Order',
                                    value: '₱259.38',
                                    icon: Icons.attach_money,
                                    color: Colors.purple)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Popular Items',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height: 16),
                                        _PopularItemTile(
                                            name: 'Iced Caramel Latte',
                                            sales: '24 sold',
                                            icon: Icons.coffee,
                                            color: Colors.brown),
                                        SizedBox(height: 12),
                                        _PopularItemTile(
                                            name: 'Espresso',
                                            sales: '18 sold',
                                            icon: Icons.local_cafe,
                                            color: Colors.deepOrange),
                                        SizedBox(height: 12),
                                        _PopularItemTile(
                                            name: 'Cappuccino',
                                            sales: '15 sold',
                                            icon: Icons.coffee_maker,
                                            color: Colors.amber),
                                        SizedBox(height: 12),
                                        _PopularItemTile(
                                            name: 'Chocolate Croissant',
                                            sales: '12 sold',
                                            icon: Icons.bakery_dining,
                                            color: Colors.orange),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                flex: 2,
                                child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Ongoing Orders',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height: 16),
                                        _RecentOrderItem(
                                            orderNo: '#0048',
                                            time: '2:45 PM',
                                            items: '3 items',
                                            amount: '₱450.00',
                                            status: 'Grab',
                                            statusColor: Colors.green),
                                        Divider(height: 24),
                                        _RecentOrderItem(
                                            orderNo: '#0047',
                                            time: '2:30 PM',
                                            items: '5 items',
                                            amount: '₱680.00',
                                            status: 'Foodpanda',
                                            statusColor: Colors.pink),
                                        Divider(height: 24),
                                        _RecentOrderItem(
                                            orderNo: '#0046',
                                            time: '2:15 PM',
                                            items: '2 items',
                                            amount: '₱280.00',
                                            status: 'Grab',
                                            statusColor: Colors.green),
                                        Divider(height: 24),
                                        _RecentOrderItem(
                                            orderNo: '#0045',
                                            time: '1:50 PM',
                                            items: '4 items',
                                            amount: '₱520.00',
                                            status: 'Foodpanda',
                                            statusColor: Colors.pink),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Card(
                          elevation: 2,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.warning_amber_rounded,
                                        color: Colors.orange),
                                    const SizedBox(width: 8),
                                    Text('Low Stock Alert',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Row(
                                  children: [
                                    Expanded(
                                        child: _LowStockItem(
                                            name: 'Espresso Beans',
                                            stock: '2 kg')),
                                    SizedBox(width: 16),
                                    Expanded(
                                        child: _LowStockItem(
                                            name: 'Milk (Whole)',
                                            stock: '5 L')),
                                    SizedBox(width: 16),
                                    Expanded(
                                        child: _LowStockItem(
                                            name: 'Sugar', stock: '1 kg')),
                                    SizedBox(width: 16),
                                    Expanded(
                                        child: _LowStockItem(
                                            name: 'Cups (Medium)',
                                            stock: '15 pcs')),
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
  const _StatCard(
      {required this.title,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PopularItemTile extends StatelessWidget {
  final String name;
  final String sales;
  final IconData icon;
  final Color color;
  const _PopularItemTile(
      {required this.name,
      required this.sales,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text(sales,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
        ],
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
  final Color statusColor;
  const _RecentOrderItem(
      {required this.orderNo,
      required this.time,
      required this.items,
      required this.amount,
      required this.status,
      required this.statusColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(orderNo,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text('$time • $items',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(amount,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4)),
              child: Text(status,
                  style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
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
  const _LowStockItem({required this.name, required this.stock});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Text('Only $stock left',
              style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }
}
