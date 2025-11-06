import 'package:flutter/material.dart';

class ActivityLogTab extends StatelessWidget {
  final Map<String, dynamic> employeeData;

  const ActivityLogTab({
    super.key,
    required this.employeeData,
  });

  @override
  Widget build(BuildContext context) {
    // Sample activity log data
    final activities = [
      {
        'action': 'Logged in',
        'timestamp': '2024-11-06 09:00 AM',
        'details': 'User logged into the system',
        'type': 'authentication',
      },
      {
        'action': 'Sale Transaction',
        'timestamp': '2024-11-06 10:30 AM',
        'details': 'Processed sale #0048 - ₱450.00',
        'type': 'sale',
      },
      {
        'action': 'Product Updated',
        'timestamp': '2024-11-06 11:15 AM',
        'details': 'Updated inventory for Espresso Beans',
        'type': 'inventory',
      },
      {
        'action': 'Sale Transaction',
        'timestamp': '2024-11-06 01:45 PM',
        'details': 'Processed sale #0052 - ₱680.00',
        'type': 'sale',
      },
      {
        'action': 'Logged out',
        'timestamp': '2024-11-06 06:00 PM',
        'details': 'User logged out from the system',
        'type': 'authentication',
      },
    ];

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
                  Icons.history,
                  color: Theme.of(context).primaryColor,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Activity Log',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Recent activities by ${employeeData['first_name']} ${employeeData['last_name']}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Stats Cards
          Row(
            children: [
              _ActivityStatCard(
                title: 'Total Activities',
                count: activities.length.toString(),
                color: Colors.blue,
                icon: Icons.history,
              ),
              const SizedBox(width: 16),
              _ActivityStatCard(
                title: 'Sales Today',
                count: '2',
                color: Colors.green,
                icon: Icons.point_of_sale,
              ),
              const SizedBox(width: 16),
              _ActivityStatCard(
                title: 'Last Active',
                count: 'Today',
                color: Colors.orange,
                icon: Icons.access_time,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Activity Table
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
                          'Action',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Details',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Timestamp',
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
                  itemCount: activities.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: Colors.grey.shade200,
                  ),
                  itemBuilder: (context, index) {
                    final activity = activities[index];
                    return _ActivityTableRow(
                      action: activity['action'] as String,
                      details: activity['details'] as String,
                      timestamp: activity['timestamp'] as String,
                      type: activity['type'] as String,
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

class _ActivityStatCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;
  final IconData icon;

  const _ActivityStatCard({
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

class _ActivityTableRow extends StatelessWidget {
  final String action;
  final String details;
  final String timestamp;
  final String type;

  const _ActivityTableRow({
    required this.action,
    required this.details,
    required this.timestamp,
    required this.type,
  });

  Color _getTypeColor(String type) {
    switch (type) {
      case 'sale':
        return Colors.green;
      case 'inventory':
        return Colors.orange;
      case 'authentication':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'sale':
        return Icons.point_of_sale;
      case 'inventory':
        return Icons.inventory;
      case 'authentication':
        return Icons.security;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Action with Icon
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _getTypeColor(type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    _getTypeIcon(type),
                    color: _getTypeColor(type),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  action,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Details
          Expanded(
            flex: 3,
            child: Text(
              details,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),

          // Timestamp
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 4),
                Text(
                  timestamp,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
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
