import 'package:flutter/material.dart';

import '../../widgets/compact_side_bar.dart';
import '../../widgets/page_header.dart';

class EditEmployeeScreen extends StatefulWidget {
  final Map<String, dynamic>? employeeData;

  const EditEmployeeScreen({
    super.key,
    this.employeeData,
  });

  @override
  State<EditEmployeeScreen> createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _usernameController;
  late TextEditingController _contactController;

  late String selectedRole;
  DateTime? selectedDateHired;
  bool _changePassword = false;
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with employee data if available
    final employee = widget.employeeData ?? {};
    _firstNameController =
        TextEditingController(text: employee['first_name'] ?? '');
    _lastNameController =
        TextEditingController(text: employee['last_name'] ?? '');
    _usernameController =
        TextEditingController(text: employee['username'] ?? '');
    _contactController = TextEditingController(text: employee['contact'] ?? '');
    selectedRole = employee['role'] ?? 'Staff';

    // Parse date hired if available
    if (employee['date_hired'] != null) {
      try {
        selectedDateHired = DateTime.parse(employee['date_hired']);
      } catch (e) {
        selectedDateHired = null;
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _contactController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _selectDateHired() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateHired ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDateHired) {
      setState(() {
        selectedDateHired = picked;
      });
    }
  }

