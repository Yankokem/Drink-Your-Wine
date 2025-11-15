import 'package:flutter/material.dart';

class ProfileTab extends StatefulWidget {
  final Map<String, dynamic> employeeData;

  const ProfileTab({
    super.key,
    required this.employeeData,
  });

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool _isPasswordVisible = false;

  Color getRoleColor() {
    final role = widget.employeeData['role']?.toLowerCase() ?? 'staff';
    switch (role) {
      case 'admin':
        return Colors.purple;
      case 'manager':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  IconData getRoleIcon() {
    final role = widget.employeeData['role']?.toLowerCase() ?? 'staff';
    switch (role) {
      case 'admin':
        return Icons.admin_panel_settings;
      case 'manager':
        return Icons.manage_accounts;
      default:
        return Icons.person;
    }
  }

  void _deactivateEmployee() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deactivate Employee'),
        content: Text(
          'Are you sure you want to deactivate ${widget.employeeData['first_name']} ${widget.employeeData['last_name']}? This will prevent them from accessing the system.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement deactivate functionality
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to employee list
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Employee deactivated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column - Profile Card
          Expanded(
            flex: 2,
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    // Profile Picture
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: getRoleColor().withOpacity(0.1),
                        border: Border.all(
                          color: getRoleColor(),
                          width: 4,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          widget.employeeData['first_name'][0].toUpperCase() +
                              widget.employeeData['last_name'][0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: getRoleColor(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Full Name
                    Text(
                      '${widget.employeeData['first_name']} ${widget.employeeData['last_name']}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Username
                    Text(
                      '@${widget.employeeData['username']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Role Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: getRoleColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            getRoleIcon(),
                            size: 20,
                            color: getRoleColor(),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.employeeData['role'] ?? 'Staff',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: getRoleColor(),
                            ),
                          ),
                        ],
                      ),
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
                                arguments: widget.employeeData,
                              );
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit Profile'),
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
                            onPressed: _deactivateEmployee,
                            icon: const Icon(Icons.block),
                            label: const Text('Deactivate'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
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
          ),
          const SizedBox(width: 24),

          // Right Column - Information Cards
          Expanded(
            flex: 3,
            child: Column(
              children: [
                // Personal Information Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.person,
                                color: Theme.of(context).primaryColor,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Personal Information',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _InfoRow(
                          label: 'First Name',
                          value: widget.employeeData['first_name'] ?? 'N/A',
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 16),
                        _InfoRow(
                          label: 'Last Name',
                          value: widget.employeeData['last_name'] ?? 'N/A',
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 16),
                        _InfoRow(
                          label: 'Contact Number',
                          value: widget.employeeData['contact'] ?? 'N/A',
                          icon: Icons.phone,
                        ),
                        const SizedBox(height: 16),
                        _InfoRow(
                          label: 'Date Hired',
                          value: widget.employeeData['date_hired'] != null
                              ? widget.employeeData['date_hired']
                                  .toString()
                                  .substring(0, 10)
                              : 'N/A',
                          icon: Icons.calendar_today,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Account Information Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.lock_outline,
                                color: Theme.of(context).primaryColor,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Account Information',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _InfoRow(
                          label: 'Employee ID',
                          value:
                              '#${widget.employeeData['user_id'].toString().padLeft(4, '0')}',
                          icon: Icons.badge,
                        ),
                        const SizedBox(height: 16),
                        _InfoRow(
                          label: 'Username',
                          value: '@${widget.employeeData['username'] ?? 'N/A'}',
                          icon: Icons.alternate_email,
                        ),
                        const SizedBox(height: 16),
                        _PasswordRow(
                          password:
                              widget.employeeData['password'] ?? '••••••••',
                          isVisible: _isPasswordVisible,
                          onToggle: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        _InfoRow(
                          label: 'Status',
                          value: widget.employeeData['status'] ?? 'Active',
                          icon: Icons.info_outline,
                          valueColor:
                              widget.employeeData['status']?.toLowerCase() ==
                                      'active'
                                  ? Colors.green
                                  : Colors.red,
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

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey.shade600,
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
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PasswordRow extends StatelessWidget {
  final String password;
  final bool isVisible;
  final VoidCallback onToggle;

  const _PasswordRow({
    required this.password,
    required this.isVisible,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.lock,
          size: 20,
          color: Colors.grey.shade600,
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
                      isVisible ? password : '••••••••',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onToggle,
                    icon: Icon(
                      isVisible ? Icons.visibility_off : Icons.visibility,
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
