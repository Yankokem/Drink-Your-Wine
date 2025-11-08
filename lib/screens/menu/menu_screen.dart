import 'package:flutter/material.dart';

import '../../widgets/compact_side_bar.dart';
import '../../widgets/menu/item_card.dart';
import '../../widgets/menu/menu_card.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                // Top Bar
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Menu Management',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                ),

                // Tabs
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Theme.of(context).primaryColor,
                    tabs: const [
                      Tab(
                        icon: Icon(Icons.coffee),
                        text: 'Items',
                      ),
                      Tab(
                        icon: Icon(Icons.restaurant_menu),
                        text: 'Menus',
                      ),
                    ],
                  ),
                ),

                // Tab Views
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Items Tab
                      Container(
                        color: const Color(0xFFF5F5F5),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'All Items (${_items.length})',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () => Navigator.pushNamed(
                                    context,
                                    '/menu/item/add',
                                  ),
                                  icon: const Icon(Icons.add, size: 20),
                                  label: const Text('Add Item'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Expanded(
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.75,
                                ),
                                itemCount: _items.length,
                                itemBuilder: (context, index) {
                                  return ItemCard(
                                    itemData: _items[index],
                                    onEdit: () => Navigator.pushNamed(
                                      context,
                                      '/menu/item/edit',
                                      arguments: _items[index],
                                    ),
                                    onDelete: () =>
                                        _deleteItem(_items[index]['id']),
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      '/menu/item/view',
                                      arguments: _items[index],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Menus Tab
                      Container(
                        color: const Color(0xFFF5F5F5),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'All Menus (${_menus.length})',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () => Navigator.pushNamed(
                                    context,
                                    '/menu/menu/add',
                                  ),
                                  icon: const Icon(Icons.add, size: 20),
                                  label: const Text('Add Menu'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Expanded(
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.75,
                                ),
                                itemCount: _menus.length,
                                itemBuilder: (context, index) {
                                  return MenuCard(
                                    menuData: _menus[index],
                                    onEdit: () => Navigator.pushNamed(
                                      context,
                                      '/menu/menu/edit',
                                      arguments: _menus[index],
                                    ),
                                    onDelete: () =>
                                        _deleteMenu(_menus[index]['id']),
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      '/menu/menu/view',
                                      arguments: _menus[index],
                                    ),
                                  );
                                },
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
          ),
        ],
      ),
    );
  }
}