  void _updateEmployee() {
    if (_formKey.currentState!.validate()) {
      if (selectedDateHired == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select date hired'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // TODO: Implement update functionality with Supabase
      final updatedData = {
        'user_id': widget.employeeData?['user_id'],
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'username': _usernameController.text.trim(),
        'contact': _contactController.text.trim(),
        'role': selectedRole,
        'date_hired': selectedDateHired!.toIso8601String(),
      };

      if (_changePassword) {
        updatedData['password'] =
            _newPasswordController.text; // Should be hashed
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Employee updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Row(
        children: [
          // Compact Sidebar
          const CompactSideBar(currentRoute: '/employees'),

          // Main Content
          Expanded(
            child: Column(
              children: [
                // Page Header
                PageHeader(
                  title: 'Edit Employee',
                  actions: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'ID: #${widget.employeeData?['user_id'].toString().padLeft(4, '0') ?? '0000'}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                // Content
                Expanded(
                  child: Container(
                    color: const Color(0xFFF5F5F5),
                    padding: const EdgeInsets.all(32),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Column - Personal & Contact Info
                            Expanded(
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Section Header
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Icon(
                                              Icons.person,
                                              color: Theme.of(context)
                                                  .primaryColor,
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
                                      const SizedBox(height: 32),

                                      // First Name
                                      TextFormField(
                                        controller: _firstNameController,
                                        decoration: const InputDecoration(
                                          labelText: 'First Name',
                                          prefixIcon:
                                              Icon(Icons.person_outline),
                                        ),
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Please enter first name';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),

                                      // Last Name
                                      TextFormField(
                                        controller: _lastNameController,
                                        decoration: const InputDecoration(
                                          labelText: 'Last Name',
                                          prefixIcon:
                                              Icon(Icons.person_outline),
                                        ),
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Please enter last name';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),

                                      // Contact Number
                                      TextFormField(
                                        controller: _contactController,
                                        decoration: const InputDecoration(
                                          labelText: 'Contact Number',
                                          prefixIcon: Icon(Icons.phone),
                                          hintText: '09171234567',
                                        ),
                                        keyboardType: TextInputType.phone,
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Please enter contact number';
                                          }
                                          if (value.length < 11) {
                                            return 'Contact number must be at least 11 digits';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),

                                      // Date Hired
                                      InkWell(
                                        onTap: _selectDateHired,
                                        child: InputDecorator(
                                          decoration: const InputDecoration(
                                            labelText: 'Date Hired',
                                            prefixIcon:
                                                Icon(Icons.calendar_today),
                                          ),
                                          child: Text(
                                            selectedDateHired == null
                                                ? 'Select date'
                                                : '${selectedDateHired!.year}-${selectedDateHired!.month.toString().padLeft(2, '0')}-${selectedDateHired!.day.toString().padLeft(2, '0')}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: selectedDateHired == null
                                                  ? Colors.grey.shade600
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),

                            // Right Column - Account Info & Role
                            Expanded(
                              child: Column(
                                children: [
                                  // Account Information Card
                                  Expanded(
                                    child: Card(
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(32),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Section Header
                                            Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .primaryColor
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Icon(
                                                    Icons.lock_outline,
                                                    color: Theme.of(context)
                                                        .primaryColor,
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
                                            const SizedBox(height: 32),

                                            // Username
                                            TextFormField(
                                              controller: _usernameController,
                                              decoration: const InputDecoration(
                                                labelText: 'Username',
                                                prefixIcon:
                                                    Icon(Icons.alternate_email),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.trim().isEmpty) {
                                                  return 'Please enter username';
                                                }
                                                if (value.length < 4) {
                                                  return 'Username must be at least 4 characters';
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(height: 20),

                                            // Change Password Checkbox
                                            CheckboxListTile(
                                              value: _changePassword,
                                              onChanged: (value) {
                                                setState(() {
                                                  _changePassword =
                                                      value ?? false;
                                                  if (!_changePassword) {
                                                    _newPasswordController
                                                        .clear();
                                                    _confirmPasswordController
                                                        .clear();
                                                  }
                                                });
                                              },
                                              title:
                                                  const Text('Change Password'),
                                              contentPadding: EdgeInsets.zero,
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading,
                                            ),

                                            // Password Fields (shown only if changing password)
                                            if (_changePassword) ...[
                                              const SizedBox(height: 12),
                                              TextFormField(
                                                controller:
                                                    _newPasswordController,
                                                obscureText:
                                                    _obscureNewPassword,
                                                decoration: InputDecoration(
                                                  labelText: 'New Password',
                                                  prefixIcon:
                                                      const Icon(Icons.lock),
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      _obscureNewPassword
                                                          ? Icons.visibility_off
                                                          : Icons.visibility,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _obscureNewPassword =
                                                            !_obscureNewPassword;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                validator: (value) {
                                                  if (_changePassword) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter new password';
                                                    }
                                                    if (value.length < 6) {
                                                      return 'Password must be at least 6 characters';
                                                    }
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(height: 20),
                                              TextFormField(
                                                controller:
                                                    _confirmPasswordController,
                                                obscureText:
                                                    _obscureConfirmPassword,
                                                decoration: InputDecoration(
                                                  labelText:
                                                      'Confirm New Password',
                                                  prefixIcon: const Icon(
                                                      Icons.lock_outline),
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      _obscureConfirmPassword
                                                          ? Icons.visibility_off
                                                          : Icons.visibility,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _obscureConfirmPassword =
                                                            !_obscureConfirmPassword;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                validator: (value) {
                                                  if (_changePassword) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please confirm new password';
                                                    }
                                                    if (value !=
                                                        _newPasswordController
                                                            .text) {
                                                      return 'Passwords do not match';
                                                    }
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(height: 20),
                                            ],

                                            const Spacer(),

                                            // Role Selection
                                            const Text(
                                              'Role',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: _RoleOption(
                                                    label: 'Staff',
                                                    icon: Icons.person,
                                                    color: Colors.blue,
                                                    isSelected:
                                                        selectedRole == 'Staff',
                                                    onTap: () {
                                                      setState(() {
                                                        selectedRole = 'Staff';
                                                      });
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: _RoleOption(
                                                    label: 'Manager',
                                                    icon: Icons.manage_accounts,
                                                    color: Colors.orange,
                                                    isSelected: selectedRole ==
                                                        'Manager',
                                                    onTap: () {
                                                      setState(() {
                                                        selectedRole =
                                                            'Manager';
                                                      });
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: _RoleOption(
                                                    label: 'Admin',
                                                    icon: Icons
                                                        .admin_panel_settings,
                                                    color: Colors.purple,
                                                    isSelected:
                                                        selectedRole == 'Admin',
                                                    onTap: () {
                                                      setState(() {
                                                        selectedRole = 'Admin';
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Action Buttons
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 20,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: _updateEmployee,
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 20,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            'Update Employee',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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

class _RoleOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleOption({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
