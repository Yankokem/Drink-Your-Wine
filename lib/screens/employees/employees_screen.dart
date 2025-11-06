import 'package:flutter/material.dart';

import '../../widgets/compact_side_bar.dart';
import '../../widgets/employees/employee_card.dart';
import '../../widgets/page_header.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  String selectedTab = 'Employees';
  String searchQuery = '';
  String sortBy = 'Name';

  // Sample employee data
  final List<Map<String, dynamic>> employees = [
    {
      'user_id': 1,
      'first_name': 'John',
      'last_name': 'Doe',
      'username': 'johndoe',
      'password': 'encrypted_password_hash',
      'contact': '09171234567',
      'role': 'Admin',
    },
    {
      'user_id': 2,
      'first_name': 'Jane',
      'last_name': 'Smith',
      'username': 'janesmith',
      'password': 'encrypted_password_hash',
      'contact': '09187654321',
      'role': 'Staff',
    },
    {
      'user_id': 3,
      'first_name': 'Michael',
      'last_name': 'Johnson',
      'username': 'mjohnson',
      'password': 'encrypted_password_hash',
      'contact': '09191234567',
      'role': 'Staff',
    },
    {
      'user_id': 4,
      'first_name': 'Sarah',
      'last_name': 'Williams',
      'username': 'swilliams',
      'password': 'encrypted_password_hash',
      'contact': '09161234567',
      'role': 'Admin',
    },
    {
      'user_id': 5,
      'first_name': 'David',
      'last_name': 'Brown',
      'username': 'dbrown',
      'password': 'encrypted_password_hash',
      'contact': '09151234567',
      'role': 'Staff',
    },
    {
      'user_id': 6,
      'first_name': 'Emily',
      'last_name': 'Davis',
      'username': 'edavis',
      'password': 'encrypted_password_hash',
      'contact': '09141234567',
      'role': 'Staff',
    },
  ];

  List<Map<String, dynamic>> get filteredEmployees {
    var filtered = employees.where((employee) {
      final fullName =
          '${employee['first_name']} ${employee['last_name']}'.toLowerCase();
      final username = employee['username'].toLowerCase();
      final search = searchQuery.toLowerCase();

      return fullName.contains(search) || username.contains(search);
    }).toList();

    if (sortBy == 'Name') {
      filtered.sort((a, b) => '${a['first_name']} ${a['last_name']}'
          .compareTo('${b['first_name']} ${b['last_name']}'));
    } else if (sortBy == 'Role') {
      filtered.sort((a, b) => a['role'].compareTo(b['role']));
    } else if (sortBy == 'Username') {
      filtered.sort((a, b) => a['username'].compareTo(b['username']));
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Compact Sidebar
          const CompactSideBar(currentRoute: '/employees'),

          // Main Content
          Expanded(
            child: Column(
              children: [
                // Page Header
                const PageHeader(title: 'Employee Management'),

                // Content
                Expanded(
                  child: Container(
                    color: const Color(0xFFF5F5F5),
                    child: Column(
                      children: [
                        // Tab Section & Controls
                        Container(
                          padding: const EdgeInsets.all(24),
                          color: Colors.white,
                          child: Column(
                            children: [
                              // Tabs
                              Row(
                                children: [
                                  _TabButton(
                                    label: 'Employees',
                                    isSelected: selectedTab == 'Employees',
                                    onTap: () {
                                      setState(() {
                                        selectedTab = 'Employees';
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 16),
                                  _TabButton(
                                    label: 'Attendance',
                                    isSelected: selectedTab == 'Attendance',
                                    onTap: () {
                                      setState(() {
                                        selectedTab = 'Attendance';
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 16),
                                  _TabButton(
                                    label: 'Activity Log',
                                    isSelected: selectedTab == 'Activity Log',
                                    onTap: () {
                                      setState(() {
                                        selectedTab = 'Activity Log';
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Search, Sort & Add Button
                              Row(
                                children: [
                                  // Search Bar
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Search employees...',
                                        prefixIcon: const Icon(Icons.search),
                                        filled: true,
                                        fillColor: const Color(0xFFF5F5F5),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          searchQuery = value;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // Sort Dropdown
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: DropdownButton<String>(
                                      value: sortBy,
                                      underline: const SizedBox(),
                                      items: ['Name', 'Role', 'Username']
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text('Sort by: $value'),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          sortBy = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // Add Employee Button
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/employees/add');
                                    },
                                    icon: const Icon(Icons.add),
                                    label: const Text('Add Employee'),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Content Based on Selected Tab
                        Expanded(
                          child: _buildTabContent(),
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

  Widget _buildTabContent() {
    switch (selectedTab) {
      case 'Employees':
        return _buildEmployeesGrid();
      case 'Attendance':
        return _buildAttendanceView();
      case 'Activity Log':
        return _buildActivityLogView();
      default:
        return _buildEmployeesGrid();
    }
  }

  Widget _buildEmployeesGrid() {
    if (filteredEmployees.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No employees found',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: filteredEmployees.length,
      itemBuilder: (context, index) {
        final employee = filteredEmployees[index];
        return EmployeeCard(
          userId: employee['user_id'],
          firstName: employee['first_name'],
          lastName: employee['last_name'],
          username: employee['username'],
          role: employee['role'],
          contact: employee['contact'],
          isSelected: false,
          onTap: () {
            Navigator.pushNamed(
              context,
              '/employees/profile',
              arguments: employee,
            );
          },
        );
      },
    );
  }

  Widget _buildAttendanceView() {
    // Sample attendance data
    final attendanceData = [
      {
        'employee': 'John Doe',
        'date': '2024-11-06',
        'check_in': '08:45 AM',
        'check_out': '05:15 PM',
        'hours_worked': '8.5',
        'status': 'Present',
      },
      {
        'employee': 'Jane Smith',
        'date': '2024-11-06',
        'check_in': '09:00 AM',
        'check_out': '06:00 PM',
        'hours_worked': '9.0',
        'status': 'Present',
      },
      {
        'employee': 'Michael Johnson',
        'date': '2024-11-06',
        'check_in': '08:30 AM',
        'check_out': '04:45 PM',
        'hours_worked': '8.25',
        'status': 'Present',
      },
      {
        'employee': 'Sarah Williams',
        'date': '2024-11-06',
        'check_in': '--',
        'check_out': '--',
        'hours_worked': '0.0',
        'status': 'Absent',
      },
      {
        'employee': 'David Brown',
        'date': '2024-11-06',
        'check_in': '10:15 AM',
        'check_out': '06:30 PM',
        'hours_worked': '8.25',
        'status': 'Late',
      },
      {
        'employee': 'Emily Davis',
        'date': '2024-11-06',
        'check_in': '08:55 AM',
        'check_out': '05:30 PM',
        'hours_worked': '8.5',
        'status': 'Present',
      },
    ];

    return Padding(
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
                  Icons.access_time,
                  color: Theme.of(context).primaryColor,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Attendance',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Today\'s attendance records',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Date filter
              Container(
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
                    const Text('2024-11-06'),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Stats Cards
          Row(
            children: [
              _AttendanceStatCard(
                title: 'Present',
                count: '4',
                color: Colors.green,
                icon: Icons.check_circle,
              ),
              const SizedBox(width: 16),
              _AttendanceStatCard(
                title: 'Late',
                count: '1',
                color: Colors.orange,
                icon: Icons.schedule,
              ),
              const SizedBox(width: 16),
              _AttendanceStatCard(
                title: 'Absent',
                count: '1',
                color: Colors.red,
                icon: Icons.cancel,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Attendance Table
          Expanded(
            child: Card(
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
                            'Employee',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Date',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Check In',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Check Out',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Hours',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Status',
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
                  Expanded(
                    child: ListView.separated(
                      itemCount: attendanceData.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        color: Colors.grey.shade200,
                      ),
                      itemBuilder: (context, index) {
                        final attendance = attendanceData[index];
                        return _AttendanceRow(
                          employee: attendance['employee'] as String,
                          date: attendance['date'] as String,
                          checkIn: attendance['check_in'] as String,
                          checkOut: attendance['check_out'] as String,
                          hoursWorked: attendance['hours_worked'] as String,
                          status: attendance['status'] as String,
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
    );
  }

  Widget _buildActivityLogView() {
    // Sample activity log data for all employees
    final activityLogs = [
      {
        'employee': 'John Doe',
        'action': 'Logged in',
        'timestamp': '2024-11-06 09:00 AM',
        'details': 'User logged into the system',
        'type': 'authentication',
      },
      {
        'employee': 'Jane Smith',
        'action': 'Sale Transaction',
        'timestamp': '2024-11-06 10:30 AM',
        'details': 'Processed sale #0048 - ₱450.00',
        'type': 'sale',
      },
      {
        'employee': 'Michael Johnson',
        'action': 'Product Updated',
        'timestamp': '2024-11-06 11:15 AM',
        'details': 'Updated inventory for Espresso Beans',
        'type': 'inventory',
      },
      {
        'employee': 'Sarah Williams',
        'action': 'Sale Transaction',
        'timestamp': '2024-11-06 01:45 PM',
        'details': 'Processed sale #0052 - ₱680.00',
        'type': 'sale',
      },
      {
        'employee': 'David Brown',
        'action': 'Logged out',
        'timestamp': '2024-11-06 06:00 PM',
        'details': 'User logged out from the system',
        'type': 'authentication',
      },
      {
        'employee': 'Emily Davis',
        'action': 'Inventory Check',
        'timestamp': '2024-11-06 04:30 PM',
        'details': 'Performed daily inventory count',
        'type': 'inventory',
      },
    ];

    return Padding(
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
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Activity Log',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Recent activities across all employees',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Activity Log Table
          Expanded(
            child: Card(
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
                            'Employee',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
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
                  Expanded(
                    child: ListView.separated(
                      itemCount: activityLogs.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        color: Colors.grey.shade200,
                      ),
                      itemBuilder: (context, index) {
                        final log = activityLogs[index];
                        return _ActivityLogRow(
                          employee: log['employee'] as String,
                          action: log['action'] as String,
                          details: log['details'] as String,
                          timestamp: log['timestamp'] as String,
                          type: log['type'] as String,
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
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}

class _AttendanceStatCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;
  final IconData icon;

  const _AttendanceStatCard({
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

class _AttendanceRow extends StatelessWidget {
  final String employee;
  final String date;
  final String checkIn;
  final String checkOut;
  final String hoursWorked;
  final String status;

  const _AttendanceRow({
    required this.employee,
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.hoursWorked,
    required this.status,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return Colors.green;
      case 'late':
        return Colors.orange;
      case 'absent':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Employee
          Expanded(
            flex: 2,
            child: Text(
              employee,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),

          // Date
          Expanded(
            flex: 2,
            child: Text(
              date,
              style: const TextStyle(fontSize: 14),
            ),
          ),

          // Check In
          Expanded(
            flex: 2,
            child: Text(
              checkIn,
              style: TextStyle(
                fontSize: 14,
                color: checkIn == '--' ? Colors.grey.shade400 : Colors.black,
              ),
            ),
          ),

          // Check Out
          Expanded(
            flex: 2,
            child: Text(
              checkOut,
              style: TextStyle(
                fontSize: 14,
                color: checkOut == '--' ? Colors.grey.shade400 : Colors.black,
              ),
            ),
          ),

          // Hours Worked
          Expanded(
            flex: 2,
            child: Text(
              '$hoursWorked hrs',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Status
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: _getStatusColor(status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _getStatusColor(status).withOpacity(0.3),
                ),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _getStatusColor(status),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityLogRow extends StatelessWidget {
  final String employee;
  final String action;
  final String details;
  final String timestamp;
  final String type;

  const _ActivityLogRow({
    required this.employee,
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
          // Employee
          Expanded(
            flex: 2,
            child: Text(
              employee,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),

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
                  style: const TextStyle(fontSize: 14),
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
