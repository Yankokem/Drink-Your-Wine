import 'package:flutter/material.dart';
import '../../widgets/compact_side_bar.dart';
import '../../widgets/page_header.dart';
import '../../widgets/employee_card.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  String searchQuery = '';
  String sortBy = 'Name';
  int? selectedEmployeeId;

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
  ];

  List<Map<String, dynamic>> get filteredEmployees {
    var filtered = employees.where((employee) {
      final fullName = '${employee['first_name']} ${employee['last_name']}'.toLowerCase();
      final username = employee['username'].toLowerCase();
      final search = searchQuery.toLowerCase();
      
      return fullName.contains(search) || username.contains(search);
    }).toList();

    if (sortBy == 'Name') {
      filtered.sort((a, b) => 
        '${a['first_name']} ${a['last_name']}'.compareTo(
          '${b['first_name']} ${b['last_name']}'
        )
      );
    } else if (sortBy == 'Role') {
      filtered.sort((a, b) => a['role'].compareTo(b['role']));
    } else if (sortBy == 'Username') {
      filtered.sort((a, b) => a['username'].compareTo(b['username']));
    }

    return filtered;
  }

  Map<String, dynamic>? get selectedEmployee {
    if (selectedEmployeeId == null) return null;
    try {
      return employees.firstWhere(
        (emp) => emp['user_id'] == selectedEmployeeId,
      );
    } catch (e) {
      return null;
    }
  }

  void _deleteEmployee() {
    if (selectedEmployee == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Employee'),
        content: Text(
          'Are you sure you want to delete ${selectedEmployee!['first_name']} ${selectedEmployee!['last_name']}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement delete functionality
              setState(() {
                employees.removeWhere((emp) => emp['user_id'] == selectedEmployeeId);
                selectedEmployeeId = null;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Employee deleted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
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
                const PageHeader(title: 'Employees'),

                // Content
                Expanded(
                  child: Row(
                    children: [
                      // Left Section - Employee List
                      Expanded(
                        flex: 3,
                        child: Container(
                          color: const Color(0xFFF5F5F5),
                          child: Column(
                            children: [
                              // Search, Sort & Add Button
                              Container(
                                padding: const EdgeInsets.all(24),
                                color: Colors.white,
                                child: Row(
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
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(
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
                                        Navigator.pushNamed(context, '/employees/add');
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
                              ),

                              // Employee Cards List
                              Expanded(
                                child: filteredEmployees.isEmpty
                                    ? Center(
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
                                      )
                                    : ListView.builder(
                                        padding: const EdgeInsets.all(24),
                                        itemCount: filteredEmployees.length,
                                        itemBuilder: (context, index) {
                                          final employee = filteredEmployees[index];
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 12),
                                            child: EmployeeCard(
                                              userId: employee['user_id'],
                                              firstName: employee['first_name'],
                                              lastName: employee['last_name'],
                                              username: employee['username'],
                                              role: employee['role'],
                                              contact: employee['contact'],
                                              isSelected: selectedEmployeeId == employee['user_id'],
                                              onTap: () {
                                                setState(() {
                                                  selectedEmployeeId = employee['user_id'];
                                                });
                                              },
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Right Section - Employee Details
                      Container(
                        width: 400,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(-2, 0),
                            ),
                          ],
                        ),
                        child: selectedEmployee == null
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person_outline,
                                      size: 80,
                                      color: Colors.grey.shade300,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Select an employee',
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'to view details',
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SingleChildScrollView(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Profile Picture
                                    Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: (selectedEmployee!['role'].toLowerCase() == 'admin'
                                                ? Colors.purple
                                                : Colors.blue)
                                            .withOpacity(0.1),
                                        border: Border.all(
                                          color: selectedEmployee!['role'].toLowerCase() == 'admin'
                                              ? Colors.purple
                                              : Colors.blue,
                                          width: 3,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          selectedEmployee!['first_name'][0].toUpperCase() +
                                              selectedEmployee!['last_name'][0].toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 48,
                                            fontWeight: FontWeight.bold,
                                            color: selectedEmployee!['role'].toLowerCase() == 'admin'
                                                ? Colors.purple
                                                : Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),

                                    // Full Name
                                    Text(
                                      '${selectedEmployee!['first_name']} ${selectedEmployee!['last_name']}',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),

                                    // Role Badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: (selectedEmployee!['role'].toLowerCase() == 'admin'
                                                ? Colors.purple
                                                : Colors.blue)
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            selectedEmployee!['role'].toLowerCase() == 'admin'
                                                ? Icons.admin_panel_settings
                                                : Icons.person,
                                            size: 18,
                                            color: selectedEmployee!['role'].toLowerCase() == 'admin'
                                                ? Colors.purple
                                                : Colors.blue,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            selectedEmployee!['role'],
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: selectedEmployee!['role'].toLowerCase() == 'admin'
                                                  ? Colors.purple
                                                  : Colors.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 32),

                                    // Employee Information
                                    _InfoRow(
                                      icon: Icons.badge,
                                      label: 'Employee ID',
                                      value: '#${selectedEmployee!['user_id'].toString().padLeft(4, '0')}',
                                    ),
                                    const SizedBox(height: 16),
                                    _InfoRow(
                                      icon: Icons.person_outline,
                                      label: 'Username',
                                      value: '@${selectedEmployee!['username']}',
                                    ),
                                    const SizedBox(height: 16),
                                    _PasswordRow(
                                      password: selectedEmployee!['password'] ?? '••••••••',
                                    ),
                                    const SizedBox(height: 16),
                                    _InfoRow(
                                      icon: Icons.phone,
                                      label: 'Contact Number',
                                      value: selectedEmployee!['contact'] ?? 'N/A',
                                    ),
                                    const SizedBox(height: 16),
                                    _InfoRow(
                                      icon: Icons.person,
                                      label: 'First Name',
                                      value: selectedEmployee!['first_name'],
                                    ),
                                    const SizedBox(height: 16),
                                    _InfoRow(
                                      icon: Icons.person,
                                      label: 'Last Name',
                                      value: selectedEmployee!['last_name'],
                                    ),

                                    const SizedBox(height: 32),

                                    // Action Buttons
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton.icon(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                context,
                                                '/employees/edit',
                                                arguments: selectedEmployee,
                                              );
                                            },
                                            icon: const Icon(Icons.edit),
                                            label: const Text('Edit'),
                                            style: OutlinedButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(
                                                vertical: 16,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              side: BorderSide(
                                                color: Theme.of(context).primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: _deleteEmployee,
                                            icon: const Icon(Icons.delete),
                                            label: const Text('Delete'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              padding: const EdgeInsets.symmetric(
                                                vertical: 16,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordRow extends StatefulWidget {
  final String password;

  const _PasswordRow({
    required this.password,
  });

  @override
  State<_PasswordRow> createState() => _PasswordRowState();
}

class _PasswordRowState extends State<_PasswordRow> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.lock,
            size: 20,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Password',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _isVisible ? widget.password : '••••••••',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isVisible = !_isVisible;
                      });
                    },
                    icon: Icon(
                      _isVisible ? Icons.visibility_off : Icons.visibility,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}