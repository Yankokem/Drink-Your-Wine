import 'package:flutter/material.dart';

import '../../widgets/compact_side_bar.dart';
import '../../widgets/page_header.dart';
import '../../widgets/employees/audit_log_tab.dart';
import '../../widgets/employees/attendance_tab.dart';
import '../../widgets/employees/profile_tab.dart';
import '../../widgets/employees/sales_history_tab.dart';

class EmployeeProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? employeeData;

  const EmployeeProfileScreen({
    super.key,
    this.employeeData,
  });

  @override
  State<EmployeeProfileScreen> createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> {
  String selectedTab = 'Profile';

  @override
  Widget build(BuildContext context) {
    final employee = widget.employeeData ?? {};

    return Scaffold(
      body: Row(
        children: [
          // Compact Sidebar
          const CompactSideBar(currentRoute: '/employees'),

          // Main Content
          Expanded(
            child: Column(
              children: [
                // Page Header with Back Button
                PageHeader(
                  title:
                      '${employee['first_name'] ?? ''} ${employee['last_name'] ?? ''}',
                  actions: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      tooltip: 'Back to Employees',
                    ),
                  ],
                ),

                // Content
                Expanded(
                  child: Container(
                    color: const Color(0xFFF5F5F5),
                    child: Column(
                      children: [
                        // Tab Section
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          color: Colors.white,
                          child: Row(
                            children: [
                              _TabButton(
                                label: 'Profile',
                                isSelected: selectedTab == 'Profile',
                                onTap: () {
                                  setState(() {
                                    selectedTab = 'Profile';
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
                              const SizedBox(width: 16),
                              _TabButton(
                                label: 'Sales History',
                                isSelected: selectedTab == 'Sales History',
                                onTap: () {
                                  setState(() {
                                    selectedTab = 'Sales History';
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
                            ],
                          ),
                        ),

                        // Tab Content
                        Expanded(
                          child: _buildTabContent(employee),
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

  Widget _buildTabContent(Map<String, dynamic> employee) {
    switch (selectedTab) {
      case 'Profile':
        return ProfileTab(employeeData: employee);
      case 'Activity Log':
        return ActivityLogTab(employeeData: employee);
      case 'Sales History':
        return SalesHistoryTab(employeeData: employee);
      case 'Attendance':
        return AttendanceTab(employeeData: employee);
      default:
        return ProfileTab(employeeData: employee);
    }
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
