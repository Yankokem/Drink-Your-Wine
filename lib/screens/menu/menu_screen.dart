import 'package:flutter/material.dart';

import '../../widgets/compact_side_bar.dart';
import '../../widgets/menu/item_card.dart';
import '../../widgets/menu/menu_card.dart';
import '../../widgets/page_header.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String selectedTab = 'Items';
  String _itemSearchQuery = '';
  String _menuSearchQuery = '';
  String _itemFilter = 'All';
  String _menuFilter = 'All';

  // Mock data for items
  final List<Map<String, dynamic>> _items = [
    {
      'id': 1,
      'name': 'Espresso',
      'price': 120.00,
      'description': 'Rich and bold espresso shot',
      'image': 'https://via.placeholder.com/150',
      'container': 'Cup - S',
      'ingredients': [
        {'name': 'Espresso Beans', 'quantity': 18.0, 'unit': 'g'},
        {'name': 'Water', 'quantity': 30.0, 'unit': 'ml'},
      ],
    },
    {
      'id': 2,
      'name': 'Cappuccino',
      'price': 150.00,
      'description': 'Perfect balance of espresso and steamed milk',
      'image': 'https://via.placeholder.com/150',
      'container': 'Cup - M',
      'ingredients': [
        {'name': 'Espresso Beans', 'quantity': 18.0, 'unit': 'g'},
        {'name': 'Whole Milk', 'quantity': 120.0, 'unit': 'ml'},
      ],
    },
  ];

  // Mock data for menus
  final List<Map<String, dynamic>> _menus = [
    {
      'id': 1,
      'name': 'Coffee Lovers Bundle',
      'price': 450.00,
      'description': 'Perfect combo for coffee enthusiasts',
      'image': 'https://via.placeholder.com/150',
      'items': [
        {'name': 'Espresso', 'price': 120.00},
        {'name': 'Cappuccino', 'price': 150.00},
        {'name': 'Croissant', 'price': 80.00},
      ],
    },
  ];

  List<Map<String, dynamic>> get _filteredItems {
    return _items.where((item) {
      final matchesSearch = item['name']
          .toString()
          .toLowerCase()
          .contains(_itemSearchQuery.toLowerCase());
      return matchesSearch;
    }).toList();
  }

  List<Map<String, dynamic>> get _filteredMenus {
    return _menus.where((menu) {
      final matchesSearch = menu['name']
          .toString()
          .toLowerCase()
          .contains(_menuSearchQuery.toLowerCase());
      return matchesSearch;
    }).toList();
  }

  void _deleteItem(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _items.removeWhere((item) => item['id'] == id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Item deleted successfully'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteMenu(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Menu'),
        content: const Text('Are you sure you want to delete this menu?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _menus.removeWhere((menu) => menu['id'] == id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Menu deleted successfully'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
          const CompactSideBar(currentRoute: '/menu'),
          Expanded(
            child: Column(
              children: [
                // Page Header
                const PageHeader(title: 'Menu Management'),

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
                                    label: 'Items',
                                    isSelected: selectedTab == 'Items',
                                    onTap: () {
                                      setState(() {
                                        selectedTab = 'Items';
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 16),
                                  _TabButton(
                                    label: 'Menus',
                                    isSelected: selectedTab == 'Menus',
                                    onTap: () {
                                      setState(() {
                                        selectedTab = 'Menus';
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Search and Filter Bar
                              if (selectedTab == 'Items')
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        onChanged: (value) => setState(() {
                                          _itemSearchQuery = value;
                                        }),
                                        decoration: InputDecoration(
                                          hintText: 'Search items...',
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
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F5F5),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: DropdownButton<String>(
                                        value: _itemFilter,
                                        underline: const SizedBox(),
                                        items: ['All', 'Hot', 'Cold', 'Pastry']
                                            .map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text('Filter: $value'),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _itemFilter = value!;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    ElevatedButton.icon(
                                      onPressed: () => Navigator.pushNamed(
                                        context,
                                        '/menu/item/add',
                                      ),
                                      icon: const Icon(Icons.add),
                                      label: const Text('Add Item'),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (selectedTab == 'Menus')
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        onChanged: (value) => setState(() {
                                          _menuSearchQuery = value;
                                        }),
                                        decoration: InputDecoration(
                                          hintText: 'Search menus...',
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
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F5F5),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: DropdownButton<String>(
                                        value: _menuFilter,
                                        underline: const SizedBox(),
                                        items: ['All', 'Bundle', 'Special']
                                            .map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text('Filter: $value'),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _menuFilter = value!;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    ElevatedButton.icon(
                                      onPressed: () => Navigator.pushNamed(
                                        context,
                                        '/menu/menu/add',
                                      ),
                                      icon: const Icon(Icons.add),
                                      label: const Text('Add Menu'),
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
    if (selectedTab == 'Items') {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'All Items (${_filteredItems.length})',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.70, // Adjusted to prevent overflow
                ),
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  return ItemCard(
                    itemData: _filteredItems[index],
                    onEdit: () => Navigator.pushNamed(
                      context,
                      '/menu/item/edit',
                      arguments: _filteredItems[index],
                    ),
                    onDelete: () => _deleteItem(_filteredItems[index]['id']),
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/menu/item/view',
                      arguments: _filteredItems[index],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'All Menus (${_filteredMenus.length})',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.70, // Adjusted to prevent overflow
                ),
                itemCount: _filteredMenus.length,
                itemBuilder: (context, index) {
                  return MenuCard(
                    menuData: _filteredMenus[index],
                    onEdit: () => Navigator.pushNamed(
                      context,
                      '/menu/menu/edit',
                      arguments: _filteredMenus[index],
                    ),
                    onDelete: () => _deleteMenu(_filteredMenus[index]['id']),
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/menu/menu/view',
                      arguments: _filteredMenus[index],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
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
