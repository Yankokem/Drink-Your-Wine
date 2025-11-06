import 'package:flutter/material.dart';

class EmployeeCard extends StatelessWidget {
  final int userId;
  final String firstName;
  final String lastName;
  final String username;
  final String role;
  final String? contact;
  final bool isSelected;
  final VoidCallback onTap;

  const EmployeeCard({
    super.key,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.role,
    this.contact,
    required this.isSelected,
    required this.onTap,
  });

  String get fullName => '$firstName $lastName';

  Color getRoleColor() {
    return role.toLowerCase() == 'admin' 
        ? Colors.purple 
        : Colors.blue;
  }

  IconData getRoleIcon() {
    return role.toLowerCase() == 'admin'
        ? Icons.admin_panel_settings
        : Icons.person;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected 
              ? Theme.of(context).primaryColor 
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Profile Picture
              CircleAvatar(
                radius: 30,
                backgroundColor: getRoleColor().withOpacity(0.1),
                child: Text(
                  firstName[0].toUpperCase() + lastName[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: getRoleColor(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Employee Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '@$username',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (contact != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            contact!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              
              // Role Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
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
                      size: 16,
                      color: getRoleColor(),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      role,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: getRoleColor(),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 12),
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}