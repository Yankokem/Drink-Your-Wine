import 'package:flutter/material.dart';

class CompactSideBar extends StatelessWidget {
  final String currentRoute;

  const CompactSideBar({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
            ),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.wine_bar,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          
          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _CompactSideBarItem(
                  icon: Icons.dashboard,
                  tooltip: 'Dashboard',
                  route: '/dashboard',
                  currentRoute: currentRoute,
                  onTap: () => _navigateTo(context, '/dashboard'),
                ),
                const SizedBox(height: 8),
                _CompactSideBarItem(
                  icon: Icons.point_of_sale,
                  tooltip: 'POS',
                  route: '/pos',
                  currentRoute: currentRoute,
                  onTap: () => _navigateTo(context, '/pos'),
                ),
                const SizedBox(height: 16),
                const Divider(color: Colors.white24, height: 1),
                const SizedBox(height: 16),
                _CompactSideBarItem(
                  icon: Icons.inventory_2,
                  tooltip: 'Inventory',
                  route: '/inventory',
                  currentRoute: currentRoute,
                  onTap: () => _navigateTo(context, '/inventory'),
                ),
                const SizedBox(height: 8),
                _CompactSideBarItem(
                  icon: Icons.people,
                  tooltip: 'Employees',
                  route: '/employees',
                  currentRoute: currentRoute,
                  onTap: () => _navigateTo(context, '/employees'),
                ),
                const SizedBox(height: 16),
                const Divider(color: Colors.white24, height: 1),
                const SizedBox(height: 16),
                _CompactSideBarItem(
                  icon: Icons.bar_chart,
                  tooltip: 'Reports',
                  route: '/reports',
                  currentRoute: currentRoute,
                  onTap: () => _navigateTo(context, '/reports'),
                ),
                const SizedBox(height: 8),
                _CompactSideBarItem(
                  icon: Icons.settings,
                  tooltip: 'Settings',
                  route: '/settings',
                  currentRoute: currentRoute,
                  onTap: () => _navigateTo(context, '/settings'),
                ),
              ],
            ),
          ),
          
          // User Profile & Logout
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                Tooltip(
                  message: 'Admin User',
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Tooltip(
                  message: 'Logout',
                  child: IconButton(
                    onPressed: () => _handleLogout(context),
                    icon: const Icon(Icons.logout),
                    color: Colors.white,
                    iconSize: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, String route) {
    if (currentRoute != route) {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _CompactSideBarItem extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final String route;
  final String currentRoute;
  final VoidCallback onTap;

  const _CompactSideBarItem({
    required this.icon,
    required this.tooltip,
    required this.route,
    required this.currentRoute,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = currentRoute == route;

    return Tooltip(
      message: tooltip,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Material(
          color: isActive
              ? Colors.white.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }
}